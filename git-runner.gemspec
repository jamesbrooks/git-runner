# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'git-runner/version'

Gem::Specification.new do |gem|
  gem.name          = "git-runner"
  gem.version       = GitRunner::VERSION
  gem.authors       = ["James Brooks"]
  gem.email         = ["james@jamesbrooks.net"]
  gem.summary       = "Ruby framework to run tasks after code has been pushed to a Git repository."
  gem.description   = "GitRunner is a ruby framework to implement and run tasks after code has been pushed to a Git repository. It works by invoking `git-runner` through `hooks/post-update` in your remote Git repository."
  gem.homepage      = "https://github.com/JamesBrooks/git-runner"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.require_paths = ["lib"]

  gem.add_dependency 'session'
end
