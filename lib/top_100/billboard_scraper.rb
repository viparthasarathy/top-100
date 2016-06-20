class BillboardScraper

  # will only use class methods, no need to create instances as there's nothing unique between these scrapers and we only need one.
  def self.scrape_from_chart_page
    billboard_page = Nokogiri::HTML(open('http://www.billboard.com/charts/hot-100'))
    rss = RSS::Parser.parse(open('http://www.billboard.com/rss/charts/hot-100'))
    rss.items.each_with_index do |song, index|
      #account for any song titles that might happen to have ': ' in their title.
      name = song.title.split(": ")[1..-1].join(": ")
      rank = song.title.split(": ")[0]
      song_hash = {
        rank: rank,
        name: name,
        #feed doesn't seem to offer an artist value, requiring us to extract artist name from description instead.
        #ISSUE: Collaborators saved as part of the artist name, which causes some difficulties with the search term for looking up the artist biography.
        # One possible solution would be to compare artist_name and the artist_url slug value in order to determine where the artist name begins and ends and then save that value to song instead.
        artist_name: song.description.split("#{name} by ")[1].split(" ranks ##{rank}")[0],
        artist_url: billboard_page.css('a.chart-row__artist')[index].attribute('href').value + '/biography',
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
