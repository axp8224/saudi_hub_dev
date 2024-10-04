class CreateResourceTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :resource_types do |t|
      t.string :title

      t.timestamps
    end
  end
end
