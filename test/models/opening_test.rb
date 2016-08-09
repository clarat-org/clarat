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

  describe 'methods' do
    describe '#display_string' do
      it 'should output the open and close time' do
        opening.open = Time.zone.parse '12:01:01'
        opening.close = Time.zone.parse '13:02:02'

        opening.display_string.must_equal '12:01 - 13:02 Uhr'
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

        opening.display_string.must_equal '14:00 - 24:00 Uhr'
      end
    end
  end
end
