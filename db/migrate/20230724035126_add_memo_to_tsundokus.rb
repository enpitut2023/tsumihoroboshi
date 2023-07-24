class AddMemoToTsundokus < ActiveRecord::Migration[6.1]
  def change
    add_column :tsundokus, :memo, :text
  end
end
