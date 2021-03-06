class Artist
  attr_accessor :songs, :name, :location, :date, :bio
  @@artists = []

  #Songs already initialized, search for matching songs using name.
  def initialize(artist_name)
    @songs = Song.all.select {|song| song.artist_name == artist_name}
    if @songs.empty?
      self.name = nil
    else
      BillboardScraper.scrape_from_artist_bio_page(@songs[0].artist_url).each {|key, value| self.send("#{key}=", value)}
      @@artists << self
    end
  end

  def self.all
    @@artists
  end

  #Artists have unique names, search for a match using the name or create a new Artist object.
  # ISSUE: song.artist_name and Artist.name will not match if the song has collaborators, meaning that a new artist object will be created each time.
  def self.find_or_create(artist_name)
    Artist.all.each {|artist| return artist if artist.name == artist_name}
    Artist.new(artist_name)
  end

end
