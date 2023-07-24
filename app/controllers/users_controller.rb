class UsersController < ApplicationController
    before_action :authenticate_user!, only: [:edit, :update]

    
    def show
        @user = User.find(params[:id])
        @tsundoku_todo = @user.tsundokus.where(reading_status: 0)
        @tsundoku_doing = @user.tsundokus.where(reading_status: 1)
        @tsundoku_done = @user.tsundokus.where(reading_status: 2)
        deadline = params.fetch(:deadline, Date.today).to_date
        @deadlines = Tsundoku.where(deadline: deadline.beginning_of_month.beginning_of_week..deadline.end_of_month.end_of_week,user_id: @user.id)
      
    end
    def edit
        if User.find(params[:id]) != current_user
            redirect_to books_path
        end
        @user=User.find(params[:id])
    end

    def update
        if User.find(params[:id]) != current_user
            redirect_to books_path
        end
        @user = User.find(params[:id])
        @user.update(user_params)
        redirect_to user_path(current_user.id)
    end

    private

    def user_params
        params.require(:user).permit(:name, :email, :image)
    end
end
