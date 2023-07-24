class CreateLoginHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :login_histories do |t|
      t.integer :user_id
      t.datetime :login_at
      t.timestamps
    end
  end
end
