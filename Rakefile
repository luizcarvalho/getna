require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the getna plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the getna plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  $stdout.print('Gerando Documentação GEtna.../n/n')
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Getna'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
    rdoc.rdoc_files.include('generators/getna/getna_generator.rb')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
