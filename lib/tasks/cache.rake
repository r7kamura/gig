namespace :cache do
  desc "Clear cache on memcache"
  task :clear => :environment do
    puts
    puts "Clear cache on memcache"
    Rails.cache.clear
  end
end
