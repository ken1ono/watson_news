require 'open-uri'
require 'nokogiri'

class FeedController < ApplicationController
  def index
	url = 'http://newsbiz.yahoo.co.jp/search?p=%E5%8C%97%E7%B1%B3%E9%80%B2%E5%87%BA+OR+%E5%8C%97%E7%B1%B3%E5%B1%95%E9%96%8B+OR+%E3%82%A2%E3%83%A1%E3%83%AA%E3%82%AB%E9%80%B2%E5%87%BA+OR+%E7%B1%B3%E5%9B%BD%E5%B1%95%E9%96%8B+OR+%E7%B1%B3%E5%9B%BD%E9%80%B2%E5%87%BA+OR+US%E9%80%B2%E5%87%BA+OR+%E6%B5%B7%E5%A4%96%E5%B1%95%E9%96%8B+OR+%E6%B5%B7%E5%A4%96%E9%80%B2%E5%87%BA+OR+%E3%82%B7%E3%83%AA%E3%82%B3%E3%83%B3%E3%83%90%E3%83%AC%E3%83%BC+OR+%E3%82%A4%E3%83%8E%E3%83%99%E3%83%BC%E3%82%B7%E3%83%A7%E3%83%B3+OR+%E3%83%99%E3%82%A4%E3%82%A8%E3%83%AA%E3%82%A2+OR+btrax+OR+%E3%83%93%E3%83%BC%E3%83%88%E3%83%A9%E3%83%83%E3%82%AF%E3%82%B9&to=0&ca=ecny&ca=etp&ca=mkt&ca=g_int&ca=cn&ca=asa&ca=eus&ind=agr&ind=cst&ind=fds&ind=egy&ind=chm&ind=med&ind=mch&ind=eqp&ind=aut&ind=ot_mfr&ind=trs&ind=inf&ind=mda&ind=lgt&ind=fince&ind=svc&at=n&sort=new'

  	charset = nil
  	html = open(url) do |f|
    	charset = f.charset
		f.read
	end

	doc = Nokogiri::HTML.parse(html, nil, charset)

	@feeds = []
	doc.xpath('//div[@class="newsListBody"]').each do |newsList|
		newsList.xpath('//dl[@class="srchBox"]').each_with_index do |box,count|
			feed = Feed.new
			feed.title = box.xpath('//dt//p//a')[count].text
			feed.url = box.xpath('//dt//p//a')[count].attr('href')
			feed.desc = box.xpath('//dd[@class="listDetail"]/p')[count].text
			time = box.xpath('//dd[@class="newsSupple"]/span')[count].text
			feed.created_at = DateTime.parse(time)

			@feeds.push(feed)
		end
	end

	respond_to do |format|
		format.html
		format.rss
    end
  end
end
