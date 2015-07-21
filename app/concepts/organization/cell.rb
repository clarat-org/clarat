class Organization::Cell < Cell::Concept
  include ::Cell::Slim

  property :name, :id

  def show
    render
  end

  def tiny
    render :tiny
  end

  private

  def link
    link_to name, organization_path(id: id)
  end
end
