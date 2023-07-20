class BooksController < ApplicationController
    def new
        @book_new = Book.new
    end
    def create
        @book_new = Book.new(book_params)
        @book_new.save
        redirect_to books_path
    end
    def index
        @book_all = Book.all
    end
    private

    def book_params
        params.require(:book).permit(:title, :body)
    end
end