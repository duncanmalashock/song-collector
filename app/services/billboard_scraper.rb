class BillboardScraper
  def scrape_songs_for(chart_url:, date:)
    billboard_url = "https://www.billboard.com/charts/#{chart_url}"
    response = HTTParty.get("#{billboard_url}#{date.strftime("%F")}",
      headers: {"User-Agent" => "Httparty"}
    )
    puts "  Response: #{response.response}"
    parsed_page ||= Nokogiri::HTML(response)

    number_created = 0
    s = Song.create_with_artist_name(
      title: parsed_page.css(".chart-number-one__title").text.strip,
      artist_name: parsed_page.css(".chart-number-one__artist").text.strip,
      date_first_charted: date
    )
    if s.valid? then number_created += 1 end
    parsed_page.css(".chart-list-item").map do |node|
      s = Song.create_with_artist_name(
        title: node['data-title'].strip,
        artist_name: node['data-artist'].strip,
        date_first_charted: date
      )
      if s.valid? then number_created += 1 end
    end
    number_created
  end

  def get_songs_between_years(chart_url:, start_year:, end_year:)
    dates = get_saturdays(start_year: start_year, end_year: end_year)
    puts "Scraping songs: #{dates.length} weeks total..."
    songs = dates.flat_map { |d|
      puts "  #{d}"
      new_songs_created = BillboardScraper.new.scrape_songs_for(chart_url: chart_url, date: d)
      puts "    #{new_songs_created} songs found"
      new_songs_created
    }
    puts "Finished!"
  end

  def get_saturdays(start_year:, end_year:)
    dates = []
    iter = Date.new(start_year, 1, 1)
    while iter.year != end_year do
      if iter.saturday? then
        dates << iter
      end
      iter += 1
    end
    dates
  end
end
