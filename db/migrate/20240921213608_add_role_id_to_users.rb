class AddRoleIdToUsers < ActiveRecord::Migration[7.0]
  def change
    # Add role_id column without default first
    add_reference :users, :role, foreign_key: true

    # Ensure the default is set after the roles have been created
    reversible do |dir|
      dir.up do
        # Ensure roles are populated before setting the default
        user_role = Role.find_by(name: 'user') || Role.create(name: 'user', can_moderate: false, can_promote: false)
        change_column_default :users, :role_id, user_role.id
      end
    end
  end
end
