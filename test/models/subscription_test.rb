require 'test_helper'

describe Subscription do
  let(:subscription) { Subscription.new email: 'a@b.c' }

  it 'must be valid' do
    subscription.must_be :valid?
  end
end
