source "https://rubygems.org"

gem "rails", "3.2.11"
gem "mysql2"
gem "jquery-rails"
gem "slim"
gem "omniauth-github"
gem "settingslogic"
gem "github_api"
gem "dalli"
gem "redcarpet"
gem "font-awesome-sass-rails"
gem "hashie"

group :development do
  gem "pry-rails"
  gem "quiet_assets"
  gem "tapp"
end

group :test do
  gem "rspec", ">=2.12.0"
  gem "rspec-rails", ">=2.12.0"
  gem "response_code_matchers"
  gem "factory_girl_rails", "~> 4.0"
  gem "simplecov"
end

group :production do
  gem "pg"
  gem "therubyracer-heroku"
end

group :development, :test do
  gem "dotenv"
end

group :assets do
  gem "sass-rails",   "~> 3.2.3"
  gem "coffee-rails", "~> 3.2.1"
  gem "uglifier", ">= 1.0.3"
end
