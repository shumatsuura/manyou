class AddUserRefToLabelTable < ActiveRecord::Migration[5.2]
  def change
    add_reference :labels, :user, index: true, foreign_key: true
  end
end
