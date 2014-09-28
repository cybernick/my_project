namespace :db do
  desc "Fill database with data"
  task populate: :environment do
    make_users
    make_hotels
    make_ratings
    make_admin
  end
end

def make_admin
    email = "admin@hotels.org" 
    password  = "password"
    Admin.create!(email:    email,
                 password: password,
                 password_confirmation: password)
end

def make_users
  10.times do |n|
    username = "user-#{n+1}"
    email = "user-#{n+1}@hotels.org" 
    password  = "password"
    User.create!(username: username,email:    email,
                 password: password,
                 password_confirmation: password)
  end
end

def make_hotels
  users = User.all
  users.each { |user| 
    title = Faker::Company.name
    breakfast = [true, false].sample
    price_for_room = rand(1000) / (rand(100) + 1) 
    country = Faker::Address.country 
    state = Faker::Address.state
    city = Faker::Address.city
    street = Faker::Address.street_name
    room_description = Faker::Lorem.paragraph
    name_of_photo = File.open(File.join(Rails.root,"app/uploaders/#{user.id}.jpeg"))
    user.hotels.create!(title: title, breakfast: breakfast, price_for_room: price_for_room, 
                        country: country,state: state,city: city,street: street, 
                        room_description: room_description, name_of_photo: name_of_photo) 
  }
end

def make_ratings
  users = User.all
  hotels = Hotel.all
  ratings = Rating.all
  hotels.each {|hotel|
    users.each {|user|
      value=rand(5)
      comment = Faker::Lorem.sentence
      if (user.id==hotel.user_id)
      else
        ratings.create!(user_id: user.id, hotel_id: hotel.id, value: value, comment: comment)
      end
    }
  }
end