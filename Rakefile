require 'bundler/gem_tasks'

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

# Measure coverage
require 'yardstick/rake/measurement'
Yardstick::Rake::Measurement.new(:yardstick_measure) do |measurement|
  measurement.output = 'doc/yardstick-report.txt'
end


# Verify coverage
require 'yardstick/rake/verify'
Yardstick::Rake::Verify.new do |verify|
  verify.threshold = 100
end
