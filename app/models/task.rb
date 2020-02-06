class Task < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  validates :status, presence: true
  validates :priority, presence: true

  enum priority: {low: 0, medium: 1, high: 2}

  scope :search_by_name_and_status, -> (user_id,key1,key2) {where(user_id: user_id).where("name LIKE ?","%#{key1}%").where(status: key2)}
  scope :search_by_name, -> (user_id,key) {where(user_id: user_id).where("name LIKE ?","%#{key}%")}
  scope :search_by_status, -> (user_id,key) {where(user_id: user_id).where(status: key)}
  belongs_to :user

  has_many :label_relations
  has_many :labels, through: :label_relations, source: :label
  accepts_nested_attributes_for :labels

end


# task = Task.first
# task.labels.create(name: "test1")

# task = Task.last
# task.labels.create(name: "test2")
# task.labels.create(name: "test3")
# task.labels.create(name: "test4")

# user = task.user
# task = user.tasks.first
# task.labels.create(name: "test5")

# task = Task.last
# task.label_relations.create(label_id: 5)

# task.labels #　label_id: 5が含まれる必要あり
