require 'uri'
require 'open-uri'
require 'nokogiri'

module FeedGenerator
  def self.build_yahoo_biz_rss
    charset = nil
    query_set = [
      "北米進出",
      "北米展開",
      "アメリカ進出",
      "米国展開",
      "米国進出",
      "US進出",
      "海外展開",
      "海外進出",
      "シリコンバレー",
      "イノベーション",
      "ベイエリア",
      "btrax",
      "ビートラックス",
      "クラウドファンディング"
    ]

    query_string = ""
    query_set.each_with_index do |query, index|
      query_string << query;
      query_string << "+OR+" if index < (query_set.length - 1)
    end

    yahoo_biz_news_url =
      "http://newsbiz.yahoo.co.jp/search?p=#{URI.escape(query_string)}"+
      "&to=0&ca=ecny&ca=etp&ca=mkt&ca=g_int&ca=cn&ca=asa"+
      "&ca=eus&ind=agr&ind=cst&ind=fds&ind=egy&ind=chm&ind=med"

    charset = nil
    html = open(yahoo_biz_news_url) do |f|
      charset = f.charset
      f.read
    end

    parse_yahoo_html(html, charset)
  end

  def self.build_english_news_rss()
    []
  end

  private

  def self.parse_yahoo_html(html, charset)
    feeds = []
    doc = Nokogiri::HTML.parse(html, nil, charset)

    doc.xpath('//div[@class="newsListBody"]').each do |newsList|
      newsList.xpath('//dl[@class="srchBox"]').each_with_index do |box,count|
        feed = Feed.new
        feed.title = box.xpath('//dt//p//a')[count].text
        feed.url = box.xpath('//dt//p//a')[count].attr('href')
        feed.desc = box.xpath('//dd[@class="listDetail"]/p')[count].text
        time = box.xpath('//dd[@class="newsSupple"]/span')[count].text
        feed.created_at = DateTime.parse(time)
        feeds.push(feed)
      end
    end

    feeds
  end
end
