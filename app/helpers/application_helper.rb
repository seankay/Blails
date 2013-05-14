module ApplicationHelper

  def render_markdown text
    renderer = Redcarpet::Render::HTML
    extensions = {
      no_intra_emphasis: true,
      auto_link: true,
      fenced_code_blocks: true,
      strikethrough: true,
      lax_spacing: true,
      superscript: true
    }
    Redcarpet::Markdown.new(renderer).render(text).html_safe
  end
end
