class CachesController < ApplicationController
  before_filter :require_github, :only => :create

  def create
    payload = JSON.parse(params[:payload])

    nickname = payload["repository"]["owner"]["name"]
    commits  = payload["commits"]
    user     = User.find_by_nickname!(nickname)
    paths    = commits.map {|commit| commit.values_at("added", "modified", "removed") }.flatten
    paths.each do |path|
      filename = File.basename(path)
      user.clear_cache(filename)
      user.entry(filename)
    end
    user.entries if paths.any?

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
