class UsersController < ApplicationController
    before_action :authenticate_user!
    
    def show
      @user = current_user
    end

    def index 
      @users = User.includes(:role, :major, :class_year).all
    end

  end
  