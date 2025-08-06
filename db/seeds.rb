# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'faker'

puts "Clearing old data..."
Book.destroy_all
Author.destroy_all
Publisher.destroy_all
User.destroy_all

User.create!(
  name: "Example User",
  email: "example@example.com",
  password: "password",
  password_confirmation: "password",
  date_of_birth: Date.new(2000, 1, 1),
  gender: "male",
  admin: true,
  activated: true, 
  activated_at: Time.zone.now
)

99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  gender = ["male", "female", "other"].sample
  date_of_birth = Faker::Date.birthday(min_age: 18, max_age: 65)
  User.create!(
    name: name,
    email: email,
    password: password,
    password_confirmation: password,
    gender: gender,
    date_of_birth: date_of_birth,
    activated: true, 
    activated_at: Time.zone.now
  )
end

authors = []
10.times do
  authors << Author.create!(
    name: Faker::Book.author,
    bio: Faker::Lorem.paragraph(sentence_count: 3),
    birth_date: Faker::Date.birthday(min_age: 40, max_age: 90),
    death_date: [nil, Faker::Date.between(from: 10.years.ago, to: Date.today)].sample,
    nationality: Faker::Address.country
  )
end

publishers = []
5.times do
  publishers << Publisher.create!(
    name: Faker::Book.publisher,
    address: Faker::Address.full_address,
    phone_number: Faker::PhoneNumber.phone_number,
    email: Faker::Internet.email,
    website: Faker::Internet.url
  )
end

50.times do
  total_quantity = rand(5..30)
  Book.create!(
    title: Faker::Book.title,
    description: Faker::Lorem.paragraph(sentence_count: 5),
    publication_year: rand(1990..2024),
    total_quantity: total_quantity,
    available_quantity: rand(1..total_quantity),
    borrow_count: rand(0..50),
    author: authors.sample,
    publisher: publishers.sample
  )
end
