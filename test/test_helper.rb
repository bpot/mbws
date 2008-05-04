require 'test/unit'
$:.unshift File.dirname(__FILE__) + '/../lib'
require 'mbws'

class Test::Unit::TestCase
  include MBWS
end
