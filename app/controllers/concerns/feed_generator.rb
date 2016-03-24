require 'uri'
require 'open-uri'
require 'nokogiri'

module FeedGenerator
  class << self
    YAHOO_BIZ_RSS_QUERY_SET = [
      "ライフハック",
      "睡眠",
      "マラソン",
      "勉強法"
    ]

    TECH_IN_ASIA_RSS_QUERY_SET = [
      "japan"
    ]

    def build_yahoo_biz_rss
      query_set = YAHOO_BIZ_RSS_QUERY_SET
      query_string = condition_builder(query_set, { with_or: false });
      yahoo_biz_news_url =
        "http://news.search.yahoo.co.jp/search?p=#{URI.escape(query_string)}"+
        "&vaop=o&to=0&st=&c_=dom&c_=c_int&c_=bus&c_=c_ent&c_=c_spo&c_=c_sci&c_=c_life&c_=loc"
      puts yahoo_biz_news_url
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

      doc.css("div.l.cf").each do |article|
        feed = Feed.new
        feed.title = article.css("h2.t a").text
        feed.url = article.css("a").attribute("href")
        feed.desc = article.css("div.txt p.a").text
        posted_time = article.css("div.txt p span.d").text
        feed.created_at = yahoo_article_date_parser(posted_time).to_s
        feeds.push(feed)
      end

      feeds
    end

    def yahoo_article_date_parser(datetext)
      month_sign_index = datetext.index("月")
      day_sign_index = datetext.index("日")
      hour_sign_index = datetext.index("時")
      minute_sign_index = datetext.index("分")
      # weekday_brace_begin = datetext.index("（")
      weekday_brace_end = datetext.index("）")

      month = datetext[0...month_sign_index].to_i
      day = datetext[(month_sign_index + 1)...day_sign_index].to_i
      # weekday = datetext[(weekday_brace_begin + 1)...weekday_brace_end]
      hour = datetext[(weekday_brace_end + 2)...hour_sign_index].to_i
      minute = datetext[(hour_sign_index + 1)...minute_sign_index].to_i
      year = Time.now.year # News must be always hot!

      DateTime.new(year, month, day, hour, minute);
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
