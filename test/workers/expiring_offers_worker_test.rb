require_relative '../test_helper'

class ExpiringOffersWorkerTest < ActiveSupport::TestCase # to have fixtures
  let(:worker) { ExpiringOffersWorker.new }

  it 'sends an email for offers that expire today and unapproves them' do
    now = Time.zone.now
    Timecop.freeze(now - 1.day)
    expiring = FactoryGirl.create :offer, :approved, expires_at: now
    later = FactoryGirl.create :offer, :approved, expires_at: now + 2.days
    Timecop.return
    OfferMailer.expect_chain(:expiring_mail, :deliver).once
    # TODO: Fix this and the other tests with 4.2
    worker.perform
    expiring.reload.approved.must_equal false
    expiring.unapproved_reason.must_equal 'expired'
    later.reload.approved.must_equal true
  end

  it 'does not send an email for offers that expired previously' do
    yesterday = Time.zone.now.beginning_of_day - 1
    Timecop.freeze(Time.zone.local(2015)) do
      FactoryGirl.create :offer, expires_at: yesterday
    end
    OfferMailer.not_expect_chain(:expiring_mail, :deliver)
    worker.perform
  end

  it 'does not send an email for offers that will expire' do
    FactoryGirl.create :offer, expires_at: (Time.zone.now.end_of_day + 1)
    OfferMailer.not_expect_chain(:expiring_mail, :deliver)
    worker.perform
  end
end
