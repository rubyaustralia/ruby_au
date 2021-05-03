## Events and Campaigns

Committee members can manage events and campaigns through the website.

Currently, events (the model RsvpEvent) can only be created via a Rails console, like so:

```ruby
RsvpEvent.create(
  title: "Special General Meeting 2021",
  happens_at: Time.find_zone("Australia/Melbourne").local(2021, 5, 10, 19)
)
```

From there, email campaigns can be created and edited in [the web interface](https://ruby.org.au/admin/campaigns) (only by users who are flagged as committee). Email campaigns can be previewed through the browser, and past campaigns can also be accessed (albeit through URL tweaking) to see their Markdown copy. For example: https://ruby.org.au/admin/campaigns/2/edit

You can see in existing campaign markup that `{{ rsvp_links }}` is used - this is translated to Yes/No links for members to RSVP for events.

Due to the amount of emails that are sent for a campaign, sending them is handled via a rake task using the campaign's primary key:

```
heroku run rake campaigns:send CAMPAIGN_ID=X
```
