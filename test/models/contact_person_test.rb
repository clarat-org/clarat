require_relative '../test_helper'

describe ContactPerson do
  let(:contact_person) { ContactPerson.new }

  it "must be valid" do
    contact_person.must_be :valid?
  end
end
