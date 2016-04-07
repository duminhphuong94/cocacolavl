class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.text :title
      t.text :body
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :entries, [:user_id, :created_at]
  end
end
