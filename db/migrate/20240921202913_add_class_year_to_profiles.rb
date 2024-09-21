class AddClassYearToProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :class_year, :integer
  end
end
