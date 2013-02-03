class GithubClient
  class RepositoryCreater < Worker
    def fork(owner, repo, name = nil)
      github.repos.forks.create(owner, repo)
      github.repos.edit(nickname, repo, :name => name) if name
    end

    def hook(owner, repo, url)
      github.repos.hooks.create(
        owner,
        repo,
        :name   => "web",
        :active => true,
        :events => [
          "push",
          "pull_request",
        ],
        :config => {
          :url          => url,
          :content_type => "form",
        },
      )
    end
  end
end
