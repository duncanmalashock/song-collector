class UsersController < ApplicationController
  def spotify
    @spotify_user = RSpotify::User.new(request.env['omniauth.auth'])

    (1980..1989).map do |year|
      song_uris = Song.all_from_year(year: year).map { |s| s.spotify_uri }
      playlist = @spotify_user.create_playlist!("R&B #{year}")
      song_uris.each_slice(25).to_a.each do |song_chunk|
        playlist.add_tracks! song_chunk
      end
    end
  end
end
