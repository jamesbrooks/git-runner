# Git Runner

[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/JamesBrooks/git-runner)


Git Runner is a ruby framework to create and run tasks after commits are pushed to a git repository.

It works by having the git server-side post-update hook (`hooks/post-update`) invoke `git-runner`. Git Runner inspects all of the pushed branches (`refs/heads/*`) and looks for any Git Runner tasks (called instructions) to run. Such an instruction is `Deploy`, which allows for the application to be deployed after a push.

Git Runner instructions are distrubuted as separate gems, see **Available Instructions** below for what instructions are currently available for use.

Have a look at this short [demonistration video](http://ascii.io/a/1349) for what it looks like for a user pushing to a Git Runner enabled repository (using `git-runner-deploy`).


## Why?

#### Origins

Git Runner originated from a need to simply the deployment process (capistrano) within my organisation for people who don't have their environments setup with ruby and the required gems. I wanted to make the process work for even those who are using GUI git clients.


#### Wouldn't a simple script do the job?

While you certainly could create a ruby script at `hooks/post-update` and have that run after a push with good results, Git Runner provides a robust framework for authoring re-usable tasks that you can share between all of your code repositories and run only when you need to run them.

You could do it all in a script of your own if you like, but Git Runner is there to help you out and make the process less error-prone and more maintainable.


## How

After pushing to a git repository various server-side hooks are ran, including a hook named `post-update`. `post-update` needs to run `git-runner` with it's arguments.

Git Runner looks for pushes to any branches (`refs/heads/*`). For each branch it greps the repository for one or more Git Runner instructions within a instruction file.

The instruction file and instruction markers are configurable (see **Configuration** below), by default the configuration file is `config/deploy.rb` and Git Runner instructions begin with `# GitRunner:`, e.g.

```
# GitRunner: Deploy
... rest of the file ...
```

*Instructions can be on any line within the instruction file and multiple instructions are present (instructions are ran in order).*

Any instructions that are found within the instruction file are then processed and ran if able, with any messages being displayed to the user currently pushing the repository.

Any errors encountered will also be displayed with all relevent details being written to a log on the server.


## Features

* Robust framework for running tasks (instructions) after updates are made to a repository.
* Have all of your tasks available to all of your repositories, only use the ones you need on a per repository basis.
* Activiation through instructions contained within the repository.
* Branch detection, behave differently for different branches if you like.
* Simple authoring of additional instructions.
* Error handling, notification and logging.


## Available Instructions

Name                                                       | Gem               | Description
---------------------------------------------------------- | ----------------- | ---------------------------------------
[Deploy](https://github.com/JamesBrooks/git-runner-deploy) | git-runner-deploy | Application deployment using capistrano


## Installation

This section needs a lot more fleshing out as installation overly trivial. The main thing to worry about is making sure that `hooks/post-update` in each of your repositories is able to run `git-runner` (and pass it's arguments on).


#### Install the git-runner

Install the gem and any other additional instruction gems that you need, for example if we want Git Runner with capistrano deploy support:

```
gem install git-runner
gem install git-runner-deploy
```

#### Hook up git-runner to fire on hooks/post-update

There are a few ways to accomplish this, such as directly symlinking `hooks/post-update` to the executable path for git-runner. Currently I prefer the following approach of creating a script that loads rubygems and git-runner + calls git runner. The following is the contents of my `hooks/post-update` file:

```
#!/usr/bin/env ruby

require 'rubygems'
require 'git-runner'

GitRunner::Base.new(ARGV).run
```


## Configuration

Configuration can be changed through a YAML file at either `/etc/git-runner.yml` or `$HOME/.git-runner.yml`. The default configuration settings are:

Option             | Default Value    | Description
------------------ | ---------------- | --------------------------------------------------------------------------
git_executable     | /usr/bin/env git | Location of the git executable to use
instruction_file   | config/deploy.rb | Where to look for Git Runner instructions within each repository
instruction_prefix | # GitRunner:     | What Git Runner instructions will be prefixed with in the instruction file
tmp_directory      | /tmp/git-runner  | Working directory for git-runner


## TODOs

* Support to monitor a command (stdout and stderr) as the command is running, not just at the end.
* Instruction file path is globally set, make this overwritable on a per-repository basis?
* Instruction prefix is globally set, make this overwritable on a per-repository basis?
* Have core functionality fire useful hooks.
* Improve the output/text library, it can work better!
* Simplify Base#run (CodeClimate)


## Support

Check out [GitHub Issues](https://github.com/JamesBrooks/git-runner/issues) to see if anyone else has had the same problem you have, or create a new issue.

Also feel free to contact me directly (james at jamesbrooks dot net) for non-support comments or support of a more sensitive nature.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
