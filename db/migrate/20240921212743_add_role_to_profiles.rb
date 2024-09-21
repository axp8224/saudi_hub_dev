class AddRoleToProfiles < ActiveRecord::Migration[7.0]
  def change
    add_reference :profiles, :role, foreign_key: true

    reversible do |dir| 
      admin_role = Role.find_by(name: 'admin')

      if admin_role 
        Profile.where(role_id: nil).update_all(role_id: admin_role.id)
      end
    end
  end
end
