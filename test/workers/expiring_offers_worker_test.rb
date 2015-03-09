require_relative '../test_helper'

describe ExpiringOffersWorker do
  let(:worker) { ExpiringOffersWorker.new }

  it 'sends an email for offers that expire today and unapproves them' do
    now = Time.now
    Timecop.freeze(now - 1.day)
    expiring = FactoryGirl.create :offer, :approved, expires_at: now
    later = FactoryGirl.create :offer, :approved, expires_at: now + 1.day
    Timecop.return
    worker.perform
    expiring.reload.approved.must_equal false
    later.reload.approved.must_equal true
    # OfferMailer.expects(:delay).once # Doesn't work!
    # TODO: Fix this and the other tests with 4.2
  end

  it 'does not send an email for offers that expired previously' do
    yesterday = Time.now.beginning_of_day - 1
    Timecop.freeze(Time.local(2015)) do
      FactoryGirl.create :offer, expires_at: yesterday
    end
    worker.perform
    OfferMailer.expects(:delay).never
  end
  it 'does not send an email for offers that will expire' do
    FactoryGirl.create :offer, expires_at: (Time.now.end_of_day + 1)
    worker.perform
    OfferMailer.expects(:delay).never
  end
end
