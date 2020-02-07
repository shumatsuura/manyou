statuses = ['未着手','着手中','完了']


10.times do
  user_name = Faker::JapaneseMedia::DragonBall.character
  user_email = Faker::Internet.email
  password = "password"

  user = User.create(name: user_name,
                     email: user_email,
                     password: password,
                     password_confirmation: password
                   )
  10.times do |i|

  task_name = "test_name#{i}"
  description = "test"
  due = DateTime.now + rand(10).week
  status = statuses[rand(0..2)]
  priority = rand(0..2)

  task = user.tasks.build(name: task_name,
                          description: description,
                          due: due,
                          status: status,
                          priority: priority,
                          )
  task.save

  task.labels.create(name: "#{task_name}_label#{i}", user_id: task.user.id)
  end

end
