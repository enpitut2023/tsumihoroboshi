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
    def edit
        @book = Book.find(params[:id])
    end
    def show
        @book = Book.find(params[:id])
    end
    def update
        @book = Book.find(params[:id])
        @book.update(book_params)
        redirect_to books_path
    end
    def destroy
        @book = Book.find(params[:id])
        @book.destroy
        redirect_to books_path
    end
    private

    def book_params
        params.require(:book).permit(:title, :body, :image)
    end
end