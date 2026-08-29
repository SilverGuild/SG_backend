namespace :dnd5e do
  namespace :cache do
    desc "Force a live re-fetch of D&D 5e reference data, overwriting the cache. " \
         "Usage: bin/rails dnd5e:cache:refresh " \
         "or bin/rails 'dnd5e:cache:refresh[races]' " \
         "or bin/rails 'dnd5e:cache:refresh[races,gnome]'"
    task :refresh, [ :category, :id ] => :environment do |_t, args|
      categories = args[:category] ? [ args[:category] ] : Dnd5eCacheRefreshJob::CATEGORIES
      id = args[:id] || ""

      categories.each do |category|
        print "Refreshing #{category}#{"/#{id}" if id.present?}... "
        Dnd5eDataGateway.refresh(category, id)
        puts "done"
      rescue Dnd5eDataGateway::UnavailableError => e
        puts "FAILED (#{e.message}) - previous cached value left in place"
      end
    end

    desc  "Delete cached D&D 5e data without re-fetching - next read will be a miss. " \
          "Usage: bin/rails dnd5e:cache:clear " \
          "or bin/rails 'dnd5e:cache:clear[races]' or 'dnd5e:cache:clear[races, gnome]' "
    task :clear, [ :category, :id ] => :environment do |_t, args|
      categories = args[:category] ? [ args[:category] ] : Dnd5eCacheRefreshJob::CATEGORIES
      id = args[:id] || ""

      categories.each do |category|
        key = Dnd5eDataGateway.cache_key(category, id)
        deleted = Rails.cache.delete(key)
        puts "#{key}: #{deleted ? "cleared" : "was not cached"}"
      end
    end
  end
end
