# -*- encoding: utf-8 -*-
require File.expand_path('../lib/git-runner/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["James Brooks"]
  gem.email         = ["james@jamesbrooks.net"]
  gem.summary       = "Ruby framework to run tasks after code has been pushed to a Git repository."
  gem.description   = "GitRunner is a ruby framework to implement and run tasks after code has been pushed to a Git repository. It works by invoking `git-runner` through `hooks/post-update` in your remote Git repository."
  gem.homepage      = "https://github.com/JamesBrooks/git-runner"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.name          = "git-runner"
  gem.require_paths = ["lib"]
  gem.version       = GitRunner::VERSION

  gem.add_dependency 'session'
end
