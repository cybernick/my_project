FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "user-#{n+1}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "password"
    password_confirmation "password"
    number_of_hotel 0
    number_of_comment 0

    factory :invalid_user do
      email "pers"
      password "pas"
    end

  end

  factory :admin do
    email "admin@hotels.org"
    password "password"
    password_confirmation "password"
  end

  factory :hotel do
    sequence(:status ) {|n| "approved" }
  	sequence(:id )  { |n| n } 
    sequence(:title)  { |n| "hotel #{n}" }
    sequence(:rating)  { |n| "{n%5}" }
    breakfast true
    sequence(:room_description)  { |n| "good room #{n}" } 
    sequence(:price_for_room)  { |n| n }   
    sequence(:country)  { |n| "country #{n}" }  
    sequence(:state)  { |n| "state #{n}" }  
    sequence(:city )  { |n| "city" } 
    sequence(:street )  { |n| "street" } 
    user
    
    factory :invalid_hotel do
      title nil
    end

    factory :hotel_new do 
      title   "hotel"
      rating  "5" 
      breakfast true
      room_description  "good room " 
      price_for_room    600.0 
      country   "country "   
      state   "state " 
      city    "city"  
      street    "street" 
    end
  end



  factory :rating do
    value    5 
    comment "super"
    user
    hotel
  end
end
  
