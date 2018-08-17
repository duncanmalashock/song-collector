class AddQueriedSpotifyToSongs < ActiveRecord::Migration[5.0]
  def change
    add_column :songs, :queried_spotify, :boolean, default: false
  end
end
