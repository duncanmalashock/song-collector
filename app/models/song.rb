class Song < ApplicationRecord
  validates :title, presence: true, uniqueness: { scope: :artist_id }
  validates :date_first_charted, presence: true

  belongs_to :artist

  MAX_ATTEMPTS = 5
  SLEEP_DURATION = 5

  def self.create_with_artist_name(title:, artist_name:, date_first_charted:)
    a = Artist.find_by(name: artist_name)
    if !a.present? then
      a = Artist.create(name: artist_name)
    end
    Song.create(title: title, date_first_charted: date_first_charted, artist: a).tap { |s| s.get_spotify_uri }
  end

  def self.all_from_year(year:)
    Song.where(:date_first_charted => Date.new(year,1,1).beginning_of_day..Date.new(year + 1,1,1).end_of_day)
  end

  def get_spotify_uri(attempts: 0)
    begin
      search_result = RSpotify::Track.search(self.to_query_string, limit: 1)
      found_uri = search_result[0]&.uri
      if found_uri.present? then
        self.update_attributes(spotify_uri: found_uri)
      end
      self.update_attributes(queried_spotify: true)
      return self
    rescue RestClient::BadGateway => _
      if attempts < MAX_ATTEMPTS then
        sleep_duration = SLEEP_DURATION
        puts "502 from Spotify. Retrying in #{sleep_duration} seconds"
        sleep sleep_duration
        get_spotify_uri(attempts: attempts + 1)
      else
        puts "Spotify API failed after #{attempts} attempts."
      end
    rescue RestClient::GatewayTimeout => _
      if attempts < MAX_ATTEMPTS then
        sleep_duration = SLEEP_DURATION
        puts "504 from Spotify. Retrying in #{sleep_duration} seconds"
        sleep sleep_duration
        get_spotify_uri(attempts: attempts + 1)
      else
        puts "Spotify API failed after #{attempts} attempts."
      end
    end
  end

  def to_query_string
    "#{artist.name} #{self.title}"
  end
end
