# frozen_string_literal: true
class Comment < ApplicationRecord
  after_commit :send_email, on: :create

  validates :user_email, email: true
  validates :body, presence: true

  private

  def send_email
    CommentMailer.email(self).deliver_later
  end
end
