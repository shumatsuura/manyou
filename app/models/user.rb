class User < ApplicationRecord
    before_validation { email.downcase! }
    validates :password, presence: true, length: { minimum: 6 }
    validates :name, presence: true, length: { maximum:30}
    validates :email, presence: true, length: { maximum:255}
    validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
    validates :email, uniqueness: true

    has_secure_password

end
