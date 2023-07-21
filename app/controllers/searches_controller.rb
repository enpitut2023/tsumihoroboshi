class SearchesController < ApplicationController
    def index
        word = params[:word]
        @tsundoku_searched = Tsundoku.joins(:book).where("books.title LIKE?", "%#{word}%").where(user_id: params[:user_id])
    end
end
