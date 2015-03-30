# using redcarpet
class MarkdownRenderer
  RENDERER_OPTIONS = {
    link_attributes: {
      target: '_blank'
    },
    hard_wrap: true
  }
  MARKDOWN_OPTIONS = {}

  @renderer = Redcarpet::Render::HTML.new RENDERER_OPTIONS
  @markdown = Redcarpet::Markdown.new(@renderer, MARKDOWN_OPTIONS)

  def self.render markdown_string
    @markdown.render markdown_string
  end
end
