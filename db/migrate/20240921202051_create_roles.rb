class CreateRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :roles do |t|
      t.string :name, null: false
      t.boolean :can_moderate, default: false
      t.boolean :can_promote, default: false
      t.timestamps
    end
  end
end
