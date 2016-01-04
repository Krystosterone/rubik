class CommentMailer < ActionMailer::Base
  def email(comment)
    @comment = comment
    mail from: @comment.user_email,
         to: 'krystianczesak+rubik-ets@gmail.com'
  end
end
