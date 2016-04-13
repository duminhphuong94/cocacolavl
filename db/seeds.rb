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

  users = User.order(:created_at).take(50)
  50.times do
  title = Faker::Lorem.word
  body = Faker::Lorem.sentence(6)
  users.each { |user| user.entries.create!(title: title,body: body,picture: "ch_m_c.jpg") }
  end

  # Following relationships
users = User.all
user  = users.first
following = users[2..50]
followers = users[1..10]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

entries = Entry.order(:created_at).take(10)
#comment_user = users[2..50]
3.times do
  content = Faker::Lorem.sentence(5)
  entries.each { |entry| entry.comments.create!(content: content,user_id: 1) }
end

entriesa = Entry.order(:created_at).take(40)
entriesa.each { |entry| user.like(entry)}
