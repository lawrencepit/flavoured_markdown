$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'active_support'
require 'action_view'

require 'flavoured_markdown'
include ActionView::Helpers::Markdown
