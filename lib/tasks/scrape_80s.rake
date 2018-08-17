namespace :scrape do
  desc "Scrape all Billboard charting RnB hits from 1980—1990 and store in db"
  task :eighties_rnb => :environment do |_, args|
    BillboardScraper.new.get_songs_between_years(start_year: 1980, end_year: 1990)
  end

  task :populate_spotify_uris => :environment do |_, args|
    songs_to_populate = Song.where(queried_spotify: false)
    songs_to_populate.each do |s|
      begin
      s.get_spotify_uri
      rescue RestClient::BadGateway => _
        puts "502 from Spotify. Retrying in 60 seconds"
        sleep 60
      end
      pp s
      sleep 5
    end
  end
end
