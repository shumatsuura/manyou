class Task < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  validates :status, presence: true
  validates :priority, presence: true

  enum priority: {low: 0, medium: 1, high: 2}

  scope :search_by_name, -> (key) {where("name LIKE ?","%#{key}%")}
  scope :search_by_status, -> (key) {where(status: key)}
  scope :search_by_label, -> (key) {where(id: LabelRelation.where(label_id: Label.where("name LIKE ?","%#{key}%").pluck(:id)).pluck(:task_id))}

  belongs_to :user

  has_many :label_relations
  has_many :labels, through: :label_relations, source: :label
  accepts_nested_attributes_for :labels

end
