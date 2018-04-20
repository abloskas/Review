class UsersController < ApplicationController
  before_action :require_login, only: [:show, :edit, :update]
  # before_action :check_permission, only: [:show, :edit, :update]
  def index
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to "/events"
    else
      flash[:errors] = @user.errors.full_messages
      redirect_to "/users"
    end
  end

  def login
    @user = User.find_by_email(params[:email]).try(:authenticate, params[:password])
    if @user
      session[:user_id] = @user.id
      redirect_to "/events"
    else
      flash[:errors] = ["Invalid Username or Password"]
      redirect_to "/users"
    end
  end

  def show
  end

  def edit
  end

  def update
    @user = User.find(session[:user_id])
    p "**********************"
    p session[:user_id]
    @user.update(first_name:params[:first_name], last_name:params[:last_name], email:params[:email], city:params[:city], state:params[:state])
    if @user.errors.full_messages
      flash[:errors] = @user.errors.full_messages
    end
    redirect_to "/events"
  end

  def logout
    session[:user_id] = nil
    redirect_to "/users"
  end


  private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :city, :state, :password)
    end
end