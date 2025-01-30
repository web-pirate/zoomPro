# Configure the Zoom API with API key and secret from environment variables
Zoom.configure do |c|
    c.api_key = ENV['ZOOM_API_KEY']
    c.api_secret = ENV['ZOOM_API_SECRET']
end