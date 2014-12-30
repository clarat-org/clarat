require "test_helper"

describe Contact do
  let(:contact) { Contact.new }

  it "must be valid" do
    contact.must_be :valid?
  end
end
