module ApplicationHelper
    def markdown(text) # for displaying the README on the documentation page (parses right, but styling is Bad)
        renderer = Redcarpet::Render::HTML.new(hard_wrap: true, filter_html: true)
        markdown = Redcarpet::Markdown.new(renderer, extensions = {})
        markdown.render(text).html_safe
    end
end
