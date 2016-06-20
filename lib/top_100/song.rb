class Song
  attr_accessor :rank, :name, :artist_name, :artist_url, :url
  @@songs = []

  def initialize(song_hash)
    song_hash.each {|key, value| self.send("#{key}=", value)}
    @@songs << self
  end

  def display
    puts "##{self.rank}: #{self.name} by #{self.artist_name}."
    puts "--------------------------------"
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

  def self.play(rank)
    song = Song.all.find {|song| song.rank == rank }
    if song.nil?
      puts "You've entered an invalid chart rank."
    else
      song.url = song.spotify_link
      #check if song has a valid url, copyright issues with certain songs
      if !!song.url
        puts "Playing song..."
        `open #{song.url}`
      else
        puts "Sorry, that artist does not have their song on Spotify."
      end
    end
  end

end
