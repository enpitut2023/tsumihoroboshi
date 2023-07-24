class LikesController < ApplicationController
  def create
    book = Book.find(params[:book_id])
    current_user.addlike(book)
    redirect_back(fallback_location: root_path)
  end

  def destroy
    book = Book.find(params[:book_id])
    current_user.removelike(book)
    redirect_back(fallback_location: root_path)
  end
end
