# User is a model for an owner of this blog and we assume there is only 1 user.
# The responsibility to attach Settings.github.entries_path belongs to User class.
class User < ActiveRecord::Base
  attr_accessible :nickname, :provider, :token, :uid

  validates :nickname, :provider, :uid, :token, :presence => true
  validates :uid, :presence => true, :uniqueness => { :scope => :provider }

  delegate(
    :db_repository_name,
    :db_repository_owner,
    :entries_path,
    :hook_url,
    :repository,
    :to => "Settings.github"
  )

  scope :alphabetical, lambda { order("nickname DESC") }

  class << self
    def admin
      User.find_by_nickname(Settings.github.nickname)
    end

    def find_or_create_from_auth(auth)
      find_from_auth(auth) || create_from_auth(auth)
    end

    private

    def find_from_auth(auth)
      attributes = auth.slice("provider", "uid")
      where(attributes).first
    end

    def create_from_auth(auth)
      create(
        :nickname => auth["info"]["nickname"],
        :provider => auth["provider"],
        :token    => auth["credentials"]["token"],
        :uid      => auth["uid"],
      ).tap(&:create_repository)
    end

    # Meta utility method to cache method's returned value
    # For instance: returned value of #entries will be cached in 1.day with "entries" as cache key
    #  cache_method(:entries, 1.day) { "entries" }
    def cache_method(method_name, expires_in, &cache_key)
      define_method("#{method_name}_with_cache") do |*args|
        Rails.cache.fetch instance_exec(*args, &cache_key), :expires_in => expires_in do
          __send__("#{method_name}_without_cache", *args)
        end
      end
      alias_method_chain method_name, :cache
    end
  end

  def commit(entry)
    github_client.update("#{entries_path}/#{entry.filename}", entry.content)
  end

  def entries
    list = github_client.list(entries_path)
    list.map {|attributes| Entry.new(attributes) }
  end

  def entry(entry_name)
    if attributes = github_client.find("#{entries_path}/#{entry_name}")
      Entry.new(attributes)
    end
  end

  def build_entry(attributes = {})
    Entry.new_with_name attributes.merge(:nickname => nickname)
  end

  def create_entry(attributes)
    entry = Entry.new_with_name(attributes)
    if entry.valid?
      commit(entry)
      entry.persisted!
      entry
    end
  end

  def update_entry(attributes)
    if entry = create_entry(attributes)
      clear_cache(entry.filename)
      entry
    end
  end

  def destroy_entry(entry_name)
    github_client.delete("#{entries_path}/#{entry_name}")
  end

  def create_repository
    github_client.fork(db_repository_owner, db_repository_name, repository)
    github_client.hook(nickname, repository, hook_url)
  end

  def to_param
    nickname
  end

  def clear_cache(filename)
    Rails.cache.delete("#{nickname}/#{entries_path}/#{filename}")
    Rails.cache.delete("#{nickname}/#{entries_path}")
  end

  private

  def github_client
    @github_client ||= GithubClient.new(
      :nickname     => nickname,
      :repository   => repository,
      :token        => token
    )
  end

  cache_method(:entries, 1.day) { "#{nickname}/#{entries_path}" }
  cache_method(:entry, 1.day) {|filename| "#{nickname}/#{entries_path}/#{filename}" }
end
