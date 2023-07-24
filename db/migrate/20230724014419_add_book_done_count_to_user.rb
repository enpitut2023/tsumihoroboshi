class AddBookDoneCountToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :book_done_count, :integer, default: 0
  end
end
