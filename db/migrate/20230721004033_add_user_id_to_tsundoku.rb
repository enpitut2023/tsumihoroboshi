class AddUserIdToTsundoku < ActiveRecord::Migration[6.1]
  def change
    add_column :tsundokus, :user_id, :integer
  end
end
