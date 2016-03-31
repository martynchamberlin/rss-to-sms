class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :guid

      t.timestamps null: false
    end
  end
end
