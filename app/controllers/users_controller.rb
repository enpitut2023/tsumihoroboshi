class UsersController < ApplicationController
    def show
        @user = User.find(params[:id])
        @tsundoku_todo = @user.tsundokus.where(reading_status: 0)
        @tsundoku_doing = @user.tsundokus.where(reading_status: 1)
        @tsundoku_done = @user.tsundokus.where(reading_status: 2)
    end
end
