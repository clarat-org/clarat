class Opening::Cell < Cell::Concept
  include ::Cell::Slim

  property :day, :times

  def show
    render
  end

  private

  def t key # waiting for https://github.com/apotonick/cells/issues/272
    I18n.t "openings.show#{key}"
  end
end
