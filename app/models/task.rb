class Task < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  validates :status, presence: true


  scope :search_by_name_and_status, -> (key1,key2) {where("name LIKE ?","%#{key1}%").where(status: key2)}
  scope :search_by_name, -> (key) {where("name LIKE ?","%#{key}%")}
  scope :search_by_status, -> (key) {where(status: key)}
  #scope :search, -> (target){where("name LIKE ?","%#{params[:name_search]}%")}
  #scope :search, -> (target){where(status: "#{params[:status_search]}")}

end
