class FeedbackMailer < ApplicationMailer
  def feedback_email(first_name,last_name,email,message)
    @first_name = first_name
    @last_name = last_name
    @email = email
    @message = message
    mail(to: "noahb930@gmail.com", subject: "Megaphone Feedback")
  end
end
