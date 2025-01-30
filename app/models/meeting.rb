class Meeting < ApplicationRecord
    # Each meeting belongs to a user
    belongs_to :user

    # Validate presence of topic, start time, and duration
    validates :topic, :start_time, :duration, presence: true
end

# Code to create the Meeting model:
# rails generate model Meeting user:references topic:string start_time:datetime duration:integer recording_url:string
# rails db:migrate