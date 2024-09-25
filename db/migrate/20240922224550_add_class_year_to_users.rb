class AddClassYearToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :class_year, foreign_key: true

    reversible do |dir|
      dir.up do
        user_class_year = ClassYear.find_by(name: 'Unspecified') || ClassYear.create!(name: 'Unspecified')
        change_column_default :users, :class_year_id, user_class_year.id
      end
    end
  end
end
