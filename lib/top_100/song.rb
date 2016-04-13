class Song
  attr_accessor :rank, :name, :artist_name, :artist_bio_url, :url
  @@songs = []

  def initialize(song_hash)
    song_hash.each {|key, value| self.send("#{key}=", value)}
    @@songs << self
  end

  def self.all
    @@songs
  end

  def display
    puts "##{self.rank}: #{self.name} by #{self.artist_name}."
    puts "--------------------------------"
  end

  def self.play(rank)
    song = Song.all.find {|s| s.rank == rank }

    if song.nil?
      puts "You've entered an invalid chart name."
    #check if song has a valid url, copyright issues with certain songs
    elsif !!song.url
      puts "Playing song..."
      `open #{song.url}`
    else
      puts "Sorry, that artist does not have their song on Spotify."
    end
  end

end
