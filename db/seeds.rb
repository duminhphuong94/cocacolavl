User.create!(name:  "Administrator",
             email: "admin@gmail.com",
             password:              "admin",
             password_confirmation: "admin",
             admin: true)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end
