require 'nokogiri'

require_relative 'sofa'

class HarvestedPage
  def initialize(html)
    doc = Nokogiri::XML.fragment(html)
    table = doc.css('#group_posts_table')
    @rows = table.xpath(%(.//tr))
  end

  def to_sofas
    [].tap do |sofas|
      @rows.each do |r|
        cols = r.xpath(%(.//td))
        link = cols[1].xpath(%(.//a))[0]
        sofa = Sofa.new(link.attr('href'), link.inner_text)
        sofas << sofa if sofa.image?
      end
    end
  end
end
