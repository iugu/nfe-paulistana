# frozen_string_literal: true

require 'bundler/gem_tasks'

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'lib/nfe_paulistana'
  t.test_files = FileList['test/lib/nfe_paulistana/*_test.rb']
  t.verbose = true
end

task default: :spec
