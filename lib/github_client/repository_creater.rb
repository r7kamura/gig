class GithubClient
  class RepositoryCreater < Worker
    def fork(owner, repo, name = nil)
      github.repos.forks.create(owner, repo)
      change_repository_name(repo, name) if name
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

    private

    def change_repository_name(from, to)
      github.repos.edit(nickname, from, :name => to)
    rescue Github::Error::UnprocessableEntity
      # Silent error caused when the repository with the same name already exists
    end
  end
end
