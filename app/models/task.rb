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

end
