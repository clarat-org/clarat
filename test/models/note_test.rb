require_relative '../test_helper'

describe Note do
  let(:note) { Note.new }
  subject { note }

  describe 'attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :text }
    it { subject.must_respond_to :topic }
    it { subject.must_respond_to :user }
    it { subject.must_respond_to :notable }
    it { subject.must_respond_to :referencable }
  end
end
