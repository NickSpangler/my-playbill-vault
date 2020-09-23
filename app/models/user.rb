class User < ActiveRecord::Base
    has_secure_password
    has_many :playbills
    has_many :friends
    has_many :requests
    validates :username, presence: true
    validates :username, uniqueness: true
    validates :email, presence: true
    validates :email, uniqueness: true
    validates_format_of :email, :with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
    
    def favorites
        self.playbills.find_all{|playbill| playbill if playbill.favorite == true}
    end

    def date_new_to_old
        self.playbills.order(performance_date: :desc)
    end

    def date_old_to_new
        self.playbills.order(performance_date: :asc)
    end

    def rating_high_to_low
        self.playbills.order(rating: :desc)
    end

    def rating_low_to_high
        self.playbills.order(rating: :asc)
    end

    def alphabetically
        self.playbills.order(title: :asc)
    end

end