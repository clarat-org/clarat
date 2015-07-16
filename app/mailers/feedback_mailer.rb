class FeedbackMailer < ActionMailer::Base
  def admin_notification feedback_id
    @feedback = Feedback.find(feedback_id)
    sender = @feedback.email? ? @feedback.email : 'post@clarat.org'
    mail subject: 'Neue Nachricht vom clarat-Kontaktfomular',
         to:      Rails.application.secrets.emails['admin'],
         from:    sender
  end
end
