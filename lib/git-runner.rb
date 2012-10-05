require "git-runner/version"
require "git-runner/base"
require "git-runner/command"
require "git-runner/configuration"
require "git-runner/branch"
require "git-runner/instruction"
require "git-runner/text"

module GitRunner
  DEFAULT_CONFIGURATION = {
    :git_executable     => '/usr/bin/env git',
    :instruction_file   => 'config/deploy.rb',
    :instruction_prefix => '# GitRunner:',
    :tmp_directory      => '/tmp/git-runner',
    :rvm_ruby_version   => '1.9.3'
  }
end
