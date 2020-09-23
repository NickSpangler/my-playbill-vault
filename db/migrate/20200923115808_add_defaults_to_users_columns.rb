class AddDefaultsToUsersColumns < ActiveRecord::Migration
  def change
    change_column_default :users, :stars, true
    change_column_default :users, :dates, true
    change_column_default :users, :order, "date_new_to_old"
  end
end
