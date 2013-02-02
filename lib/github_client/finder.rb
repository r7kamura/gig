require "base64"
require "uri"

class GithubClient
  class Finder < Worker

    # path is a relative path from repository root
    def find(path)
      result = fetch(path)
      parse(result)
    rescue Github::Error::NotFound
    end

    private

    def fetch(path)
      file    = github.repos.contents.get(nickname, repository, URI.escape(path))
      commits = github.repos.commits.list(nickname, repository, :path => path)
      time    = Time.parse(commits.first.commit.committer[:date])
      file.merge(:time => time)
    end

    def parse(result)
      {
        :content   => Base64.decode64(result.content).force_encoding("utf-8"),
        :nickname  => nickname,
        :path      => result.path,
        :persisted => true,
        :time      => result.time,
      }
    end
  end
end
