# frozen_string_literal: true

require_relative '../test_helper'

describe Opening do
  let(:opening) do
    Opening.new(
      name: 'mon 00:00-01:00',
      day: 'mon',
      open: DateTime.now.in_time_zone.to_s(:time),
      close: (DateTime.now.in_time_zone + 1.hour).to_s(:time)
    )
  end

  describe 'methods' do
    describe '#display_string' do
      it 'should output the open and close time' do
        opening.open = '12:01'
        opening.close = '13:02'
        opening.display_string.must_equal '12:01 - 13:02'
      end

      it 'should output a special string when there are no open/close times' do
        opening.close = nil
        opening.display_string.must_equal(
          I18n.t('opening.display_string.appointment')
        )
      end

      it 'should output 24 instead of 00 for the closing time' do
        opening.open = '14:00'
        opening.close = '00:00'

        opening.display_string.must_equal '14:00 - 24:00 Uhr'
      end
    end
  end
end
