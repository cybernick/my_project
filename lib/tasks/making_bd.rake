namespace :db do
  desc "Fill database with data"
  task populate: :environment do
    make_users
    make_articles
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

def make_articles
  users = User.all
  users.each { |user| 
    title = Faker::Company.name
    article_description = Faker::Lorem.paragraph
    name_of_photo = File.open(File.join(Rails.root,"app/uploaders/#{user.id}.jpeg"))
    user.articles.create!(title: title, article_description: article_description, name_of_photo: name_of_photo) 
  }
end

def make_ratings
  users = User.all
  articles = Article.all
  ratings = Rating.all
  articles.each {|article|
    users.each {|user|
      value=rand(5)
      comment = Faker::Lorem.sentence
      if (user.id==article.user_id)
      else
        ratings.create!(user_id: user.id, article_id: article.id, value: value, comment: comment)
      end
    }
  }
end