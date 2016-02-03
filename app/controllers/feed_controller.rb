class FeedController < ApplicationController
  include FeedGenerator

  def index
    begin
      if params["lang"].blank?
        raise("Lang parameter is not present")
      end

      @feeds =
        case params["lang"]
        when "ja" then FeedGenerator.build_yahoo_biz_rss()
        when "en" then FeedGenerator.build_english_news_rss()
        else raise("Invalid Lang parameter given")
        end

      respond_to do |format|
        format.html
        format.rss
      end
    rescue => e
      render(text: e, status: 500)
    end
  end
end
