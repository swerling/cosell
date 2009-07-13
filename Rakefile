# Look in the tasks/setup.rb file for the various options that can be
# configured in this Rakefile. The .rake files in the tasks directory
# are where the options are used.

begin
  require 'bones'
  Bones.setup
rescue LoadError
  begin
    load 'tasks/setup.rb'
  rescue LoadError
    raise RuntimeError, '### please install the "bones" gem ###'
  end
end

ensure_in_path 'lib'
require 'cosell'

task :default => 'spec:run'

PROJ.name = 'cosell'
PROJ.authors = 'Steven Swerling'
PROJ.email = 'sswerling@yahoo.com'
PROJ.url = 'http://github.com/swerling/TODO'
PROJ.version = Cosell::VERSION
PROJ.rubyforge.name = 'cosell'

PROJ.spec.opts << '--color'

PROJ.rdoc.opts = ["--inline-source"]

namespace :my do
  namespace :gem do
    task :package => [:clobber] do
      sh "rm -rf #{File.join(File.dirname(__FILE__), 'pkg')}"
      sh "rm -rf #{File.join(File.dirname(__FILE__), 'doc')}"
      Rake::Task['gem:package'].invoke
    end
  end
end

