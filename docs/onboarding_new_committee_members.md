# README

Incoming committee members should be added to the following groups:

- Ruby Australia Slack - invite to `org-committee` channel
- Ruby Australia [GitHub](https://github.com/orgs/rubyaustralia/teams/committee) - add to `committee` team

Check to confirm you have access to the Slack and Github accounts and advise the Secretary
or President if you do not.

## Adding Yourself to the Website
Add your profile to the [Ruby Australia Website - Committee Members](https://ruby.org.au/committee-members)

**Step 1**: Add your profile to the `config/data/committee.yml` file.

**Step 2**: Add your photo to the `app/assets/images/committee-members/` directory. Create the photo with a filename including your first name and last name in lowercase, e.g. `example-lastname.jpg`
and ensure there's the hyphen between the first and last name. The file should be a square image, ideally 300x300 pixels.

**Step 3** (optional): Remove any remaining outgoing committee members from the `config/data/committee.yml` file.

**Step 4** (optional): Copy the outgoing committee member's profile to the `config/data/previous.yml` file.

## Removing outgoing committee members
When a committee member leaves, their profile should be removed from the current committee members list. Please
assist by copying their profile to the top of the file located in `config/data/previous.yml`.
