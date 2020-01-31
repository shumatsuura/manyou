50.times do |n|
  name = "test_name"
  description = "test"
  due = DateTime.now + rand(10).week
  Task.create!(name: name,
               description: description,
               due: due
               status: '未着手'
               )
end
