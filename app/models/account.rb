class Account < ActiveRecord::Base
    before_save { self.email = email.downcase }
    has_one :invoice

    validates :delivery_method, :street, presence: true
  	validates :full_name, presence: true, length: { maximum: 50 }
  	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
end
