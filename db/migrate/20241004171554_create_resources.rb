class CreateResources < ActiveRecord::Migration[7.0]
  def change
    create_table :resources do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.references :resource_type, null: false, foreign_key: true
      t.text :description
      t.string :status

      t.timestamps
    end
  end
end
