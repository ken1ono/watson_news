class FeedController < ApplicationController
  def index

  	@feeds = Array.new(3)

  	feed1 = Feed.new
  	feed1.title = "title1" 
  	feed1.url = "http://d.hatena.ne.jp/favril/20100604/1275668631"
  	feed1.desc = "dddddddddddddescescescescescescescescescescescescesc"
  	feed1.created_at = DateTime.new(2015, 9, 24, 6, 00, 45, 0.375)

  	feed2 = Feed.new
  	feed2.title = "title2" 
  	feed2.url = "https://github.com/btrax/watson_news/pull/3"
  	feed2.desc = "dddddddddddddescescescescescescescescescescescescesc"
  	feed2.created_at = DateTime.new(2015, 9, 24, 6, 00, 45, 0.375)

  	feed3 = Feed.new
  	feed3.title = "title3" 
  	feed3.url = "https://github.com/btrax/watson_news/pull/3"
  	feed3.desc = "dddddddddddddescescescescescescescescescescescescesc"
  	feed3.created_at = DateTime.new(2015, 9, 25, 6, 00, 45, 0.375)

  	@feeds[0] = feed1
  	@feeds[1] = feed2
  	@feeds[2] = feed3

	respond_to do |format|
		format.html
		format.rss
    end
  end
end
