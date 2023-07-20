class TsundokusController < ApplicationController
    def edit
        @tsundoku = Tsundoku.find(params[:id])
    end
    def update
        @tsundoku = Tsundoku.find(params[:id])
        @tsundoku.update(tsundoku_params)
        redirect_to books_path
    end
    def destroy
        @tsundoku = Tsundoku.find(params[:id])
        @tsundoku.destroy
        redirect_to books_path
    end
    private

    def tsundoku_params
        params.require(:tsundoku).permit(:reading_status)
    end
end
