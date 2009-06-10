require 'rdiscount'
require 'digest/md5'
require 'action_view'

module ActionView
  module Helpers
    module Markdown
      include TagHelper
      include TextHelper
      include CaptureHelper
      include UrlHelper

      def flavoured_markdown(str)
        str = RDiscount.new(str, :smart, :filter_styles, :filter_html).to_html

        # Extract pre blocks
        str = extract_markup(str, :pre)

        # Undo markdown's html encoding of breaks
        str.gsub!(%r{&lt;br\s*\/?>}m, "<br/>")

        # Undo markdowns' html encoding of hyperlinks, except for those that
        # contain an on* attribute which may contain javascript code.
        str.gsub!(%r{&lt;a\s(.*?)&lt;/a>}m) do
          match = $1
          match =~ %r{\son\w}m ? "&lt;a #{match}&lt;/a>" : "<a #{match}</a>"
        end

        # Extract hyperlink html code
        str = extract_markup(str, :a)

        # Auto hyperlink urls and email addresses
        str = auto_link(str, :all) do |txt|
          txt.size < 55 ? txt : truncate(txt, :length => 50, :omission => "...")
        end

        # Extract the new hyperlinks
        str = extract_markup(str, :a)

        # preserve whitespace for haml
        #str = str.chomp("\n").gsub(/\n/, '&#x000A;').gsub(/\r/, '')

        # Prevent an orphan for P and LI tags
        str.gsub!(%r{<(p|li)\b[^>]*>(.*?)</\1>}m) do |match|
          last_space_index = match.rindex(' ')
          if last_space_index
            match = match.slice(0, last_space_index) + "&#160;" + match.slice(last_space_index + 1, match.length - last_space_index - 1)
          end
          match
        end

        # Add css class "last" to last P tag if it's the last element
        str.sub!(%r{<p>(.*?)</p>\Z}, "<p class=\"last\">\\1</p>")

        # Turn 3 consecutive dot characters into an ellipsis character
        str = hellip(str)

        # Put back in the previously extracted markup
        str = add_extracted_markup(str)
        
        str
      end
      alias_method :flavored_markdown, :flavoured_markdown

      private
        # Parts from Github Flavored Markdown
        # http://github.github.com/github-flavored-markdown/
        def extract_markup(str, mode = :a)
          regexp = mode == :pre ? %r{<pre>.*?</pre>}m : %r{<a\s(.*?)>(.*?)</a>}m
          @extractions ||= {}
          str.gsub(regexp) do |match|
            match = "<a #{$1}>#{hellip($2)}</a>" if mode == :a
            md5 = Digest::MD5.hexdigest(match)
            @extractions[md5] = match
            "{extraction-#{md5}}"
          end
        end

        # Insert back the extracted markup
        def add_extracted_markup(str)
          str.gsub(/\{extraction-([0-9a-f]{32})\}/) do
            @extractions[$1]
          end
        end
        
        def hellip(str)
          str.gsub(%r{\b\.\.\.}m, "&hellip;")
        end
    end
  end
end