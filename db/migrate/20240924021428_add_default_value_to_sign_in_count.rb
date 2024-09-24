class AddDefaultValueToSignInCount < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :sign_in_count, from: nil, to: 0
  end
end
