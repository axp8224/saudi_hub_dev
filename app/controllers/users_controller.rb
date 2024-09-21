class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user, only: %i[edit update]
    
    def show
      @user = current_user
    end

    def edit
    end

    def update
      if @user.update(user_params)
        redirect_to root_path, notice: 'Profile updated successfully!'
      else
        render :edit
      end
    end

    private 

    def set_user
      @user = current_user
    end
  
    def user_params
      params.require(:user).permit(:full_name, :email, :avatar)
    end

  end
  