xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0" do
  xml.channel do
    xml.title "Ruby Australia - News Feed"
    xml.description "We are an organisation that is dedicated to supporting the community and events around Australia focused on the Ruby programming language. Providing financial and institutional support for RubyConf AU, Ruby Retreats, RailsGirls, and the meetups across the country."
    xml.link root_url # Use full URLs, not relative paths

    @posts.each do |post|
      xml.item do
        xml.title post.title
        xml.description post.content
        xml.pubDate (post.published_at || post.created_at).rfc822
        xml.link post_url(post)
        xml.guid post_url(post)
        xml.author post.user&.full_name || "Ruby Australia"
        xml.category post.category.titleize if post.category.present?
      end
    end
  end
end
