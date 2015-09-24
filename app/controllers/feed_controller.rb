class FeedController < ApplicationController
  def index

  	@feeds = Array.new

	respond_to do |format|
		format.html
		format.rss
    end
  end
end
