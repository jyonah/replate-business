# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
$offices = ["Main Office", "NYC Office", "SF Office"]
NUM_BIZ = 5

def make_businesses
  1.upto(NUM_BIZ) do |n|
    business = Business.create(
      email: "b#{n}@example.com",
      password: "password",
      password_confirmation: "password",
      company_name: Faker::Company.name,
      phone: '925-222-2342',
      onfleet_id: "siouhasdfo",
    )
    business.id = n
    business.save
  end
end

def make_admin
  admin = Admin.create(
    email: "admin@email.com",
    first_name: "first",
    last_name: "last",
    password: "password",
    password_confirmation: "password",
  )
  admin.save
end

def make_locations
  1.upto(5) do |n|
    location = Location.create(
      number: "2333",
      street: "Channing Way",
      city: "Berkeley",
      state: "CA",
      zip: "10010",
      country: "USA",
      addr_name: "TEST DO NOT DELIVER"
    )

    location.id = n
    location.business = Business.find(n)
    location.save
  end

  1.upto(5) do |n|
    location = Location.create(
      number: "2333",
      street: "Channing Way",
      city: "Berkeley",
      state: "CA",
      zip: "10010",
      country: "USA",
      addr_name: "TEST DO NOT DELIVER"
    )
    location.id = n + 5
    location.business = Business.find(n)
    location.save
  end
end

def make_pickups
  1.upto(10) do |n|
    pickup = Pickup.create(
      title: "Lunchtime Pickup",
      comments: Faker::Lorem.sentence,
      location_id: n
    )

    pickup.id = n
    pickup.location = Location.find(n)
    pickup.save
  end

  1.upto(10) do |n|
    pickup = Pickup.create(
      title: "Dinner Pickup",
      comments: "If you arrive after 6pm, enter 12345 on the keypad to enter.",
      location_id: n
    )

    pickup.id = n + 10
    pickup.location = Location.find(n)
    pickup.save
  end
end

def randomtime
  start_time = ["9:00 AM", "10:00 AM", "11:00 AM", "12:00 PM"].sample
  end_time = ["1:00 PM", "2:00 PM", "3:00 PM", "4:00 PM", "5:00 PM"].sample
  [start_time, end_time]
end

def make_recurrences
  pickups = Pickup.all
  pickups.each do |pickup|
    0.upto(4) do |n|
      r = pickup.recurrences.create(
        day: n,
        frequency: [0, 1].sample,
        start_date: Time.now,
        start_time: randomtime[0],
        end_time: randomtime[1],
        pickup_id: pickup.id,
        #(this is helen's driver id)
        driver_id: '4zeEx71*c6skdFCtr0aNyh1Y'
      )
      r.location.update(addr_name: r.id)
    end
  end
end

def make_cancellations
  recurrences = Recurrence.all
  recurrences.each do |r|
    1.upto(3) do |n|
      r.cancellations.create(
        date: Date.today + (n * 7)
      )
    end
  end
end

make_businesses
make_locations
make_pickups
make_recurrences
make_cancellations
make_admin
