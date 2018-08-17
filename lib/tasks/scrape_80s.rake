namespace :scrape do
  desc "Scrape all Billboard charting RnB hits from 1980—1990 and store in db"
  task :eighties_rnb do
    BillboardScraper.new.get_songs_between_years(start_year: 1980, end_year: 1990)
  end
end
