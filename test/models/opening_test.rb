require_relative '../test_helper'

describe Opening do
  let(:opening) do
    Opening.new(
      name: 'mon 00:00-01:00',
      day: 'mon',
      open: Time.zone.now,
      close: Time.zone.now + 1.hour
    )
  end

  subject { opening }

  describe 'attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :day }
    it { subject.must_respond_to :open }
    it { subject.must_respond_to :close }
    it { subject.must_respond_to :sort_value }
    it { subject.must_respond_to :created_at }
    it { subject.must_respond_to :updated_at }
  end

  describe 'validations' do
    describe 'always' do
      it { subject.must validate_presence_of :day }
      it { subject.must validate_presence_of :open }
      it { subject.must validate_uniqueness_of(:open).scoped_to([:day, :close]) }
      it { subject.must validate_presence_of :close }
      it { subject.must validate_uniqueness_of(:close).scoped_to([:day, :open]) }
    end
  end

  describe '::Base' do
    describe 'associations' do
      it { subject.must have_and_belong_to_many :offers }
    end
  end

  describe 'methods' do
    describe '#appointment?' do
      it 'should return false if opening and closing hour is present' do
        opening.appointment?.must_equal false
      end

      it 'should return true if neither open nor close is present' do
        opening.assign_attributes open: nil, close: nil
        opening.appointment?.must_equal true
      end
    end

    describe '#display_string' do
      it 'should output the open and close time' do
        opening.open = Time.zone.parse '12:01:01'
        opening.close = Time.zone.parse '13:02:02'

        opening.display_string.must_equal '12:01 Uhr - 13:02 Uhr'
      end

      it 'should output a special string when there are no open/close times' do
        opening.close = nil
        opening.display_string.must_equal(
          I18n.t 'opening.display_string.appointment'
        )
      end

      it 'should output 24 instead of 00 for the closing time' do
        opening.open = Time.zone.parse '14:00:00'
        opening.close = Time.zone.parse '00:00:00'

        opening.display_string.must_equal '14:00 Uhr - 24:00 Uhr'
      end
    end
  end
end
