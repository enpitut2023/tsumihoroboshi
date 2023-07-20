class BooksController < ApplicationController
    def new
        @book_new = Book.new
    end
end