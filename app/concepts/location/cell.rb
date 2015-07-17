class Location::Cell < Cell::Concept
  include ::Cell::Slim

  property :name?
  property :name
  property :addition?
  property :addition
  property :street
  property :zip
  property :city

  def show
    render
  end
end
