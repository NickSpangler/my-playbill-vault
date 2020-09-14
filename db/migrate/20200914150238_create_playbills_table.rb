class CreatePlaybillsTable < ActiveRecord::Migration
  def change
    create_table :playbills do |t|
      t.string :title
      t.string :image_url
      t.string :performance_date
      t.integer :rating
      t.string :review
      t.boolean :favorite
      t.integer :user_id
    end
  end
end
