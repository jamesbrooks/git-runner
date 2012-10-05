# GitRunner

GitRunner is a ruby framework to implement and run tasks after code has been pushed to a Git repository. It works by invoking `git-runner` through `hooks/post-update` in your remote Git repository.

[Demonstration Video, Using git-runner to perform automatic deploys](http://ascii.io/a/1349)

Configuration for GitRunner is read from a pre-determined file within the repository (at this time, that file is config/deploy.rb but this will soon be configurable). Any instructions detected are then processed and ran.

Instructions are contained within `lib/git-runner/instructions`, though soon these will be extracted out to separate gems, leaving only the core instructions present. Currently the only *real* instruction that users will want to run is Deploy, which will checkout your code, run bundler and perform a cap deploy (with multistage support).

## Installation

    $ gem install git-runner

## Usage

Symlink `hooks/post-update` to `git-runner`, or if `post-update` is already in use modify it to run `git-runner` with the arguments supplied to the hook.

## TODO

* Allow file based configuration (currently configuration is hard-coded)
* Extract our non-core instruction functionality into individual gems (e.g. the Deploy instruction)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
