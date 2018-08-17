class UsersController < ApplicationController
  def spotify
    @spotify_user = RSpotify::User.new(request.env['omniauth.auth'])

    playlist = @spotify_user.create_playlist!('R&B 1980')

    songs_from_1980 = Song.all_from_year(year: 1980)
    songs_from_1980.each do |s|
      search_result = RSpotify::Track.search(s.to_query_string, limit: 1)
      if search_result != [] then
        playlist.add_tracks! search_result
      end
      sleep 2
    end
  end
end
