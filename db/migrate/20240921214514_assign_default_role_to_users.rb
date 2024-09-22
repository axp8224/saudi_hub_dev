class AssignDefaultRoleToUsers < ActiveRecord::Migration[7.0]
  def up
    user_role = Role.find_by(name: 'user') || Role.create(name: 'user', can_moderate: false, can_promote: false)

    # Update all users with a nil role_id to the "user" role
    User.where(role_id: nil).update_all(role_id: user_role.id)
  end
end
