class RepresentativeMailer < ApplicationMailer
  def contact_email(representative,subject,body)
    @body = body
    mail(to: representative.email, subject: subject)
  end
end
