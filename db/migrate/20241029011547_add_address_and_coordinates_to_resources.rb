class AddAddressAndCoordinatesToResources < ActiveRecord::Migration[7.0]
  def change
    add_column :resources, :address, :string
    add_column :resources, :latitude, :float
    add_column :resources, :longitude, :float
  end
end
