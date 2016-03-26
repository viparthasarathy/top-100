class Top100::Artist
  attr_accessor :songs, :name, :location, :date, :bio
  CURRENT_HITS = Top100::BillboardScraper.new.scrape_from_chart_page

  def initialize(artist_hash)
    artist_hash.each {|key, value| self.send("#{key}=", value)}
    @songs = []
    self.add_current_hits
  end

  def add_current_hits
    CURRENT_HITS.each { |hit| self.songs << hit[:song_name] if hit[:song_artist].include?(self.name) }
  end

  def display_details
    puts "Name: #{self.name}"
    puts "From: #{self.location}"
    puts "Formed: #{self.date} "
    puts "Currently Trending Songs: #{self.songs.join(", ")}"
    puts "Bio: #{self.bio}"
  end

  def self.create_artist(rank)
    info_hash = CURRENT_HITS.find { |hit| hit[:current_rank] == rank }
    unless info_hash == nil
      artist_hash = Top100::BillboardScraper.new.scrape_from_artist_bio_page(info_hash[:artist_bio_link])
      artist = self.new(artist_hash)
      artist
    end
  end

end
