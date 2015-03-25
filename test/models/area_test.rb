require_relative '../test_helper'

describe Area do
  let(:area) { Area.new }
  subject { area }

  describe 'attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :name }
    it { subject.must_respond_to :minlat }
    it { subject.must_respond_to :maxlat }
    it { subject.must_respond_to :minlong }
    it { subject.must_respond_to :maxlong }
  end

  describe 'validations' do
    it { subject.must validate_presence_of :name }
    it { subject.must validate_presence_of :minlat }
    it { subject.must validate_presence_of :maxlat }
    it { subject.must validate_presence_of :minlong }
    it { subject.must validate_presence_of :maxlong }
  end
end
