class EventsController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :destroy]
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def index
    
    @q = Event.ransack(params[:q])
    @q.sorts = ['start_date asc'] if @q.sorts.empty?
    @events = Event.where("start_date >= ?", Time.zone.now.beginning_of_day)
    @events_by_day = @events.group_by { |t| t.start_date.beginning_of_day }
    @events = @q.result(distinct: true)

    @geektweet = twitter.search("to: meetgeekapp", result_type: "recent").take(3).collect do |tweet|
      "#{tweet.user.screen_name}: #{tweet.text}"
    end

  end

  def show
    @hash = Gmaps4rails.build_markers(@events) do |event, marker|
    marker.lat @event.latitude
    marker.lng @event.longitude
    end
    
    if params[:search].present?
    @events = Event.near(params[:search], 50, :order => :distance)
    else
    @events = Event.all
    end
  end

  def new
    @event = Event.new
  end

  def edit
  end

  def create
    @event = Event.new(event_params)
    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
    end
  end

  private
    def set_event
      @event = Event.find(params[:id])
    end

    def twitter 
      $twitter = Twitter::REST::Client.new do |config|
        config.consumer_key = "LAc61L7oFsSxr45ilnpBikXhg"
        config.consumer_secret = 'hBQhwqTwfQNaz6484qNjTXYCQeQsq5A0MzhrOqs3oNkug4RuOz'
        config.access_token = '4857079966-J0WFLCgsAN9p6QxzXhwSMqLpmkneTkvIZpDcqAT'
        config.access_token_secret = 'mjgp5v3YspLxI5khSutASd39IWIROwODeBtj1hANaRSfw'
      end
    end

    def event_params
      params.require(:event).permit(:name, :time, :host, :desc, :people, :price, :uid, :start_date, :adr, :event_url, :latitude, :longitude, :address)
    end
end
