require "pathname"

class EntryDecorator < AbstractDecorator
  def self.renderer
    @renderer ||= Redcarpet::Markdown.new(
      Redcarpet::Render::HTML.new(:hard_wrap => true),
      :autolink           => true,
      :fenced_code_blocks => true
    )
  end

  def edit_path
    edit_user_entry_path(nickname, id)
  end

  def github_path
    "https://github.com/#{nickname}/#{Settings.github.repository}/tree/master/#{path}"
  end

  def rendered_content
    self.class.renderer.render(content).html_safe
  end
end
