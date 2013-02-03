class GithubClient
  class Committer < Worker
    def update(path, content)
      master          = fetch_master_commit
      last_commit_sha = master.sha
      last_tree_sha   = master.commit.tree.sha
      new_tree_sha    = create_tree_with_content(path, content, last_tree_sha).sha
      new_commit_sha  = create_commit("Update #{path}", new_tree_sha, last_commit_sha).sha
      update_master_reference(new_commit_sha)
    end

    def delete(path)
      master           = fetch_master_commit
      objects          = fetch_objects(master.sha)
      entries_tree_sha = create_entries_tree_without_path(path, objects).sha
      root_tree_sha    = create_root_tree_with_entries(path, objects, entries_tree_sha).sha
      new_commit_sha   = create_commit("Delete #{path}", root_tree_sha, master.sha).sha
      update_master_reference(new_commit_sha)
    end

    private

    def create_tree(options)
      github.git_data.trees.create(nickname, repository, options)
    end

    def fetch_master_commit
      github.repos.branch(nickname, repository, "master").commit
    end

    def create_tree_with_content(path, content, base_tree_sha)
      create_tree(
        :base_tree => base_tree_sha,
        :tree      => [
          {
            :mode    => "100644",
            :type    => "blob",
            :path    => path,
            :content => content,
          }
        ]
      )
    end

    def create_tree_with_objects(objects)
      create_tree(:tree => objects)
    end

    def create_commit(message, tree_sha, parent_commit_sha)
      github.git_data.commits.create(
        nickname,
        repository,
        :message => message,
        :tree    => tree_sha,
        :parents => [parent_commit_sha]
      )
    end

    def update_master_reference(commit_sha)
      github.git_data.references.update(nickname,
        repository,
        "heads/master",
        :sha => commit_sha
      )
    end

    def fetch_objects(commit_sha)
      github.git_data.trees.get(
        nickname,
        repository,
        commit_sha,
        :recursive => true
      ).tree
    end

    # Create a new tree for the entries directory without given path
    def create_entries_tree_without_path(path, objects)
      dirname = path.split("/", 2).first
      create_tree_with_objects(
        objects.map {|object|
          next if object.path !~ %r<^#{dirname}/>
          next if object.path == path
          {
            :mode => object.mode,
            :sha  => object.sha,
            :type => object.type,
            :path => object.path.gsub(%r<^#{dirname}/>, ""),
          }
        }.compact
      )
    end

    # Create a new root tree from old root's objects and a tree for entries.
    # The old entries tree is replaced with new one,
    # and non top level objects are not included to this root tree.
    def create_root_tree_with_entries(path, objects, entries_tree_sha)
      create_tree_with_objects(
        objects.map {|object|
          if object.path.include?("/")
            nil
          elsif object.path == "entries"
            {
              :mode => "040000",
              :path => "entries",
              :type => "object",
              :sha  => entries_tree_sha,
            }
          else
            object
          end
        }.compact
      )
    end
  end
end
