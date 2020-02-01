class AddPriorityColumnToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :priority, :string, null: false, default: 0
  end
end
