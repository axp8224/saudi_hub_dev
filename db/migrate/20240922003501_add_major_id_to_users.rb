class AddMajorIdToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :major, foreign_key: true

    reversible do |dir|
      dir.up do
        user_major = Major.find_by(name: '') || Major.create(name: '')
        change_column_default :users, :major_id, user_major.id
      end
    end
  end
end
