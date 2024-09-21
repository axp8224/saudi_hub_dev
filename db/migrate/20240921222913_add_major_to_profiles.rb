class AddMajorToProfiles < ActiveRecord::Migration[7.0]
  def change
    add_reference :profiles, :major, foreign_key: true
  end
end
