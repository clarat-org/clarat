require_relative '../test_helper'

class SubscribedEmailsMailingsWorkerTest < ActiveSupport::TestCase
  # extend ActiveSupport::TestCase to get fixtures
  let(:worker) { SubscribedEmailsMailingsWorker.new }

  it 'sends mailing to subscribed emails that have approved offers' do
    FactoryGirl.create :email, :subscribed, :with_approved_offer
    OfferMailer.expect_chain(:newly_approved_offers, :deliver).once
    worker.perform
  end

  it 'wont send mailing to subscribed emails that have approved offers but'\
     ' that were already informed about those offers' do
    email = FactoryGirl.create :email, :subscribed, :with_approved_offer
    email.create_offer_mailings email.offers.all, :inform
    OfferMailer.expects(:newly_approved_offers).never
    worker.perform
  end

  it 'wont send mailing to subscribed emails without approved offers' do
    FactoryGirl.create :email, :subscribed, :with_unapproved_offer
    OfferMailer.expects(:newly_approved_offers).never
    worker.perform
  end

  it 'wont send mailing to unsubscribed emails that have approved offers' do
    FactoryGirl.create :email, :unsubscribed, :with_approved_offer
    OfferMailer.expects(:newly_approved_offers).never
    worker.perform
  end

  it 'wont send mailing to uninformed emails that have approved offers' do
    FactoryGirl.create :email, :uninformed, :with_approved_offer
    OfferMailer.expects(:newly_approved_offers).never
    worker.perform
  end

  it 'wont send mailing to informed emails that have approved offers' do
    FactoryGirl.create :email, :informed, :with_approved_offer
    OfferMailer.expects(:newly_approved_offers).never
    worker.perform
  end

  it 'wont send mailing to subscribed emails with approved offers but no'\
     ' mailings_enabled organization' do
    email = FactoryGirl.create :email, :subscribed, :with_approved_offer
    email.organizations.update_all mailings_enabled: false
    OfferMailer.expects(:newly_approved_offers).never
    worker.perform
  end
end
