class User < ActiveRecord::Base
    has_secure_password
    has_many :playbills
    validates :username, presence: true
    validates :username, uniqueness: true
    validates :email, presence: true
    validates :email, uniqueness: true
    
end
  