require_relative '../test_helper'

describe SearchForm do
  describe '#tag_array' do
    it "should return an array from a string" do
      SearchForm.new(tags: 'a,1').tag_array.must_equal ['a', '1']
    end
    it "should return an empty array when no tags were set" do
      SearchForm.new.tag_array.must_equal []
    end
  end
end
