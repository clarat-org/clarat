require_relative '../test_helper'

describe DefinitionsController do
  let(:definition) { Definition.create key: 'a', explanation: 'b' }

  it 'must work' do
    get :show, id: definition.id, locale: 'de', section: 'family'
    assert_response :success
  end
end
