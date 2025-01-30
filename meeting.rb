class Meeting < ApplicationRecord
    belongs_to :user

    validates :topic, :start_time, :duration, presence: true
end