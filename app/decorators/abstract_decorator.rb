class AbstractDecorator < SimpleDelegator
  include Rails.application.routes.url_helpers
end
