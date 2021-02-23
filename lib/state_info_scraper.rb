# build scrapper to go get state info, create array of hashes that stores each state
require 'nokogiri'

class StateInfoScraper
  attr_accessor :site

  def initialize
    @site = site
  end
  def scrape(site)
    doc = Nokogiri::HTML(HTTParty.get(site))
    binding.pry
  end

  # find info
  # 
# collect for a state
# put that in hash
# add hash to array
# go onto next state
# return array when finished


# state_info.count #=> 50
# state_info #=> [{name: "ohio", motto: "live free"}]
end