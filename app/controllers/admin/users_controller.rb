class Admin::UsersController < ApplicationController

  before_action :require_admin

  def index
    @users = User.all
  end  
      
  def show
  end
    
  def new
    @user = User.new
  end
    
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path, :flash => { :success => "User was successfully created!" }
    else 
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to users_path, :flash => { :success => "User was successfully updated!" }
    else
      render 'edit'
    end
  end
    
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path, :flash => { :success => "User was successfully destroyed!" }
  end

  private
   
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
