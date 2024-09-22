class CreateClassYears < ActiveRecord::Migration[7.0]
  def change
    create_table :class_years do |t|
      t.string :name
      t.timestamps
    end
  end
end
