class AddAllFieldsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :role, null: false, foreign_key: true
    add_column :users, :bio, :string
    add_reference :users, :major, foreign_key: true
    add_reference :users, :class_year, foreign_key: true
  end
end
