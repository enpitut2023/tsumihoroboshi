class CreateTsundokus < ActiveRecord::Migration[6.1]
  def change
    create_table :tsundokus do |t|
      t.integer :book_id
      t.integer :reading_status
      t.datetime :deadline
      t.timestamps
    end
  end
end
