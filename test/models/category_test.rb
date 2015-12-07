require_relative '../test_helper'

describe Category do
  let(:category) { Category.new }

  subject { category }

  describe 'methods' do
    describe 'to be refactored junk' do
      it 'should work' do
        Category.current_section = nil
        category = Category.new name: 'Sorgen im Alltag'
        category.name.must_equal 'Sorgen im Alltag'
        Category.current_section = 'family'
        category.name.must_equal 'Sorgen im Alltag'
        Category.current_section = 'refugees'
        category.name.must_equal 'Leben in Deutschland'
        category.name = 'foo'
        category.name.must_equal 'foo'
      end
    end
  end
end
