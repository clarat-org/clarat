require 'test_helper'

describe UpdateRequest do
  let(:update_request) { UpdateRequest.new }

  it 'must be valid' do
    update_request.must_be :valid?
  end
end
