require_relative '../test_helper'

class UninformedEmailsMailingsWorkerTest < ActiveSupport::TestCase
  # extend ActiveSupport::TestCase to get fixtures
  let(:worker) { UninformedEmailsMailingsWorker.new }

  it 'calls #inform! on uninformed emails that have approved offers' do
    FactoryGirl.create :email, :uninformed, :with_approved_offer
    Email.any_instance.expects(:inform!).once
    worker.perform
  end

  it 'doesnt call #inform! on uninformed emails without approved offers' do
    FactoryGirl.create :email, :uninformed, :with_unapproved_offer
    Email.any_instance.expects(:inform!).never
    worker.perform
  end

  it 'doesnt call #inform! on informed emails that have approved offers' do
    FactoryGirl.create :email, :informed, :with_approved_offer
    Email.any_instance.expects(:inform!).never
    worker.perform
  end

  it 'doesnt calls #inform! on uninformed emails with approved offers but no'\
     ' mailings_enabled organization' do
    email = FactoryGirl.create :email, :uninformed, :with_approved_offer
    email.organizations.update_all mailings_enabled: false
    Email.any_instance.expects(:inform!).never
    worker.perform
  end
end
