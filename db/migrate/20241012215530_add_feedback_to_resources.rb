class AddFeedbackToResources < ActiveRecord::Migration[7.0]
  def change
    add_column :resources, :feedback, :string
  end
end
