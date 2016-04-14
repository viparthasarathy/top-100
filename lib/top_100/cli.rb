class CLI
  attr_accessor :tracker


  def initialize
    @tracker = 0
    BillboardScraper.scrape_from_chart_page
  end

  def call
    puts "Welcome to the Billboard Hot 100. Now outputting the top twenty songs..."
    display_chart
    present_options
  end

  def display_chart
    if self.tracker >= 100
      puts "There are no more songs to display."
    else
      20.times do
        Song.all[self.tracker].display
        self.tracker += 1
      end
    end
  end

  def display_artist(name)
    artist = Artist.find_or_create(name)
    artist.name == nil ? puts("Artist not found.") : artist.display_details
    puts "--------------------------------"
  end

  def present_options
    puts "Options: 1. type in 'exit' to exit. 2. type in 'next' for the next twenty songs. 3. type 'song' to play a song sample. 4. type in the full artist title of a song to learn more about the main artist."
    choice = gets.chomp
    case choice
    when 'exit'
      puts "Now exiting..."
    when 'next'
      display_chart
      present_options
    when 'song'
      puts "Enter the chart number of the song you would like to play."
      rank = gets.chomp
      Song.play(rank)
      present_options
    else
      begin
        display_artist(choice)
        # catches issues using OpenURI to access certain artist pages or issues with making frequent requests
        rescue OpenURI::HTTPError => error
          puts "Sorry, we're having trouble displaying this artist's details."
      end
      present_options
    end
  end

end
