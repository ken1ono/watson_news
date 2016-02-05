require 'uri'
require 'open-uri'
require 'nokogiri'

module FeedGenerator
  class << self
    def build_yahoo_biz_rss
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

      query_string = or_condition_builder(query_set);
      yahoo_biz_news_url =
        "http://newsbiz.yahoo.co.jp/search?p=#{URI.escape(query_string)}"+
        "&to=0&ca=ecny&ca=etp&ca=mkt&ca=g_int&ca=cn&ca=asa"+
        "&ca=eus&ind=agr&ind=cst&ind=fds&ind=egy&ind=chm&ind=med"

      parse_yahoo_html(yahoo_biz_news_url)
    end

    def build_english_news_rss
      query_set = [
        "startup"
      ]

      query_string = or_condition_builder(query_set)
      business_insider_news_url =
        "http://www.businessinsider.com/s?q=#{query_string}"+
        "&sort=date"

      parse_english_news_rss(business_insider_news_url)
    end

    private

    def parse_english_news_rss(target_url)
      feeds = []
      doc = Nokogiri::HTML(open(target_url))

      doc.xpath('//div[@class="search-result"]').each_with_index do |result_item, index|
        title = result_item.xpath('//h3/a')[index]
        content = result_item.xpath('//div[@class="excerpt"]')[index]
        date = result_item.xpath('//li[@class="river-post__date"]/span[@data-bi-format="date"]')[index].text

        feed = Feed.new
        feed.title = title.text
        feed.url = title.attr('href')
        feed.desc = content.text
        feed.created_at =
          if date.end_with?('m')
            (Time.now - 60 * date.chop.to_i).to_datetime
          elsif date.end_with?('h')
            (Time.now - (60 ** 2 * date.chop.to_i)).to_datetime
          else
            DateTime.parse(date)
          end

        feeds.push(feed)
      end

      feeds
    end

    def parse_yahoo_html(target_url)
      feeds = []
      doc = Nokogiri::HTML(open(target_url))

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

    def or_condition_builder(query_array)
      query_string = ""
      query_array.each_with_index do |query, index|
        query_string << query;
        query_string << "+OR+" if index < (query_array.length - 1)
      end
      query_string
    end
  end
end
