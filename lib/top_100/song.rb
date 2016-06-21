class Song
  attr_accessor :rank, :name, :artist_name, :artist_url, :url
  @@songs = []

  def initialize(song_hash)
    song_hash.each {|key, value| self.send("#{key}=", value)}
    @@songs << self
  end

  #slug method used to help make query for spotify API request
  def slug
    self.name.gsub(/\s+/, "%20").delete('^a-zA-Z0-9\%').downcase
  end

  def spotify_link
    response = open("https://api.spotify.com/v1/search?q=#{self.slug}&type=track").read
    json_info = JSON.parse(response)
    # songs share same track name, ensure that artist name includes the first artist to find a match.
    song_details = json_info["tracks"]["items"].find { |info| self.artist_name.downcase.include?(info["artists"][0]["name"].downcase) }
    song_details == nil ? nil : song_details["preview_url"]
  end

  # class methods

  def self.all
    @@songs
  end

  def self.find_by_rank(rank)
    song = Song.all.find {|song| song.rank == rank }
  end

end
