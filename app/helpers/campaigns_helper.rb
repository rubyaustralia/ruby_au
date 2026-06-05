module CampaignsHelper
  def substituted_content(campaign, rsvp)
    content = substitute_content campaign.content, rsvp

    markdown_to_html content
  end

  # rubocop:disable Rails/OutputSafety
  def substitute_content(content, rsvp)
    return content if rsvp.nil?

    content = content.gsub('{{member.name}}', rsvp.membership.full_name)
    content = content.gsub('{{unsubscribe_link}}', unsubscribe_invitation_url(rsvp.token))

    if rsvp.rsvp_event
      content = content.gsub('{{event.title}}', rsvp.rsvp_event.title)
      content = content.gsub('{{event.date}}', rsvp.rsvp_event.happens_at.strftime('%B %d, %Y'))
    end

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
