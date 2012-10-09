# Git Runner

git-runner is a ruby framework to implement and run tasks after code has been pushed to a Git repository. It works by invoking `git-runner` through `hooks/post-update` in your remote Git repository.

[Demonstration Video, Using git-runner to perform automatic deploys](http://ascii.io/a/1349)

Configuration for git-runner is read from a pre-determined file within the repository (at this time, that file is config/deploy.rb but this will soon be configurable). Any instructions detected are then processed and ran.

Instructions are contained within `lib/git-runner/instructions`. By default the instructions contained here and only used for support purposes, real functionality is abstracted into separate gems (at this time the only real instuction is deploy).

## Installation

    $ gem install git-runner

## Install any additional modules (you'll want to do this to get any real functionality)

### Deploy using Capistrano
[https://github.com/JamesBrooks/git-runner-deploy](https://github.com/JamesBrooks/git-runner-deploy)

    gem install git-runner-deploy


## Usage

Symlink `hooks/post-update` to `git-runner`, or if `post-update` is already in use modify it to run `git-runner` with the arguments supplied to the hook.

## Configuration

Configuration can be overwritten through a YAML file at either `/etc/git-runner.yml` or `$HOME/.git-runner.yml`. The current configuration options are:

  * **git_executable** (default: '/usr/bin/env git')
  * **instruction_file** (default: 'config/deploy.rb')
  * **instruction_prefix** (default: '# GitRunner:')
  * **tmp_directory** (default: '/tmp/git-runner')

## TODO

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
