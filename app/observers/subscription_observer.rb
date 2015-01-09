class SubscriptionObserver < ActiveRecord::Observer
  # register worker to push email to Mailchimp
  def after_create subscription
    EmailPusherWorker.perform_async subscription.id
  end
end
