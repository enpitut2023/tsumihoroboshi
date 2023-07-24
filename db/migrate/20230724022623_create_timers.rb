class CreateTimers < ActiveRecord::Migration[6.1]
  def change
    create_table :timers do |t|
      t.integer :duration, default: 0
      t.integer :user_id
      t.timestamps
    end
  end
end
