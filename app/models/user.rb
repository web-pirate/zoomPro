class User < ApplicationRecord
    # Assuming Devise is used for authentication
    devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

    # Add a field to store Zoom user ID
    field :zoom_user_id, type: String

    # Ensure email is unique
    validates :email, uniqueness: true
end