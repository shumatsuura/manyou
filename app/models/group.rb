class Group < ApplicationRecord
  belongs_to :user
  has_many :group_relations
  has_many :group_members, through: :group_relations, source: :group
  
end
