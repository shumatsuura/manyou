class Group < ApplicationRecord
  belongs_to :user
  has_many :group_relations, dependent: :destroy
  has_many :members, through: :group_relations, source: :user

  validates :name, presence: true
  validates :description, presence: true
  
end
