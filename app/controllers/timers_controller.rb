class TimersController < ApplicationController
    def start
        @timer = Timer.new
        @user = User.find(params[:user_id])
        @timer.user_id = current_user.id
        @timer.duration = 0
        @timer.save
        render json: { id: @timer.id }
    end
    
    def stop
        @user = User.find(params[:user_id])
        @timer = Timer.find(params[:id])
        @timer.update(duration: params[:duration] / 1000)
        @user.update(exp: @user.exp + @timer.duration / 60)
        render json: { message: 'Timer stopped and duration saved.' }
    end

    def destroy
        @timer = Timer.find(params[:id])
        @timer.destroy
        render json: { message: 'Timer deleted.' }
    end
end
