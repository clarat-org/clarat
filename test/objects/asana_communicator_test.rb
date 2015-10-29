require_relative '../test_helper'

class AsanaCommunicatorTest < ActiveSupport::TestCase # to have fixtures
  let(:object) { AsanaCommunicator.new }

  describe '#create_expire_task' do
    it 'should call #post_to_api with apropriate data' do
      object.expects(:post_to_api).with(
        '/tasks',
        projects: %w(44856824806357), workspace: '41140436022602',
        name: 'foobar,bazfuz-9999-01-01-basicOfferName',
        notes: 'Expired: http://claradmin.herokuapp.com/admin/offer/1/edit'
      )

      offer = offers(:basic)
      orga = FactoryGirl.create :organization, :approved, name: 'bazfuz'
      offer.organizations << orga

      object.create_expire_task offer
    end

    it 'should end up in an HTTP request' do
      Net::HTTP.any_instance.expects :request
      object.create_expire_task offers(:basic)
    end
  end
end
