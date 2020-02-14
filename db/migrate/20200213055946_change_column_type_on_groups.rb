class ChangeColumnTypeOnGroups < ActiveRecord::Migration[5.2]
  def change
    change_column :group_relations, :user_id, :'integer USING CAST(user_id AS integer)'
    change_column :group_relations, :group_id, :'integer USING CAST(group_id AS integer)'
    change_column :tasks, :group_id, :'integer USING CAST(group_id AS integer)'
  end
end
