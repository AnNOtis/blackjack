require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = 'test/**/*_test.rb'
  t.pattern = 'test/*_test.rb'
  t.verbose = true
  t.libs << %w(test .)
end

task :default => :test