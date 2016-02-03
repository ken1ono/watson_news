class FeedController < ApplicationController
  include FeedGenerator

  def index
    @feeds = FeedGenerator.build_yahoo_biz_rss()
    respond_to do |format|
      format.html
      format.rss
    end
  end
end
