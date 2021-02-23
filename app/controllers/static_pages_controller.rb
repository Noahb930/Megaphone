class StaticPagesController < ApplicationController
  def about
  end
  def implement
  end
  def faq
  end
  def feedback
  end
  def email
    FeedbackMailer.feedback_email(params[:first_name],params[:last_name],params[:email],params[:message]).deliver_now
    render :feedback
  end
end
