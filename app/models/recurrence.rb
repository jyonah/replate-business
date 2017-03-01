# == Schema Information
#
# Table name: recurrences
#
#  id         :integer          not null, primary key
#  day        :integer          not null
#  frequency  :integer          not null
#  has_sent   :boolean          default(FALSE)
#  start_date :datetime         not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  pickup_id  :integer
#  start_time :string
#  end_time   :string
#  cancel     :boolean          default(FALSE), not null
#  driver_id  :string           default(""), not null
#

class Recurrence < ActiveRecord::Base
  belongs_to :pickup
  has_many :cancellations, :dependent => :destroy
  enum frequency: [:one_time, :weekly]
  enum day: [:monday, :tuesday, :wednesday, :thursday, :friday]

  def location
    self.pickup.location
  end

  def start_day
    Date.new(self.start_date.year, self.start_date.month, self.start_date.day)
  end

  def business
    self.pickup.location.business
  end

  def deliver_today?(date = Date.today)
    r_date = DateTime.new(self.start_date.year, self.start_date.month, self.start_date.day)
    r_date == date and self.day == Time.now.wday - 1
  end

  def post_on_demand
    OnfleetAPI.post_single_task(self, Date.today)
    args = {:date => Date.today, :tasks =>[self]}
    ExportAllRecurrences.new(args).export_on_demand_task
  end

  # Temporary assignment method since no load balancing drivers yet
  def assign_driver
    if self.location.state == 'California'
      self.driver_id = 'Wxi7dpU3VBVSQoEnG3CgMRjG'
    else
      self.driver_id = 'PWWyG9w4KS44JOlo2j2Dv8qT'
    end
  end

  def self.get_date_after(date, day)
    return date if date.wday == day.to_date.wday
    days_difference = (date - day.to_date).to_i
    result = day.to_date + days_difference + (day.to_date.wday - date.wday)
    result = result + 1.week if result.to_date < date
    return result
  end

  def same_week(day)
    today = Date.parse(day)
    start_date = self.start_date.to_date

    first_recurrence_date = Recurrence.get_date_after(start_date, self.day)
    same_week = first_recurrence_date.strftime('%U') == today.strftime('%U')
    same_year = first_recurrence_date.strftime('%Y') == today.strftime('%Y')
    if self.frequency === "one_time" and same_week and same_year
      return true
    end

    same_week = start_date.strftime('%U') == today.strftime('%U')
    same_year = start_date.strftime('%Y') == today.strftime('%Y')
    recurrence_date = Recurrence.get_date_after(today.at_beginning_of_week, self.day)
    if (same_week and same_year) or today >= start_date
      self.cancellations.each do |cancellation|
        if cancellation.same_day_as? recurrence_date
          return false
        end
      end
    end

    if self.frequency === "weekly"
      if same_week
        return (today.wday - 1) <= Recurrence.days[self.day]
      elsif today >= start_date
        return true
      end
    end
    # Write this method in the eventually
    # if self.frequency == 2
    #   ...
    return false
  end

  # args is hash:
  # args[:status] = string value of status enum, see Task model
  # args[:date] = date task was originally destined for
  # args[:onfleet_id] = onfleet id of task if succesfully posted
  def create_task(args)
    Task.create(scheduled_date: args[:date],
                onfleet_id: args[:onfleet_id],
                status: args[:status],
                driver: self.driver_id,
                location_id: self.location.id)
  end

  def onfleet_cancel
    o_id = self.onfleet_id
    if o_id
      # Try to remove from onfleet: will only be removed if task
      # is not completed
      resp = OnfleetAPI.delete_task(o_id)
      unless resp
        t = Task.where(onfleet_id: o_id).first
        t.update(status: 'cancelled') if task
        return
      end
    end
  end
end
