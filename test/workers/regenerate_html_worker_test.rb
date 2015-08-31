require_relative '../test_helper'

class RegenerateHtmlWorkerTest < ActiveSupport::TestCase
  # extend ActiveSupport::TestCase to get fixtures
  let(:worker) { RegenerateHtmlWorker.new }

  describe '#changes' do
    it 'should register changes in an object' do
      old = { foo: 'unchanged', bar: 'unchanged' }
      obj = OpenStruct.new foo: 'unchanged', bar: 'changed'

      result = worker.send(:changes, obj, old)

      result[:foo].must_be :nil?
      result[:bar].must_equal 'changed'
      result[:updated_at].wont_be :nil?
      result.keys.count.must_equal 2
    end

    it 'should return false when there are no changes' do
      old = { foo: 'unchanged', bar: 'unchanged' }
      obj = OpenStruct.new foo: 'unchanged', bar: 'unchanged'

      result = worker.send(:changes, obj, old)
      result.must_equal false
    end
  end

  describe 'perform' do
    before do
      # Run worker initially so everything in database is updated to the
      # most recent state
      worker.perform
    end

    it 'should send an update when there has been a changed offer' do
      FactoryGirl.create :definition, key: offers(:basic).description

      Offer.any_instance.expects(:update_columns)
      worker.perform
    end

    it 'wont send an update when there has been no changed offer' do
      Offer.any_instance.expects(:update_columns).never
      worker.perform
    end
  end
end
