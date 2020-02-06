class User < ApplicationRecord

    before_validation { email.downcase! }
    validates :password, presence: true, length: { minimum: 6 }, confirmation: true, on: :create
    validates :name, presence: true, length: { maximum:30}
    validates :email, presence: true, length: { maximum:255}
    validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
    validates :email, uniqueness: true


    before_destroy :one_admin_user_at_least
    after_update :one_admin_user_at_least_update

    has_secure_password

    has_many :tasks, dependent: :destroy
    has_many :labels, dependent: :destroy

    private

    def one_admin_user_at_least
      if User.where(admin: true).count == 1 && self.admin == true
        errors.add(:user, 'には少なくとも１名のadmin権限者が必要です。')
        throw :abort
      end
    end

    def one_admin_user_at_least_update
      if User.where(admin: true).count ==0
        errors.add(:user, 'には少なくとも１名のadmin権限者が必要です。')
        #throw :abort
        raise ActiveRecord::RecordInvalid, self
      end
    end

end
