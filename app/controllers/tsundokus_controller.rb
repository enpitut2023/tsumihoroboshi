class TsundokusController < ApplicationController
  before_action :authenticate_user!, only: %i[create update destroy]
  def create
    @tsundoku = Tsundoku.find_by(book_id: params[:book_id], user_id: current_user.id)
    if @tsundoku.blank?
      @tsundoku = Tsundoku.new
      @tsundoku.book_id = params[:book_id]
      @tsundoku.user_id = current_user.id
      @tsundoku.reading_status = 0
      @tsundoku.save
      if current_user.book_todo_count > 0
        current_user.update(book_todo_count: current_user.book_todo_count - 1,
                            exp: current_user.exp + @book_todo_exp)
      end
      redirect_to user_path(current_user.id)
    else
      redirect_to user_path(current_user.id)
    end
  end

  def show
    @tsundoku = Tsundoku.find(params[:id])
  end

  def edit
    @tsundoku = Tsundoku.find(params[:id])
  end

  def update
    @tsundoku = Tsundoku.find(params[:id])
    if current_user != @tsundoku.user
      redirect_to user_path(current_user.id)
    else
      @tsundoku.update(tsundoku_params)
      if @tsundoku.reading_status == 2 and current_user.book_done_count > 0
        current_user.update(book_done_count: current_user.book_done_count - 1,
                            exp: current_user.exp + @book_done_exp)
      end
      redirect_to user_path(current_user.id)
    end
  end

  def destroy
    @tsundoku = Tsundoku.find(params[:id])
    @tsundoku.destroy
    redirect_to user_path(current_user.id)
  end

  private

  def tsundoku_params
    params.require(:tsundoku).permit(:reading_status, :deadline, :memo)
  end
end
