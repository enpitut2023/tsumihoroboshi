class SearchesController < ApplicationController
  def index
    @range = params[:range]
    word = params[:word]
    if @range == 'Book'
      @tsundoku_searched = Tsundoku.joins(:book).where('books.title LIKE?',
                                                       "%#{word}%").where(user_id: params[:user_id])
    else
      @users_searched = User.where('name LIKE?', "%#{word}%")
    end
  end
end
