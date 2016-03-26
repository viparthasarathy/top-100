class Top100::CLI
  attr_accessor :tracker, :current_hits, :scraper


  def initialize
    @tracker = 0
    @scraper = Top100::BillboardScraper.new
    @current_hits = self.scraper.scrape_from_chart_page
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
        hit = self.current_hits[self.tracker]
        puts "##{hit[:current_rank]}: #{hit[:song_name]} by #{hit[:song_artist]}. Previously number #{hit[:last_week_rank]} last week."
        puts "--------------------------------"
        self.tracker += 1
      end
    end
  end

  def display_artist(rank)
    artist = Top100::Artist.create_artist(rank)
    if artist == nil
      puts "Invalid input"
    else
      artist.display_details
    end
    puts "--------------------------------"
  end

  def present_options
    puts "Options: 1. type in 'exit' to exit. 2. type in 'next' for the next twenty songs. 3. type in the number of a song for an artist you would like to learn more about."
    choice = gets.chomp
    if choice == 'exit'
      puts "Now exiting..."
    elsif choice == 'next'
      display_chart
      present_options
    elsif choice.match(/\d+/)
      display_artist(choice.match(/\d+/)[0])
      present_options
    else
      puts "Unknown command. Try again."
      present_options
    end
  end


end
