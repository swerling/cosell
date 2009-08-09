# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{cosell}
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Steven Swerling"]
  s.date = %q{2009-08-09}
  s.description = %q{Cosell is a minimal implementation of the 'Announcements' observer
framework, originally introduced in VisualWorks Smalltalk as a
replacement for 'triggerEvent' style of event notification.  Instead of
triggering events identified by symbols, the events are first class
objects.  For rationale, please see the original blog posting by Vassili
Bykov (refs below).

*Lineage*

This implementation is loosely based on Lukas Renggli's tweak of Colin Putney's
Squeak implementation of Vassili Bykov's Announcements framework for
VisualWorks Smalltalk.  (Specifically Announcements-lr.13.mcz was used as
a reference.)

Liberties where taken during the port. In particular, the Announcer class
in the Smalltalk version is implemented here as a ruby module which can be
mixed into any object. Also, in this implementation any object (or class)
can serve as an announcement, so no Announcement class is implemented. 

The ability to queue announcements in the background is built into cosell.

<b>The Name 'Cosell'</b>

I chose the name 'Cosell' because 

a. Howard Cosell is an iconic event announcer
b. Googling for 'Ruby Announcements', 'Ruby Event Announcements', etc., produced scads of results about ruby meetups, conferences, and the like. So I went with something a bit cryptic but hopefully a little more searchable. 

*See*

* {Original blog posting describing Announcments by Vassili Bykov}[http://www.cincomsmalltalk.com/userblogs/vbykov/blogView?entry=3310034894]
* {More info on the Announcements Framework}[http://wiki.squeak.org/squeak/5734]}
  s.email = %q{sswerling@yahoo.com}
  s.extra_rdoc_files = ["History.txt", "README.rdoc"]
  s.files = [".gitignore", "History.txt", "README.rdoc", "Rakefile", "cosell.gemspec", "example/basic_example.rb", "example/cat_whisperer.rb", "lib/cosell.rb", "lib/cosell/announcer.rb", "lib/cosell/monkey.rb", "spec/cosell_spec.rb", "spec/spec_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/swerling/TODO}
  s.rdoc_options = ["--inline-source", "-o rdoc", "--format=html", "-T hanna", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{cosell}
  s.rubygems_version = %q{1.3.2}
  s.summary = %q{Cosell is a minimal implementation of the 'Announcements' observer framework, originally introduced in VisualWorks Smalltalk as a replacement for 'triggerEvent' style of event notification}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bones>, [">= 2.5.1"])
    else
      s.add_dependency(%q<bones>, [">= 2.5.1"])
    end
  else
    s.add_dependency(%q<bones>, [">= 2.5.1"])
  end
end
