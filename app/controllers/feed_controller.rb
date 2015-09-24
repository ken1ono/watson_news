class FeedController < ApplicationController
  def index

  	@feeds = Array.new(2)

  	feed1 = Feed.new
  	feed1.title = "title1" 
  	feed1.url = "http://d.hatena.ne.jp/favril/20100604/1275668631"
  	feed1.desc = "dddddddddddddescescescescescescescescescescescescesc"

  	feed2 = Feed.new
  	feed2.title = "title2" 
  	feed2.url = "https://github.com/btrax/watson_news/pull/3"
  	feed2.desc = "dddddddddddddescescescescescescescescescescescescesc"

  	@feeds[0] = feed1
  	@feeds[1] = feed2

	respond_to do |format|
		format.html
		format.rss
    end
  end
end
