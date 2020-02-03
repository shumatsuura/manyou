statuses = ['未着手','着手中','完了']


50.times do |n|
  name = "test_name#{n}"
  description = "test"
  due = DateTime.now + rand(10).week
  status = statuses[rand(0..2)]
  priority = rand(0..2)
  Task.create!(name: name,
               description: description,
               due: due,
               status: status,
               priority: priority,
              )
end
