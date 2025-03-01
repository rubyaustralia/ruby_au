# find https://github.com/huacnlee/social-share-button/blob/master/lib/social_share_button/config.rb#L33 to all supported sites
SocialShareButton.configure do |config|
  config.allow_sites = %w(
    twitter
    facebook
    douban
    tumblr
    pinterest
    email
    linkedin
    vkontakte
    xing
    reddit
    hacker_news
    telegram
    odnoklassniki
    whatsapp_app
    whatsapp_web
  )
end
