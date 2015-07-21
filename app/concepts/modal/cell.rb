class Modal::Cell < Cell::Concept
  include ::Cell::Slim

  property :selector, :options, :block

  def show
    render
  end

  private

  def content
    capture(&block)
  end
end
