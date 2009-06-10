require File.dirname(__FILE__) + '/spec_helper'

describe "Flavoured Markdown" do
  it "should give yanks some love" do
    flavored_markdown("Foo").should == flavoured_markdown("Foo")
  end
  
  it "should markdown" do
    flavoured_markdown("Foo\n\nBar").should == "<p>Foo</p>\n\n<p class=\"last\">Bar</p>\n"
  end

  it "should add css class 'last' to the last paragraph (to help IE which doesn't support the css selector :last)" do
    flavoured_markdown("Foo").should == "<p class=\"last\">Foo</p>\n"
  end

  it "should not add css class 'last' to the last paragraph if other items follow" do
    flavoured_markdown("Foo\n\n1. NumberedList").should == "<p>Foo</p>\n\n<ol>\n<li>NumberedList</li>\n</ol>\n\n"
  end

  it "should wear smarty pants" do
    flavoured_markdown("This 'is' awesome").should =~ %r{&lsquo;is&rsquo;}
  end

  it "should not allow javascript" do
    flavoured_markdown("<script>alert('hello');</script>").should =~ %r{&lt;script>.*?&lt;/script>}
  end

  it "should not allow styles" do
    flavoured_markdown("<styles>body {display:'none';}</styles>").should =~ %r{&lt;styles>.*?&lt;/styles>}
  end

  it "should not allow HTML markup" do
    flavoured_markdown("<b>Some bold text</b>").should =~ %r{&lt;b>.*?&lt;/b>}
  end

  it "should allow explicit breaks" do
    flavoured_markdown("Hello<br>World").should =~ %r{Hello<br/>World}
    flavoured_markdown("Hello<br/>World").should =~ %r{Hello<br/>World}
    flavoured_markdown("Hello<br />World").should =~ %r{Hello<br/>World}
    flavoured_markdown("Hello<br  />World").should =~ %r{Hello<br/>World}
  end

  it "should allow markdowns syntax for hyperlinking" do
    flavoured_markdown("Hello [an example](http://example.com/ 'Title').").should =~ %r{<a href=\"http://example.com/\" title=\"Title\">an example</a>}
  end

  it "should allow HTML syntax for hyperlinking" do
    flavoured_markdown("Hello <a href='http://example.com'>An example</a>.").should =~ %r{<a href='http://example.com'>An example</a>}
  end

  it "should not allow HTML syntax for hyperlinking when it contains an on* attribute" do
    flavoured_markdown("Hello <a href='http://example.com' onclick='alert(\"hello!\");'>An example</a>.").should =~ %r{&lt;a\s.*?&lt;/a>}
  end

  it "should auto hyperlink URLs" do
    flavoured_markdown("Hello http://example.com.").should =~ %r{<a href=\"http://example.com\">http://example.com</a>}
  end

  it "should auto hyperlink URLs with a limit of 55 characters" do
    flavoured_markdown("Hello http://example.com/some/very/long/path?param1=foo&param2=bar.").should == "<p class=\"last\">Hello&#160;<a href=\"http://example.com/some/very/long/path?param1=foo&amp;param2=bar\">http://example.com/some/very/long/path?param1=f&hellip;</a>.</p>\n"
  end

  it "should auto hyperlink email addresses" do
    flavoured_markdown("Hello joe@example.com.").should =~ %r{<a href=\"mailto:joe@example.com\">joe@example.com</a>}
  end

  it "should turn three consecutive dots into an ellipsis character" do
    flavoured_markdown("Continue...").should =~ %r{Continue&hellip;}
  end

  it "should not have orpans" do
    flavoured_markdown("Hello Awesome World\n\n\Hallo Wonderbaarlijke Wereld\n\n<a href='http://example.com'>Example</a>\n\n* Item A and B\n* Item C and D").should == "<p>Hello Awesome&#160;World</p>\n\n<p>Hallo Wonderbaarlijke&#160;Wereld</p>\n\n<p><a href='http://example.com'>Example</a></p>\n\n<ul>\n<li>Item A and&#160;B</li>\n<li>Item C and&#160;D</li>\n</ul>\n\n"
  end

end

