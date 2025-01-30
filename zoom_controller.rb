class ZoomController < ApplicationController
    before_action :authenticate_user!
    skip_before_action :verify_authenticity_token, only: [:webhook]

    def create_meeting
        client = Zoom.new
        meeting = client.meeting_create(user_id: current_user.zoom_user_id, topic: params[:topic], start_time: params[:start_time])

        # Save meeting details
        Meeting.create(
            user: current_user,
            topic: params[:topic],
            start_time: params[:start_time],
            duration: meeting['duration'],
            recording_url: meeting['recording_files'].first['download_url']
        )

        render json: meeting
    end

    def list_meetings
        client = Zoom.new
        meetings = client.meeting_list(user_id: current_user.zoom_user_id)
        render json: meetings
    end

    def add_user
        if User.exists?(email: params[:email])
            render json: { error: 'Email already registered' }, status: :unprocessable_entity
        else
            client = Zoom.new
            user = client.user_create(email: params[:email], first_name: params[:first_name], last_name: params[:last_name], type: 1)
            render json: user
        end
    end

    def webhook
        event = params[:event]
        payload = params[:payload]

        if event == 'recording.completed'
            meeting_id = payload[:object][:id]
            recording_url = payload[:object][:recording_files].first[:download_url]

            meeting = Meeting.find_by(meeting_id: meeting_id)
            meeting.update(recording_url: recording_url) if meeting
        end

        head :ok
    end
end