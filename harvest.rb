require 'rest-client'

require_relative 'harvested_page'

API_URL = 'https://groups.freecycle.org'.freeze

class Harvester
  def initialize
    @api = RestClient::Resource.new(API_URL)
    @sofas = []
  end

  def harvest_group(group)
    @api["group/#{group}/posts/search"].post(
      {
        search_words: 'sofa couch settee',
        include_offers: 'on',
        date_start: '',
        date_end: '',
        resultsperpage: 100
      },
      content_type: 'application/x-www-form-urlencoded'
    ) do |res|
      return HarvestedPage.new(res.body).to_sofas
    end
  end

  def group_list
    %w(
      HampsteadUK
      kentishtown_freecycle
      camdensouth_freecycle
    )
  end

  def harvest
    group_list.each do |group|
      puts "<h3>#{group}</h3>"
      sofas = harvest_group(group)
      sofas.each { |s| puts s.to_html }
    end
  end
end

Harvester.new.harvest
