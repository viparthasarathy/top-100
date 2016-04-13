class BillboardScraper

  def self.scrape_from_chart_page
    nokogiri_object = Nokogiri::HTML(open('http://www.billboard.com/charts/hot-100'))
    nokogiri_object.css('div.chart-row__primary').each do |song|
      url = song.css('a.chart-row__player-link')
      name = song.css('h3.chart-row__artist').text.strip.split(//)
      song_hash = {
        rank: song.css('span.chart-row__current-week').text,
        name: song.css('h2.chart-row__song').text,
        artist_bio_url: song.css('a.chart-row__link').attribute('href').value + '/biography',
        artist_name: song.css('h3.chart-row__artist').text.strip,
        # missing url for some songs due to copyright issues, save url as nil for such songs
        url: url.empty? ? nil : url.attribute('href').value
      }
      Song.new(song_hash)
    end
  end

  def self.scrape_from_artist_bio_page(url)
    bio = Nokogiri::HTML(open(url))
    location_date = bio.css('dl.facts > dd').text
    info = bio.css('article.bio_content').text
    artist = {
      name: bio.css('h1.title').text,
      # missing information for some artists, need to catch that by checking if nokogiri returned empty strings.
      location: location_date.empty? ? "Not Specified" : location_date.split("  ")[0].strip,
      date: location_date.empty? ? "Not Specified" : location_date.match(/\d+/)[0],
      #issues with .empty? for bio due to return  values of long whitespace strings, so using regex to filter those out instead.
      # calling split on info to separate bio aside and main text which does not have a different grouping outside 'article.bio_content'
      bio: info.match(/\A\s*\z/) ? "Not Specified" : info.split("      ")[-1].strip
    }
  end

end
