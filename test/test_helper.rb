require 'rubygems'
require 'test/unit'
require 'redgreen' if RUBY_VERSION < '1.9'

require 'action_controller'
require 'action_view'
require 'action_view/template'
require 'action_view/test_case'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'bhm-google-maps'

Dir["#{File.dirname(__FILE__)}/support/*.rb"].each { |f| require f }

class ActionView::TestCase
  include MiscHelpers
  
  tests BHM::GoogleMaps::Helper
  
end
