class CreateSongs < ActiveRecord::Migration[5.0]
  def change
    create_table :songs do |t|
      t.string :title
      t.datetime :date_first_charted
      t.references :artist
      
      t.timestamps
    end
  end
end
