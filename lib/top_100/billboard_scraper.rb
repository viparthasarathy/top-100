class Top100::BillboardScraper

  def scrape_from_chart_page
    html = open('http://www.billboard.com/charts/hot-100')
    nokogiri_object = Nokogiri::HTML(html)
    charts_array = Array.new
    nokogiri_object.css('div.chart-row__primary').each do |song|
      charts_array << {
        current_rank: song.css('span.chart-row__current-week').text,
        last_week_rank: song.css('span.chart-row__last-week').text,
        song_name: song.css('h2.chart-row__song').text,
        song_artist: song.css('a.chart-row__link').text.strip,
        artist_bio_link: song.css('a.chart-row__link').attribute('href').value + '/biography'
      }
    end
    charts_array
  end


  def scrape_from_artist_bio_page(url)
    html = open(url)
    bio = Nokogiri::HTML(html)
    artist = {
      name: bio.css('h1.title').text,
      location: bio.css('dl.facts > dd').text.split("  ")[0].strip,
      date: bio.css('dl.facts > dd').text.match(/\d+/)[0],
    }
    bio.css('aside.bio_sidebar').remove
    artist[:bio] = bio.css('article.bio_content').text.strip
    artist
  end

end
