Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, Settings.github.client_id, Settings.github.client_secret, :scope => "repo"
end
