namespace :daily_onfleet_task do
  desc 'Post recurrences as tasks onto onfleet and update existing task statusess'
  task post_task: :environment do
    # This task is called at 7pm each day from Sunday - Thursday
    # Time.now.day is int for weekday 0 indexed at sunday.
    # Our day enum is zero indexed at monday.

    # TODAY: int representing tomorrow's day of week in recurrence enum
    # TOMORROW: datetime object represending tomorrow' date.

    # Run ONLY on sunday evening through thursday evening
    if Time.now.wday < 5
      tomorrow_wday = Time.now.wday
      tomorrow_date = Date.today + 1
      result = OnfleetAPI.post_batch_task(tomorrow_wday, tomorrow_date)
      posted = result[:posted]
      args = {:date => tomorrow_date, :tasks => posted}
      ExportAllRecurrences.new(args).export_all
    end
  end
end
