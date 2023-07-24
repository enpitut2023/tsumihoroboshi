class AddBookTodoCountToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :book_todo_count, :integer, default: 0
  end
end
