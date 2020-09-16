class User < ActiveRecord::Base
    has_secure_password
    has_many :playbills
    has_many :friends
    has_many :requests
    validates :username, presence: true
    validates :username, uniqueness: true
    validates :email, presence: true
    validates :email, uniqueness: true
    
    def favorites
        self.playbills.find_all{|playbill| playbill if playbill.favorite == true}
    end
end
  