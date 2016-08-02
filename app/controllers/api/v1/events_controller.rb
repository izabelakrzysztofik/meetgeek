class Api::V1::EventsController < ActionController::Base
  before_filter :authenticate_user_from_token!
  before_action :authenticate_user!, only: [:edit, :update, :destroy]
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def index
    @events = Event.all
    render json: @events
  end

  def show
  	render json: @event
  end
  
  def create
    @event = Event.new(event_params)
      if @event.save
        render :show, status: :created, location: @event
      else
        render json: @event.errors, status: :unprocessable_entity
      end
  end

  def update
      if @event.update(event_params)
        render :show, status: :ok, location: @event
      else
        render json: @event.errors, status: :unprocessable_entity
      end
  end

  def destroy
    @event.destroy
    head :no_content
  end

  private
    def set_event
      @event = Event.find(params[:id])
    end

    def event_params
      params.require(:event).permit(:name, :time, :host, :desc, :people, :price, :uid, :date, :adr, :event_url)
    end
  
    def authenticate_user_from_token!
      user_email = params[:user_email].presence
      user       = user_email && User.find_by_email(user_email)

      if user && Devise.secure_compare(user.authentication_token, params[:user_token])
        sign_in user, store: false
      end
    end
end