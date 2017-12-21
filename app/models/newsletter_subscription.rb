# frozen_string_literal: true

class NewsletterSubscription < ApplicationRecord
  validates :email, email: true, uniqueness: true
end
