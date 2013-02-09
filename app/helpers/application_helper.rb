module ApplicationHelper
  def current_action_classes
    %W[#{controller_name}_controller #{action_name}_action]
  end

  def link_to_with_icon(icon_type, path, options = {})
    link_to path, options do
      content_tag(:i, :class => "icon-#{icon_type}") {}
    end
  end

  def title_tag
    content_tag(:title) do
      if @entry.try(:name).present?
        "#{@entry.name} - GIG"
      else
        "GIG"
      end
    end
  end

  class AbstractDecorator < SimpleDelegator
    include Rails.application.routes.url_helpers
  end
end
