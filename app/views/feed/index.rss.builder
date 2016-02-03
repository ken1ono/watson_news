xml.instruct! :xml, :version => "1.0"
xml.rss("version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/") do
  xml.channel do
    xml.title "Potential User (#{@lang})"
    @feeds.each do |feed|
      xml.item do
        xml.title feed.title
        xml.description feed.desc
        xml.pubDate feed.created_at.in_time_zone('Tokyo').to_s(:rfc822)
        # xml.guid "http://example.com/posts/#{post.id}"
        xml.link feed.url
      end
    end
  end
end
