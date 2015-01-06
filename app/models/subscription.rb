class Subscription < ActiveRecord::Base
  # Validations
  validates :email, format: /\A.+@.+\..+\z/

  after_create :push_to_provider

  private

  # TODO: refactor to observer & async
  def push_to_provider
    Gibbon::API.lists.subscribe(
      id: Rails.application.secrets.mailchimp['list_id'],
      email: { email: email },
      double_optin: true
    )
  end
end
