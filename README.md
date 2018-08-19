# song-collector

## Overview ##

A simple application for making historical Billboard charts into Spotify playlists.

## Goals ##

I wanted the experience of traveling back in time and listening to an R&B station in the 1980s.
 
Spotify & Pandora have very good recommendation engines, but I wanted a more direct solution to the problem of realistically imitating a vintage R&B station, that would include:

- Songs by artists who were popular at the time, but are obscure now
- "One-hit wonders": Artists who have appeared on the charts only once

I realized that a good data set was available in the form of Billboard.com's online listings of historical R&B/Hip-hop charts, which recorded the 100 most popular songs per week, published every Saturday.

This application scrapes that site for songs & artists, cross-references them with Spotify's available tracks, and generates playlists containing the resulting playable songs.

## Results ##

Of the **4,814 unique songs** listed on the Billboard R&B charts, Spotify **returned matching URIs for 3,253 (67.57%)**. In 5 hours of casual listening, I've only found a few that were clearly the incorrect match.

The program generates one playlist per chart year, from 1980 to 1989:

| Year  | Song count | Total length |
| --- | --- | --- |
| 1980  | 421  | 35 hr 50 min |
| 1981  | 321  | 26 hr 23 min |
| 1982  | 333  | 28 hr 4 min |
| 1983  | 323  | 27 hr 21 min |
| 1984  | 324  | 26 hr 43 min | 
| 1985  | 356  | 29 hr 17 min |
| 1986  | 315  | 25 hr 12 min |
| 1987  | 283  | 22 hr 19 min |
| 1988  | 279  | 22 hr 49 min |
| 1989  | 293  | 22 hr 45 min |
| Total | 3,253 | 266 hr 43 min (~11 days) |

## Project structure ##

### Populating the data ###

Most of the work is done by two rake tasks:

`scrape:eighties_rnb`: Calls down to [song-collector/app/services/billboard_scraper.rb](https://github.com/duncanmalashock/song-collector/blob/master/app/services/billboard_scraper.rb), which uses HTTParty and Nokogiri to scrape the artist names and song titles from the Billboard R&B/Hip-Hop charts, saving them as `Artist` and `Song` records.

`scrape:populate_spotify_uris`: Calls down to [Song.get_spotify_uri](https://github.com/duncanmalashock/song-collector/blob/master/app/models/song.rb#L19), which uses the RSpotify gem to search for the first match returned for each song title and artist name.

### Creating the playlists ###

Playlists can be automatically created through a Spotify API call, but this requires authorizing with a user's account. This is why this project is a Rails app and not just a few Ruby scripts.

The `/` route contains a Spotify OAuth link, which redirects to [users/spotify](https://github.com/duncanmalashock/song-collector/blob/master/app/controllers/users_controller.rb), where the `Users#spotify` controller action creates the playlists on the user's account.

## Further work ##

This is very much the bare minimum implementation for making these playlists, and there are a few improvements that might make this not just a cleaner project, but even an application that someone might find useful:

### Quick fixes ###

#### Do more to find and validate Spotify tracks ####

Right now, I'm relying on Spotify to either give me the first song it finds that matches "[ARTIST NAME] [SONG TITLE]", or nothing.

Spotify's fuzzy search is "good enough". In 5 hours of casual listening, I've heard only a few songs that were clearly incorrect matches (they were the wrong genre or were released more recently).

However, I think **anachronistic tracks could be filtered out** by using Spotify's track metadata, which include release date information.

Also, I've noticed in at least once case, **Spotify failed to return a matching result from its library** because of the title given in the Billboard charts.

Example:
- Query string from Billboard data: `"Quincy Jones Ai No Corrida (I-No-Ko-ree-da)"` (returns nothing)
- Query string: `"Quincy Jones Ai No Corrida"` (returns correct Spotify track)

I think this could be corrected by more sophisticated searching that involved the constraint of searching only against a found artist's Spotify tracks.

#### Recover from API errors when creating playlists ####

Right now, the API calls are made to Spotify for creating the playlists, and the data is never used by the application again. These API calls can fail, so this code could be made more robust by storing return values and retrying if bad status codes were returned by the API.

### Future enhancements ###

#### Methods for scraping other sites ####

Currently this code only knows how to scrape Billboard.com's charts. Being able to handle others could be nice for future playlist creation.

#### Data management features ####

Having logged in with Spotify, the server could provide a single-page application for:

- Fixing incorrect data manually
- Retrying Spotify track matching in case of failed API calls
- Sorting / filtering tracks to generate custom playlists

#### Song discovery via other data sources ####

Spotify data doesn't represent the people involved in the production of the music apart from the artist name. I think this is a huge missed opportunity, because it loses out on modeling the traditional crate-digging process of finding new music, i.e.:

*"I like this song. The drumming is so good and the production is so tasteful. What record is it on? Oh, looks like Steve Gadd was the drummer and it was produced by Quincy Jones. What else have they worked on together?"*

There are other sources for this data, like AllMusic and Discogs, but I haven't seen anything that allows you to look for music in those terms and then listen to them immediately on a streaming service. The simple integration between Billboard and Spotify that this application provides is a nice start. Features for discovering music through industry relationships could be a nice improvement.
