require 'nokogiri'
require 'watir'

module JavLibrary
  HOST = "http://www.javlibrary.com/en/vl_searchbyid.php?keyword="
  
  class Client
    def initialize
      @browser = Watir::Browser.new :firefox
      # Disable alerts
      @browser.execute_script "window.alert = () => {}";
    end

    def load(code)
      @browser.goto HOST + code
      @browser.cookies.add "over18", "18"
      
      # For cloudflare's ddos checking
      sleep 10
      while @browser.html.include? "<title>Just a moment...</title>"
        sleep 0.1
      end

      @doc = Nokogiri::HTML @browser.html
    end

    def title
      # splits to remove the prepended jav code
      @doc.at_css('.post-title a').content.split(' ', 2).last
    end

    def cast
      @doc.css('#video_cast .star a').map(&:content)
    end

    def cover
      @doc.at_css('#video_jacket_img').attr('src').sub("http", "https")
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
