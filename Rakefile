require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
end

task :default => :test

task :server do
  system "ruby -I lib lib/ruby_2048/server.rb"
end

task :shotgun do
  system "shotgun -I lib lib/ruby_2048/server.rb"
end

task :production do
  system "bundle exec ruby lib/ruby_2048/server.rb -p $PORT"
end
