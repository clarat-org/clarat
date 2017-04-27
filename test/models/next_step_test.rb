# frozen_string_literal: true
require_relative '../test_helper'

describe NextStep do
  let(:next_step) { NextStep.new }

  subject { next_step }

  describe 'scopes' do
    describe 'in_current_locale' do
      it 'should find all that are translated to the current locale' do
        former_locales = I18n.available_locales
        I18n.available_locales = [:de, :en, :fr, :pl]

        NextStep.create text_de: 'foo', text_fr: nil,
                        text_en: 'bar', text_pl: ''

        I18n.with_locale(:de) do
          NextStep.in_current_locale.count.must_equal 2
        end
        I18n.with_locale(:en) do
          NextStep.in_current_locale.count.must_equal 1
        end
        I18n.with_locale(:fr) do
          NextStep.in_current_locale.count.must_equal 0
        end
        I18n.with_locale(:pl) do
          NextStep.in_current_locale.count.must_equal 0
        end

        I18n.available_locales = former_locales
      end
    end
  end
end
