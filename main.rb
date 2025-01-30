# Gemfile
gem 'zoom_rb'

# Run bundle install to install the gem
# $ bundle install

# config/initializers/zoom.rb
Zoom.configure do |c|
    c.api_key = ENV['ZOOM_API_KEY']
    c.api_secret = ENV['ZOOM_API_SECRET']
end

# app/controllers/zoom_controller.rb
class ZoomController < ApplicationController
    before_action :authenticate_user!

    def create_meeting
        client = Zoom.new
        meeting = client.meeting_create(user_id: current_user.zoom_user_id, topic: params[:topic], start_time: params[:start_time])
        render json: meeting
    end

    def list_meetings
        client = Zoom.new
        meetings = client.meeting_list(user_id: current_user.zoom_user_id)
        render json: meetings
    end

    def add_user
        client = Zoom.new
        user = client.user_create(email: params[:email], first_name: params[:first_name], last_name: params[:last_name], type: 1)
        render json: user
    end
end

# config/routes.rb
Rails.application.routes.draw do
    post 'zoom/create_meeting', to: 'zoom#create_meeting'
    get 'zoom/list_meetings', to: 'zoom#list_meetings'
    post 'zoom/add_user', to: 'zoom#add_user'
end

# app/models/user.rb
class User < ApplicationRecord
    # Assuming Devise is used for authentication
    devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

    # Add a field to store Zoom user ID
    field :zoom_user_id, type: String
end