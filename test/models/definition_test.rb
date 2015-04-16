require_relative '../test_helper'

describe Definition do
  let(:definition) { Definition.new key: 'foo', explanation: 'bar' }
  subject { definition }

  it 'must be valid' do
    definition.must_be :valid?
  end

  describe 'validations' do
    it { subject.must validate_presence_of :key }
    it { subject.must validate_uniqueness_of :key }
    it { subject.must validate_length_of(:key).is_at_most 50 }
    it { subject.must validate_presence_of :explanation }
    it { subject.must validate_length_of(:explanation).is_at_most 500 }
  end
end
