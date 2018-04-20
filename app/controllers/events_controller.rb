class EventsController < ApplicationController
  before_action :require_login
  def index

    @home_events = Event.where("events.state = '#{current_user.state}'")
    @away_events = Event.where("events.state != '#{current_user.state}'")
  end

  def create
    Event.create(name:params[:name], date:params[:date], city:params[:city], state:params[:state], user:current_user)
    p "***************************************************"
    p params[:name]
    redirect_to "/events"
  end

  def show
    @user = User.find(session[:user_id])
    @event = Event.find(params[:id])
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    @event.update(name:params[:name], date:params[:date], city:params[:city], state:params[:state], user:current_user)
    redirect_to "/events"
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to "/events"
  end

  def join
    @user = User.find(session[:user_id])
    @event = Event.find(params[:id])
    @event.attendents += [@user]
    redirect_to "/events"

  end

  def leave
    @user = User.find(session[:user_id])
    @event = Event.find(params[:id])
    if @event.attendents.exists?(@user.id)
      @event.attendents.delete(@user)
    end
    redirect_to "/events"
  end

  def add
    @event = Event.find(params[:id])
    @comment = Comment.new(content:params[:content], user:current_user, event:@event)
    if @comment.save
    redirect_to "/events/#{@event.id}/show"
    else 
      flash[:errors] = @comment.errors.full_messages 
      redirect_to "/events/#{@event.id}/show"
    end
  end

  private
  def user_permissions
    user = User.find(params[:id])
    if user != current_user
        flash[:errors] = ['You do not have permission to this. Please login with your credentials.']
        redirect_to "/users"
    end
  end
end
