Work Day
========

![workday.png](/screenshots/workday.png)

Start and end your workday at Planning Center with this handy little command line tool.

### Features

- Post a standup or normal message to your team's Slack channel.
- Update `pco-box`
- Update Planning Center apps to latest code
- Handle `pco-box` running locally, or in the ☁
- Handles wip/unwip committing uncommitted work on feature branches, in case you forgot. This helps avoid annoying "Git borked..." messages when updating apps.
- Allows opening/closing additional apps for your workday, e.g. VSCode, Trello, etc.
- Sign off in Slack at the end of your day, and shut down `pco-box`

### Requirements

- Latest [pco](https://github.com/ministrycentered/pco) installed

### Installation

1. Clone this repo to the location of your choice
2. `bin/setup`
3. (Optional) `bundle exec rake install:local`

### Slack API Token

You can obtain a Slack API token [here](https://api.slack.com/custom-integrations/legacy-tokens).

And add this to something like `~/.secrets` that's NOT included in your public dotfiles repo. 😉 Make sure `~/.secrets` is `source`-ed by your `.bashrc` or `.zshrc`.

```sh
export SLACK_API_TOKEN=MY_API_TOKEN
```

### Usage

We'll assume that you've install the gem locally, and use the included binary `workday`. If you haven't installed the gem, simply replace `workday` with `./exe/workday`.

Starting your work day is EzPz:

```sh
workday start
```

And ending it is, too:

```sh
workday end
```

Check out the help for more info on options:

```sh
workday help
```

### Bugs

- [ ] Currently, you have to be in the `workday` dir to run config. Fix it!

### TODO

- [x] Make this thing a gem instead of a hand-rolled joby
- [x] Use TTY components everywhere. Implement a base clase to inherit from like the TTY Command class.
- [x] Implement a `bin/setup` and `bin/console`
- [x] Implement a DEBUG mode
  - [x] Post all Slack messages to @YOURSELF
  - [x] Quiet `command` output normally, show all of it with `--debug`
  - What else?
- [x] Offer the option to handle pco-box in the ☁
- [x] Implement adding apps to AdditionalApps thru the Config interface
- [x] Keep config items alpha-sorted
- [x] Use magic predicate methods on options, e.g. `options.debug?`
- [ ] Investigate using Thor::Group to handle series of tasks
- [ ] Make sure working branch is up on github and offer to WIP commit and push up uncommitted work when ending the day
- [ ] Add tests
