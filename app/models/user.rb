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

    def playbills_new_to_old
        self.playbills.order(performance_date: :desc)
    end

    def playbills_old_to_new
        self.playbills.order(performance_date: :asc)
    end

    def playbills_rating_high_to_low
        self.playbills.order(rating: :desc)
    end

    def playbills_rating_low_to_high
        self.playbills.order(rating: :asc)
    end

    def playbills_alphabetically
        self.playbills.order(title: :asc)
    end

end
  