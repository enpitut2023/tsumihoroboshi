class BooksController < ApplicationController
    before_action :authenticate_user!, only: [:create, :update, :destroy]
    def new
        @book_new = Book.new
    end

    def create
        if params[:book][:isbn].present?
            if Book.find_by(isbn: params[:book][:isbn])
                @book = Book.find_by(isbn: params[:book][:isbn])
                if Tsundoku.find_by(book_id: @book.id, user_id: current_user.id)
                else
                    @tsundoku = Tsundoku.new
                    @tsundoku.book_id = @book.id
                    @tsundoku.user_id = current_user.id
                    @tsundoku.reading_status = 0
                    @tsundoku.save
                    if current_user.book_todo_count > 0
                        current_user.update(book_todo_count: current_user.book_todo_count - 1, exp: current_user.exp + @book_todo_exp)
                    end
                end
            else
                @book_new = Book.new(book_params)
                @book_new.save

                @tsundoku = Tsundoku.new
                @tsundoku.reading_status = 0
                @tsundoku.book_id = @book_new.id
                @tsundoku.user_id = current_user.id
                @tsundoku.save
                if current_user.book_todo_count > 0
                    current_user.update(book_todo_count: current_user.book_todo_count - 1, exp: current_user.exp + @book_todo_exp)
                end
            end
        else
            @book_new = Book.new(book_params)
            @book_new.save

            @tsundoku = Tsundoku.new
            @tsundoku.reading_status = 0
            @tsundoku.book_id = @book_new.id
            @tsundoku.user_id = current_user.id
            @tsundoku.save
            if current_user.book_todo_count > 0
                current_user.update(book_todo_count: current_user.book_todo_count - 1, exp: current_user.exp + @book_todo_exp)
            end
        end

        redirect_to user_path(current_user.id)
    end

    def index
        @book_all = Book.order(updated_at: :desc).limit(3)
        if params[:q].present? || params[:t].present? || params[:a].present? || params[:i].present?
            data = get_json_from_word(params[:q],params[:t],params[:a],params[:i])
            @book_from_api = format_books(data)
            @book_new = Book.new
        end
    end

    def get_json_from_word(keyword, title, author, isbn)
        qword = ""
        if keyword.present?
            qword += keyword       
        end
        if title.present?
            if qword.present?
                qword += "+intitle:" + title          
            else
                qword += "intitle:" + title 
            end
        end
        if author.present?
            if qword.present?
                qword += "+inauthor:" + author          
            else
                qword += "inauthor:" + author 
            end
        end
        if isbn.present?
            if qword.present?
                qword += "+isbn:" + isbn.to_s()          
            else
                qword += "isbn:" + isbn.to_s()
            end
        end
        query = URI.encode_www_form(q: qword)
        url = "https://www.googleapis.com/books/v1/volumes?" + query
        JSON.parse(Net::HTTP.get(URI.parse(url)))
    end

    def format_books(data)
        books = []
        if data["items"].present?
            data["items"].each do |item|
                book = {
                    title: nil,
                    body: nil,
                    image_url: nil,
                    isbn: nil
                }
                begin
                    book[:title] = item["volumeInfo"]["title"]
                    book[:body] = item["volumeInfo"]["description"]
                    if item["volumeInfo"]["industryIdentifiers"][1]["type"] == "ISBN_13"
                        book[:isbn] = item["volumeInfo"]["industryIdentifiers"][1]["identifier"]
                    else
                        book[:isbn] = item["volumeInfo"]["industryIdentifiers"][0]["identifier"]
                    end
                    book[:image_url] = item["volumeInfo"]["imageLinks"]["smallThumbnail"]
                rescue StandardError => e
                end
                books << book
            end
        end
        books
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
        params.require(:book).permit(:title, :body, :image, :image_url, :isbn)
    end
end