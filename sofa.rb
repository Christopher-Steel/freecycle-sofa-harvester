require 'nokogiri'
require 'rest-client'

class Sofa
  def initialize(url, title)
    @title = title
    @url = url
    res = RestClient.get(url)
    doc = Nokogiri::XML.fragment(res.body)
    content = doc.css('#group_post')
    image_tag = content.xpath(%(
      .//a[child::img]
    ))
    @image_url = image_tag.attr('href') unless image_tag.empty?
  end

  def image?
    !@image_url.nil?
  end

  def to_s
    "#{@title} [#{@image_url}]"
  end

  # not sure how to properly ident the HTML in this function. I guess
  # that's another good reason to use models and views when generating HTML
  def to_html
    return '' unless image?
    %(<div>
        <a href="#{@url}" target="_blank">
          <img src="#{@image_url}">
        </a>
      </div>)
  end
end
