class ZoomController < ApplicationController
    # Ensure the user is authenticated before accessing any action
    before_action :authenticate_user!
    # Skip CSRF verification for webhook action
    skip_before_action :verify_authenticity_token, only: [:webhook]

    # Create a new Zoom meeting
    def create_meeting
        client = Zoom.new
        meeting = client.meeting_create(user_id: current_user.zoom_user_id, topic: params[:topic], start_time: params[:start_time])

        # Save meeting details to the database
        Meeting.create(
            user: current_user,
            topic: params[:topic],
            start_time: params[:start_time],
            duration: meeting['duration'],
            recording_url: meeting['recording_files'].first['download_url']
        )

        # Return the meeting details as JSON
        render json: meeting
    end

    # List all Zoom meetings for the current user
    def list_meetings
        client = Zoom.new
        meetings = client.meeting_list(user_id: current_user.zoom_user_id)
        render json: meetings
    end

    # Add a new user to Zoom
    def add_user
        if User.exists?(email: params[:email])
            # Return an error if the email is already registered
            render json: { error: 'Email already registered' }, status: :unprocessable_entity
        else
            client = Zoom.new
            user = client.user_create(email: params[:email], first_name: params[:first_name], last_name: params[:last_name], type: 1)
            render json: user
        end
    end

    # Handle Zoom webhook events
    def webhook
        event = params[:event]
        payload = params[:payload]

        if event == 'recording.completed'
            meeting_id = payload[:object][:id]
            recording_url = payload[:object][:recording_files].first[:download_url]

            # Update the meeting with the recording URL
            meeting = Meeting.find_by(meeting_id: meeting_id)
            meeting.update(recording_url: recording_url) if meeting
        end

        head :ok
    end
end