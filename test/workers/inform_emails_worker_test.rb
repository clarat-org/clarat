require_relative '../test_helper'

class InformEmailsWorkerTest < ActiveSupport::TestCase # to have fixtures
  let(:worker) { InformEmailsWorker.new }

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
end
