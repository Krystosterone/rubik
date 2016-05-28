class NewsletterSubscription < ActiveRecord::Base
  validates :email, email: true, uniqueness: true
end
