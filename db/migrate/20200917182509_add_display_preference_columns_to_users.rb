class AddDisplayPreferenceColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :stars, :boolean
    add_column :users, :dates, :boolean
    add_column :users, :order, :string
  end
end
