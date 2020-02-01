50.times do |n|
  name = "test_name"
  description = "test"
  due = DateTime.now + rand(10).week
  Task.create!(name: name,
               description: description,
               due: due,
               status: '未着手',
               priority: 0,
              )
end

50.times do |n|
  name = "test_name"
  description = "test"
  due = DateTime.now + rand(10).week
  Task.create!(name: name,
               description: description,
               due: due,
               status: '着手中',
               priority: 1,
               )
end

50.times do |n|
  name = "test_name"
  description = "test"
  due = DateTime.now + rand(10).week
  Task.create!(name: name,
               description: description,
               due: due,
               status: '完了',
               priority: 2,
               )
end
