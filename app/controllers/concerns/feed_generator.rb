require 'uri'
require 'open-uri'
require 'nokogiri'

module FeedGenerator
  class << self
    YAHOO_BIZ_RSS_QUERY_SET = [
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

    TECH_IN_ASIA_RSS_QUERY_SET = [
      "japan"
    ]

    def build_yahoo_biz_rss
      query_set = YAHOO_BIZ_RSS_QUERY_SET
      query_string = condition_builder(query_set, { with_or: true });
      yahoo_biz_news_url =
        "http://news.search.yahoo.co.jp/search?p=#{URI.escape(query_string)}"+
        "&vaop=a&to=0&st=&c_=dom&c_=c_int&c_=bus&c_=c_sci"
      parse_yahoo_html(yahoo_biz_news_url)
    end

    def build_english_news_rss
      query_set = TECH_IN_ASIA_RSS_QUERY_SET
      query_string = condition_builder(query_set, { with_or: false });
      techinasia_news_url = "https://www.techinasia.com/search?query=#{query_string}"
      parse_techinasia_news(techinasia_news_url);
    end

    private

    #
    # HTML parser for TechInAsia news
    #
    def parse_techinasia_news(target_url)
      feeds = []
      doc = Nokogiri::HTML(open(target_url))

      doc.xpath('//article[@class="post-list__item"]').each do |article|

      end

      feeds
    end

    #
    # HTML parser for Yahoo news
    #
    def parse_yahoo_html(target_url)
      feeds = []
      doc = Nokogiri::HTML(open(target_url))

      doc.xpath('//div[@class="newsListBody"]').each do |newsList|
        newsList.xpath('//dl[@class="srchBox"]').each_with_index do |box, count|
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

    #
    # This creates "+OR+" connected string from the given array
    #
    # [Params]
    # - query_array: the set of strings that are converted into one queried string.
    # - options: the option flag to set to use "+OR+" chain.
    #
    def condition_builder(query_array, options)
      chain_code = options[:with_or] ? "+OR+" : "+";
      query_string = ""
      query_array.each_with_index do |query, index|
        query_string << query;
        query_string << chain_code if index < (query_array.length - 1)
      end
      query_string
    end
  end
end
