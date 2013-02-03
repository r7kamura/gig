class CachesController < ApplicationController
  before_filter :require_github, :only => :create

  def create
    payload = JSON.parse(params[:payload])

    nickname = payload["repository"]["owner"]["name"]
    commits  = payload["commits"]
    paths    = commits.map {|commit| commit.values_at("added", "modified", "removed") }.flatten
    paths.each do |path|
      Rails.cache.delete("#{nickname}/#{path}")
      author.entry(File.basename(path))
    end
    if paths.any?
      Rails.cache.delete("#{nickname}/entries")
      author.entries
    end

    head 200
  end

  private

  def require_github
    head 400 unless github_request?
  end

  def github_request?
    request.user_agent.include?("GitHub Services Web Hook")
  end
end
