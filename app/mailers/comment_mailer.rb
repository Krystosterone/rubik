class CommentMailer < BaseMailer
  def email(comment)
    @comment = comment
    send_email_to_recipient from: @comment.user_email
  end
end
