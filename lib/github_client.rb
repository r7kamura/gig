class GithubClient
  delegate :find, :to => :finder
  delegate :list, :to => :scraper
  delegate :delete, :fork, :update, :to => :committer

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
end
