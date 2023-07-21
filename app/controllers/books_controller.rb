class BooksController < ApplicationController
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
                end
            else
                @book_new = Book.new(book_params)
                @book_new.save

                @tsundoku = Tsundoku.new
                @tsundoku.reading_status = 0
                @tsundoku.book_id = @book_new.id
                @tsundoku.user_id = current_user.id
                @tsundoku.save
            end
        else
            @book_new = Book.new(book_params)
            @book_new.save

            @tsundoku = Tsundoku.new
            @tsundoku.reading_status = 0
            @tsundoku.book_id = @book_new.id
            @tsundoku.user_id = current_user.id
            @tsundoku.save
        end

        redirect_to books_path
    end

    def index
        @book_all = Book.all
        if params[:q].present?
            data = get_json_from_word(params[:q])
            @book_from_api = format_books(data)
            @book_new = Book.new
        end
    end

    def get_json_from_word(word)
        query = URI.encode_www_form(q: word)
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