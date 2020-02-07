class Label < ApplicationRecord
  has_many :label_relations, dependent: :destroy
  has_many :tasks, through: :label_relations, source: :task
  belongs_to :user

  validates :name, presence: true
end
