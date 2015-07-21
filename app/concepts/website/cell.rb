class Website::Cell < Cell::Concept
  include ::Cell::Slim

  property :host, :pdf_appendix, :url

  def show
    render
  end

  private

  def link
    link_to t(".#{host}") + pdf_appendix, url, target: '_blank'
  end

  def t key # waiting for https://github.com/apotonick/cells/issues/272
    I18n.t "websites.show#{key}"
  end

  def is_last?
    options[:last] == model
  end
end
