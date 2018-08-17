namespace :scrape do
  desc "Scrape all Billboard charting RnB hits from 1980—1990 and store in db"
  task :eighties_rnb => :environment do |_, args|
    BillboardScraper.new.get_songs_between_years(start_year: 1980, end_year: 1990)
  end

  task :populate_spotify_uris => :environment do |_, args|
    songs_to_populate = Song.where(spotify_uri: [nil, ""])
      .where('date_first_charted > ?', Date.new(1980,1,1).beginning_of_day)
    songs_to_populate.each do |s|
      s.get_spotify_uri
      pp s
      sleep 5
    end
  end
end
