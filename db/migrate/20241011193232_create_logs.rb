class CreateLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :logs do |t|
      t.string :user_email
      t.string :action
      t.text :description
      t.datetime :action_timestamp
    end
  end
end
