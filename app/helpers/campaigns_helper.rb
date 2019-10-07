module CampaignsHelper
  def substituted_content(campaign, rsvp)
    content = substitute_content campaign.content, rsvp

    markdown_to_html content
  end

  # rubocop:disable Rails/OutputSafety
  def substitute_content(content, rsvp)
    return content if rsvp.nil?

    content.gsub(
      '{{ rsvp_links }}',
      tag.p(
        "#{link_to 'Yes', confirm_rsvp_url(rsvp.token)} " \
        "#{link_to 'No', decline_rsvp_url(rsvp.token)}".html_safe,
        class: 'button'
      )
    )
  end
  # rubocop:enable Rails/OutputSafety
end
