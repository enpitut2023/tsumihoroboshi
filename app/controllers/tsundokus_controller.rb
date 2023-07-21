class TsundokusController < ApplicationController
    def create
        @tsundoku = Tsundoku.find_by(book_id:params[:book_id], user_id: current_user.id)
        if @tsundoku.blank?
            @tsundoku = Tsundoku.new
            @tsundoku.book_id = params[:book_id]
            @tsundoku.user_id = current_user.id
            @tsundoku.reading_status = 0
            @tsundoku.save
            redirect_to user_path(current_user.id)
        else
            redirect_to books_path
        end
    end
    
    def edit
        @tsundoku = Tsundoku.find(params[:id])
    end

    def update
        @tsundoku = Tsundoku.find(params[:id])
        @tsundoku.update(tsundoku_params)
        redirect_to user_path(current_user.id)
    end

    def destroy
        @tsundoku = Tsundoku.find(params[:id])
        @tsundoku.destroy
        redirect_to user_path(current_user.id)
    end
    
    private

    def tsundoku_params
        params.require(:tsundoku).permit(:reading_status, :deadline)
    end
end
