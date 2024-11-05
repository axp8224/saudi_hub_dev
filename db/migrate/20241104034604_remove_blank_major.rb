class RemoveBlankMajor < ActiveRecord::Migration[7.0]
  def change
    blank_major = Major.find_by(name: '')
    return unless blank_major

    User.where(major_id: blank_major.id).update_all(major_id: nil)
    blank_major.delete
  end
end
