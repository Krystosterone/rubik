# frozen_string_literal: true
class NewsletterSubscription < ActiveRecord::Base
  validates :email, email: true, uniqueness: true
end
