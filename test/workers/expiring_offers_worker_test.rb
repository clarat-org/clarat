require_relative '../test_helper'

class ExpiringOffersWorkerTest < ActiveSupport::TestCase # to have fixtures
  let(:worker) { ExpiringOffersWorker.new }

  it 'sends an email for offers that expire today and unapproves them' do
    today = Time.zone.today
    Timecop.freeze(today - 1.day)
    expiring = FactoryGirl.create :offer, :approved, expires_at: today
    later = FactoryGirl.create :offer, :approved, expires_at: today + 2.days
    Timecop.return
    OfferMailer.expect_chain(:expiring_mail, :deliver).once
    AsanaCommunicator.any_instance.expects(:create_expire_task).once
    worker.perform
    expiring.reload.must_be :expired?
    later.reload.must_be :approved?
  end

  it 'does not send an email for offers that expired previously' do
    yesterday = Time.zone.now.beginning_of_day - 1
    Timecop.freeze(Time.zone.local(2015)) do
      FactoryGirl.create :offer, expires_at: yesterday
    end
    OfferMailer.expects(:expiring_mail).never
    AsanaCommunicator.any_instance.expects(:create_expire_task).never
    worker.perform
  end

  it 'does not send an email for offers that will expire' do
    FactoryGirl.create :offer, expires_at: (Time.zone.now.end_of_day + 1)
    OfferMailer.expects(:expiring_mail).never
    AsanaCommunicator.any_instance.expects(:create_expire_task).never
    worker.perform
  end
end
