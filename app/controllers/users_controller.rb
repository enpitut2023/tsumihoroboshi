class UsersController < ApplicationController
    before_action :authenticate_user!, only: [:edit, :update, :level_up]

    def beginning_of_previous_month(num) #今月からnum月前の初日を返す。
        today=Date.today
        pMonth=today.month-num
        pYear=today.year
        if pMonth < 1
          pMonth -= 1
          pYear -= 1
        end
        return Date.new(pYear,pMonth,1)
      end
    
      def beginning_of_next_month(num) #今月からnum月前の初日を返す。
        today=Date.today
        pMonth=today.month+num
        pYear=today.year
        if pMonth >12
          pMonth -= 12
          pYear += 1
        end
        return Date.new(pYear,pMonth,1)
      end 

    def show
        @user = User.find(params[:id])
        @tsundoku_todo = @user.tsundokus.where(reading_status: 0)
        @tsundoku_doing = @user.tsundokus.where(reading_status: 1)
        @tsundoku_done = @user.tsundokus.where(reading_status: 2)
        @list=[[],[]]
        #deadline = params.fetch(:deadline, Date.today).to_date
        #@deadlines = Tsundoku.where(deadline: deadline.beginning_of_month.beginning_of_week..deadline.end_of_month.end_of_week,user_id: @user.id)

        2.times do |i|
            deadline = params.fetch(:deadline, beginning_of_next_month(i)).to_date
            @deadlines = Tsundoku.where(deadline: deadline.beginning_of_month...deadline.end_of_month,user_id: @user.id)
            @list[i][0]=@deadlines
            @list[i][1]=beginning_of_next_month(i)
        end
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

    def level_up
        @user = User.find(params[:id])
        if current_user != @user
            redirect_to user_path(current_user.id)
        else
            current_user.update(exp: current_user.exp + @login_exp)
            redirect_to user_path(current_user.id)
        end
    end

    private

    def user_params
        user = User.find(params[:id])
        if user.current_level < 5
            params.require(:user).permit(:name, :email, :image, :exp)
        else
            params.require(:user).permit(:name, :email, :image, :exp)
        end
    end
end
