# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rdoc/task"

RSpec::Core::RakeTask.new(:spec)

require "rubocop/rake_task"

RuboCop::RakeTask.new

task default: %i[spec rubocop]

RDoc::Task.new :documentation do |rdoc|
  rdoc.rdoc_files.include("lib/**/*.rb")
  rdoc.options << "--all"
end
