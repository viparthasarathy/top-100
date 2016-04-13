class Artist
  attr_accessor :songs, :name, :location, :date, :bio
  @@artists = []

  #Songs already initialized, search for matching songs using name.
  def initialize(artist_name)
    @songs = Song.all.select {|song| song.artist_name == artist_name}
    if @songs.empty?
      self.name = nil
    else
      BillboardScraper.scrape_from_artist_bio_page(@songs[0].artist_bio_url).each {|key, value| self.send("#{key}=", value)}
      @@artists << self
    end
  end

  def display_details
    puts "Name: #{self.name}"
    puts "From: #{self.location}"
    puts "Formed: #{self.date} "
    song_names = self.songs.map {|s| s.name}
    puts "Currently Trending Songs: #{song_names.join(", ")}"
    puts "Bio: #{self.bio}"
  end

  def self.all
    @@artists
  end

  #Artists have unique names, search for a match using the name or create a new Artist object.
  def self.find_or_create(artist_name)
    Artist.all.each {|a| return a if a.name == artist_name}
    Artist.new(artist_name)
  end

end
