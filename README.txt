cosell
    by Steven Swerling
    http://tab-a.slot-z.net

== DESCRIPTION:

Cosell is an implementation of the Announcements event event notification
framework, originally introduced in VisualWorks Smalltalk 7.4 as a
replacement for the 'triggerEvent' style of event notification.  Instead of
triggering events identified by symbols, the events are first class
objects.  For rational, please see the original blog posting by Vassili
Bykov (refs below).

Pedigree

  This implementation is a based on Lukas Renggli's tweak of Colin Putney's
  Squeak implementation of Vassili Bykov's Announcements framework for
  VisualWorks Smalltalk.  (Specifically Announcements-lr.13.mcz was used as
  a reference.)
  
  Liberties where taken during the port. In particular, the Announcer class
  in the Smalltalk version is implemented here a ruby module which can be
  mixed into any ruby object. 

  The concurrent announcements queue is original to this version.


The Name 'Cosell'

  I chose the name 'Cosell' because 

    a) Howard Cosell is famous for his event notification prowess 
    b) Googling for 'Ruby Announcements', 'Ruby Event Announcements', etc.,
      produced scads of results about ruby meetups, conferences, and the
      like. So I went with something a bit cryptic but hopefully a little
      more searchable. 

See:

  Original blog posting describing Announcments by Vassili Bykov: 
    http://www.cincomsmalltalk.com/userblogs/vbykov/blogView?entry=3310034894

  More info on the Announcements Framework:
    http://wiki.squeak.org/squeak/5734

== FEATURES/PROBLEMS:

* None known

== SYNOPSIS:

  FIXME (code sample of usage)

== REQUIREMENTS:

* ruby, rubygems

== INSTALL:

* gem install cosell TODO(ref to github)

== LICENSE:

(The MIT License)

Copyright (c) 2008 FIXME (different license?)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
