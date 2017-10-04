# frozen_string_literal: true

require_relative '../test_helper'

describe TargetAudienceFilter do
  describe 'methods' do
    describe 'self.identifiers_for_section?' do
      it 'should return all family-identifiers except the generic one' do
        TargetAudienceFilter.identifiers_for_section('family').must_equal %w[
          family_children family_parents family_nuclear_family family_relatives
          family_parents_to_be
        ]
      end

      it 'should return all refugees-identifiers except the generic one' do
        TargetAudienceFilter.identifiers_for_section('refugees').must_equal %w[
          refugees_children refugees_uf refugees_parents refugees_families
          refugees_parents_to_be
        ]
      end
    end
  end
end
