Flavoured Markdown
==================

*Websafe Markdown with some extra flavour.*

Markdown is a way to use an easy-to-read, easy-to-write plain text format that is turned into valid XHTML or HTML. See the <a href='http://daringfireball.net/projects/markdown/syntax'>Markdown Syntax</a> at Daring Fireball.

It's important to realize that Markdown by default accepts any HTML code as its source. If you use Markdown as a way for your users to enter text easily via a web interface, providing easy markup capabilities, they could potentially enter harmful code (javascripts, styles, etc.). Flavoured Markdown escapes all HTML code by default.

The extra flavors provided by Flavoured Markdown:

* Do not allow javascript, styles and HTML codes
* Except for A tags that have no on* attributes
* And except for BR tags
* HTML entities are alllowed (e.g.: &copy;, &amp;, etc.)
* URLS and emails are automatically hyperlinked. Long hyperlinks are automatically limited to 55 characters.
* Three consecutive dots are replaced by an ellipsis character
* Fancy pants mode
* Prevents paragraphs and list items from having an <a href='http://en.wikipedia.org/wiki/Widows_and_orphans'>orphan</a>.


Usage
-----

    flavoured_markdown("# Hello World #\n----\n* Item A\n* Item B")


Requirements
------------

This gem/plugin depends on the rdiscount and actionpack gems. To install, run:

   $ sudo gem install rdiscount
   $ sudo gem install actionpack


Installation
------------

#### As a Gem

Use this if you prefer to use versioned releases of Flavoured Markdown.
Specify the gem dependency in your config/environment.rb file:

    Rails::Initializer.run do |config|
      config.gem "lawrencepit-flavoured_markdown", :lib => "flavoured_markdown", :source => "http://gems.github.com"
    end

Then:

    $ rake gems:install
    $ rake gems:unpack

#### As a Rails Plugin

Use this if you prefer to use the edge version of Flavoured Markdown within a Rails application:

    $ script/plugin install git://github.com/lawrencepit/flavoured_markdown.git


Options
-------

No options. Hack it.


Credits
-------

Written by [Lawrence Pit](http://lawrencepit.com).

Thanks to GitHub for their amazing services!
GitHub has it's own <a href='http://github.github.com/github-flavored-markdown/'>GitHub Flavored Markdown</a>.
You can have yours too.


----
Copyright (c) 2009 Lawrence Pit, released under the MIT license
