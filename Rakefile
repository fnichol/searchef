require "bundler/gem_tasks"
require 'cane/rake_task'
require 'rake/testtask'
require 'tailor/rake_task'

Rake::TestTask.new do |t|
  t.libs.push "lib"
  t.test_files = FileList['spec/**/*_spec.rb']
  t.verbose = true
end

desc "Run cane to check quality metrics"
Cane::RakeTask.new do |cane|
  cane.canefile = './.cane'
end

Tailor::RakeTask.new

desc "Display LOC stats"
task :stats do
  puts "\n## Production Code Stats"
  sh "countloc -r lib"
  puts "\n## Test Code Stats"
  sh "countloc -r spec"
end

task :default => [:test, :cane, :tailor, :stats]
