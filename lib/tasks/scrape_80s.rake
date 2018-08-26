namespace :scrape do
  desc "Scrape all Billboard charting RnB hits and store in db"
  task :rnb => :environment do |t, args|
    BillboardScraper.new.get_songs_between_years(chart_url: "r-b-hip-hop-songs/",
      start_year: ENV['START_YEAR'].to_i,
      end_year: ENV['END_YEAR'].to_i
    )
  end

  task :hot_100 => :environment do |t, args|
    BillboardScraper.new.get_songs_between_years(chart_url: "hot-100/",
      start_year: ENV['START_YEAR'].to_i,
      end_year: ENV['END_YEAR'].to_i
    )
  end
end
