class CreateGroupRelations < ActiveRecord::Migration[5.2]
  def change
    create_table :group_relations do |t|
      t.string :user_id
      t.string :group_id

      t.timestamps
    end
    add_index :group_relations, [:user_id, :group_id], unique: true
  end
end
