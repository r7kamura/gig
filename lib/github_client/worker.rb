# Abstract class for each worker
class GithubClient
  class Worker
    def initialize(config)
      @config = config
    end

    private

    def nickname
      @config[:nickname]
    end

    def repository
      @config[:repository]
    end

    def token
      @config[:token]
    end

    def github
      @github ||= Github.new(:oauth_token => token)
    end
  end
end
