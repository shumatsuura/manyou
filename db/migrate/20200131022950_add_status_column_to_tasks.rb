class AddStatusColumnToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :status, :string, :null => false, :default => '未了'
  end
end
