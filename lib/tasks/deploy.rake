define_method(:`) {|command| puts "$ #{command}" } if ENV["DRYRUN"]

desc "Deploy application to production server"
task :deploy => %w[
  deploy:push
  deploy:migrate
  deploy:tag
]

namespace :deploy do
  desc "Push code to production server"
  task :push do
    puts
    puts "Deploy application to production server"
    puts `git push -f heroku master`
  end

  desc "Migrate the database"
  task :migrate do
    puts
    puts "Migrate the database"
    puts `heroku run rake db:migrate`
  end

  desc "Mark a git tag to remember release version"
  task :tag do
    name = "release-#{Time.now.utc.strftime("%Y%m%d%H%M%S")}"
    puts
    puts "Mark a git tag to remember release version"
    puts "Tagging release as [#{name}]"
    puts `git tag -a #{name} -m "Tagged release"`
    puts `git push --tags heroku`
  end

  desc "Setup environments"
  task :setup => %w[
    deploy:setup:addons
    deploy:setup:env
  ]

  namespace :setup do
    desc "Setup addons"
    task :addons do
      puts
      puts "Setup addons"
      puts `heroku addons:add memcache`
    end

    desc "Setup ENV from .env"
    task :env do
      vals = File.read(".env").gsub("\n", " ")
      puts
      puts "Setup ENV from .env"
      puts `heroku config:add #{vals}`
    end
  end
end
