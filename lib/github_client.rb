class GithubClient
  delegate :find, :to => :finder
  delegate :list, :to => :scraper
  delegate :delete, :update, :to => :committer
  delegate :fork, :hook, :to => :repository_creater

  def initialize(config)
    @config = config
  end

  private

  def committer
    Committer.new(@config)
  end

  def finder
    Finder.new(@config)
  end

  def scraper
    Scraper.new(@config)
  end

  def repository_creater
    RepositoryCreater.new(@config)
  end
end
