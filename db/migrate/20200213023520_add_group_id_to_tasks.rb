class AddGroupIdToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :group_id, :string
  end
end
