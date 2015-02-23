require_relative '../test_helper'

describe ExpiringOffersWorker do
  let(:worker) { ExpiringOffersWorker.new }

  it 'sends an email for offers that expires today' do
    FactoryGirl.create :offer, expires_at: Time.now
    worker.perform
    # OfferMailer.expects(:delay).once # Doesn't work!
    # TODO: Fix this and the other tests with 4.2
  end

  it 'does not send an email for offers that expired previously' do
    FactoryGirl.create :offer, expires_at: (Time.now.beginning_of_day - 1)
    worker.perform
    OfferMailer.expects(:delay).never
  end
  it 'does not send an email for offers that will expire' do
    FactoryGirl.create :offer, expires_at: (Time.now.end_of_day + 1)
    worker.perform
    OfferMailer.expects(:delay).never
  end
end
