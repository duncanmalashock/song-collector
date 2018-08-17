class UsersController < ApplicationController
  def spotify
    @spotify_user = RSpotify::User.new(request.env['omniauth.auth'])

    (1980..1989).map do |year|
      song_uris = Song.all_from_year(year: year).map { |s| s.spotify_uri }
      playlist = @spotify_user.create_playlist!("R&B #{year}")
        playlist.add_tracks! song_uris.compact
      end
    end
  end
end
