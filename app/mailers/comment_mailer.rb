# frozen_string_literal: true
class CommentMailer < ActionMailer::Base
  delegate :comment_email_recipient, to: "Rails.application.config"

  def email(comment)
    @comment = comment
    mail from: @comment.user_email,
         to: comment_email_recipient
  end
end
