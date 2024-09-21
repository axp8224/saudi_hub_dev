class CreateRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :roles do |t|
      t.string :name
      t.boolean :can_moderate
      t.boolean :can_promote

      t.timestamps
    end
  end
end
