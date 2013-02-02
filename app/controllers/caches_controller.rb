class CachesController < ApplicationController
  before_filter :require_github, :only => :create

  def create
    payload = JSON.parse(params[:payload])
    paths = extract_entry_paths(payload["commits"])
    update_entry_cache(paths)
    head 200
  end

  private

  def require_github
    head 400 unless github_request?
  end

  def github_request?
    request.user_agent.include?("GitHub Services Web Hook")
  end

  def extract_entry_paths(commits)
    paths = commits.map {|commit| commit.values_at("added", "modified", "removed") }
    paths.flatten.select {|path| path =~ /^#{Settings.github.entries_path}/ }
  end

  def update_entry_cache(entry_paths)
    entry_paths.each do |path|
      Rails.cache.delete(path)
      author.entry(path)
    end
    update_entries_cache if entry_paths.any?
  end

  def update_entries_cache
    Rails.cache.delete("entries")
    author.entries
  end
end
