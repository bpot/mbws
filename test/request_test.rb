require File.dirname(__FILE__) + '/test_helper'
$:.unshift File.dirname(__FILE__) + '/../lib'
require 'mbws'
class MBRequestTest < Test::Unit::TestCase
  def test_limiter
    assert_nothing_raised do
      30.times do
        Artist.find("c0b2500e-0cef-4130-869d-732b23ed9df5")
      end
    end
  end
end
