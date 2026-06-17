SitemapGenerator::Sitemap.default_host = "https://ruby.org.au"

SitemapGenerator::Sitemap.create do
  add root_path, changefreq: 'daily', priority: 1.0
  add posts_path, changefreq: 'daily', priority: 0.9
  add '/posts/feed.rss', changefreq: 'daily', priority: 0.6
  add events_path, changefreq: 'weekly', priority: 0.8
  add job_seekers_path, changefreq: 'weekly', priority: 0.7
  add policies_path, changefreq: 'monthly', priority: 0.6
  add sponsorship_path, changefreq: 'monthly', priority: 0.7

  add forum_path, changefreq: 'monthly', priority: 0.4
  add videos_path, changefreq: 'weekly', priority: 0.5
  add merch_path, changefreq: 'monthly', priority: 0.4
  add roro_mailing_list_path, changefreq: 'monthly', priority: 0.4
  add community_contributions_path, changefreq: 'monthly', priority: 0.4

  Post.published.find_each do |post|
    add post_path(post), lastmod: post.updated_at, changefreq: 'weekly', priority: 0.8
  end
end
