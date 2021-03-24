Work Day
========

Start and end your workday at Planning Center with this handy little command line tool.

### Features

- Post a standup or normal message to your team's Slack channel.
- Update `pco-box`
- Update Planning Center apps to latest code
- Handles wip/unwip committing uncommitted work on feature branches, in case you forgot. This helps avoid annoying "Git borked..." messages when updating apps.
- Allows opening/closing additional apps for your workday, e.g. VSCode, Trello, etc.
- Sign off in Slack at the end of your day, and shut down `pco-box`

### Installation

1. Clone this repo to the location of your choice, and ideally, make sure it's in your `PATH`.
2. `bundle install`

### Setup

First, copy `config.example.json` to `config.json`.

You'll need to setup some environment variables. Add these to your `.bashrc` or `.zshrc`.

```sh
export SLACK_CHANNEL=MY_SLACK_CHANNEL_OF_CHOICE
export SLACK_ICON_URL=https://example.com/some-sweet-icon.png"
```

And add this to something like `~/.secrets` that's NOT included in your public dotfiles repo. 😉

```sh
export SLACK_API_TOKEN=MY_API_TOKEN
```

You can obtain a Slack API token [here](https://api.slack.com/custom-integrations/legacy-tokens).

### Usage

Starting your work day is EzPz:

```sh
work_day start
```

And ending it is, too:

```sh
work_day end
```

Check out the help for more info on options:

```sh
work_day help
```

### TODO

- [ ] Offer the option to handle pco-box in the ☁
