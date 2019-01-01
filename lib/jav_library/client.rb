require 'nokogiri'
require 'watir'

module JavLibrary
  HOST = "http://www.javlibrary.com/en/vl_searchbyid.php?keyword="
  
  class Client
    attr_reader :success

    def initialize
      @browser = Watir::Browser.new :firefox, 'pageLoadStrategy': 'eager'
      # Disable alerts
      @browser.execute_script "window.alert = () => {}"
    end

    def load(code)
      @browser.goto HOST + code
      @browser.cookies.add "over18", "18"

      # For cloudflare's ddos checking
      begin
        while @browser.html.include? "<title>Just a moment...</title>"
          sleep 0.1
        end
      rescue
        sleep 0.1
        retry
      end

      # Wait until page is loaded
      until @browser.html.include? 'leftmenu'
        sleep 0.1
      end

      @success = !@browser.html.include?('The search term you entered is invalid.')
      @doc = Nokogiri::HTML @browser.html
      
      # if multiple search results
      if @doc.css('.videos').length > 1
        url = 'http://www.javlibrary.com/en/'
        url += @doc.at_css('.videos a').attr('href').split('./', 2).last
        @browser.goto url
        @browser.cookies.add 'over18', '18' 
        @doc = Nokogiri::HTML(@browser.html)
      end
    end

    def title
      # splits to remove the prepended jav code
      @doc.at_css('.post-title a').content.split(' ', 2).last
    end

    def cast
      @doc.css('#video_cast .star a').map(&:content)
    end

    def cover
      src = @doc.at_css('#video_jacket_img').attr('src')
      'https:' + src.sub('http:', '')
    end

    def release_date
      @doc.at_css("#video_date .text").content
    end

    def genres
      @doc.css("#video_genres .genre").map(&:content)
    end

    def close
      @browser.close
    end
  end
end
