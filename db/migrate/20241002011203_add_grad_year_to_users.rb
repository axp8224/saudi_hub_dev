class AddGradYearToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :grad_year, :integer
  end
end
