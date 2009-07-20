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
PROJ.readme_file = 'README.rdoc'

PROJ.spec.opts << '--color'

PROJ.rdoc.opts = ["--inline-source", "-o rdoc", "--format=html", "-T hanna"]



require 'fileutils'
def this_dir; File.join(File.dirname(__FILE__)); end
def doc_dir; File.join(this_dir, 'rdoc'); end
def tab_a_doc_dir; File.join(this_dir, '../tab-a/public/cosell/rdoc'); end
task :myclobber => [:clobber] do
  mydir = File.join(File.dirname(__FILE__))
  sh "rm -rf #{File.join(mydir, 'pkg')}"
  sh "rm -rf #{File.join(mydir, 'doc')}"
  sh "rm -rf #{File.join(mydir, 'rdoc')}"
  sh "rm -rf #{File.join(mydir, 'ext/*.log')}"
  sh "rm -rf #{File.join(mydir, 'ext/*.o')}"
  sh "rm -rf #{File.join(mydir, 'ext/*.so')}"
  sh "rm -rf #{File.join(mydir, 'ext/Makefile')}"
  sh "rm -rf #{File.join(mydir, 'ext/Makefile')}"
end
task :mypackage => [:myclobber] do
  Rake::Task['gem:package'].invoke
end
task :mydoc => [:myclobber] do
  FileUtils.rm_f doc_dir()
  sh "cd #{this_dir()} && rdoc -o rdoc --inline-source --format=html -T hanna README.rdoc lib/**/*.rb" 
end
task :taba => [:mydoc] do
  this_dir = File.join(File.dirname(__FILE__))
  FileUtils.rm_rf tab_a_doc_dir
  FileUtils.cp_r doc_dir, tab_a_doc_dir
end

task :mygemspec => [:myclobber] do
  Rake::Task['gem:spec'].invoke
end
