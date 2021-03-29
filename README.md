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

1. Copy `config.example.json` to `config.json`.
2. Run `work_day configure` to set your prefs.

### Slack API Token

You can obtain a Slack API token [here](https://api.slack.com/custom-integrations/legacy-tokens).

And add this to something like `~/.secrets` that's NOT included in your public dotfiles repo. 😉 Make sure `~/.secrets` is `source`-ed by your `.bashrc` or `.zshrc`.

```sh
export SLACK_API_TOKEN=MY_API_TOKEN
```

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

- [ ] Make this thing a gem instead of a hand-rolled joby
- [ ] Use TTY components everywhere. Implement a base clase to inherit from like the TTY Command class.
- [ ] Offer the option to handle pco-box in the ☁
  - create tmux session but don't attach, if needed: `tmux new-session -d -s foobar`
  - `ssh pco_box_cloud9 -t "tmux send-keys \"cd ~/pco-box && git pull\" Enter"`
- [ ] Manage Do Not Disturb for MacOS and Ubuntu
  - https://github.com/joshpetit/toggle_dnd/blob/master/toggle_dnd
  - https://apple.stackexchange.com/questions/145487/how-to-enable-disable-do-not-disturb-from-shell-on-mavericks
