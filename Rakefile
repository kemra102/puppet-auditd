require 'metadata-json-lint/rake_task'
require 'puppet-lint/tasks/puppet-lint'
require 'rubocop/rake_task'

PuppetLint.configuration.send('disable_140chars')
PuppetLint.configuration.send('disable_autoloader_layout')
PuppetLint.configuration.send('disable_variable_scope')
PuppetLint.configuration.ignore_paths = ['spec/**/*.pp', 'pkg/**/*.pp']

RuboCop::RakeTask.new

desc 'Validate manifests, templates, and ruby files'
task :validate do
  Dir['manifests/**/*.pp'].each do |manifest|
    sh "puppet parser validate --noop #{manifest}"
  end
  Dir['templates/**/*.epp'].each do |template|
    sh "puppet epp validate --noop #{template}"
  end
end

task default: [:validate, :metadata_lint, :lint, :rubocop]
