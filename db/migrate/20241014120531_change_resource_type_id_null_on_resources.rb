class ChangeResourceTypeIdNullOnResources < ActiveRecord::Migration[7.0]
  def change
    change_column_null :resources, :resource_type_id, true
  end
end
