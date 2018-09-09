class UsersController < ApplicationController
  def spotify
    @spotify_user = RSpotify::User.new(request.env['omniauth.auth'])

    # (1980..1989).map do |year|
    #   song_uris = Song.all_from_year(year: year).map { |s| s.spotify_uri }
    #   playlist = @spotify_user.create_playlist!("R&B #{year}")
    #   song_uris.compact.each_slice(100).to_a.each do |song_chunk|
    #     playlist.add_tracks! song_chunk
    #   end
    # end

    (1960..1960).map do |year|
      song_uris = Song.all_from_year(year: year).map { |s| s.spotify_uri }
      playlist = @spotify_user.create_playlist!("Hot-100 #{year}")
      song_uris.compact.each_slice(100).to_a.each do |song_chunk|
        playlist.add_tracks! song_chunk
      end
    end
  end
end
