class Song < ApplicationRecord
  validates :title, presence: true, uniqueness: { scope: :artist_id }
  validates :date_first_charted, presence: true

  belongs_to :artist

  def self.create_with_artist_name(title:, artist_name:, date_first_charted:)
    a = Artist.find_by(name: artist_name)
    if !a.present? then
      a = Artist.create(name: artist_name)
    end
    Song.create(title: title, date_first_charted: date_first_charted, artist: a)
  end

  def to_s
    "#{artist.name}: #{self.title} (#{date_first_charted.strftime("%Y")})"
  end
end
