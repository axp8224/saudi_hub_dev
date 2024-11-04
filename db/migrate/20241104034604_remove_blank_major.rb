class RemoveBlankMajor < ActiveRecord::Migration[7.0]
  def change
    User.where(major_id: 1).update_all(major_id: nil)
    Major.where(name: '').delete_all
  end
end
