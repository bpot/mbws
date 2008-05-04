require File.dirname(__FILE__) + '/test_helper'
$:.unshift File.dirname(__FILE__) + '/../lib'
require 'mbws'
class MBReleaseTest < Test::Unit::TestCase
  
  def test_find_by_id
    t = MBWS::Track.find("f797c9de-fa13-46b4-8032-4e7dcb4a2e29")
    assert_equal "f797c9de-fa13-46b4-8032-4e7dcb4a2e29",t.mid
  end
  
  def test_includes
    t = MBWS::Track.find("f797c9de-fa13-46b4-8032-4e7dcb4a2e29", 
         :inc => %W(releases artist puids artist-rels label-rels release-rels track-rels url-rels))
    assert_equal "f797c9de-fa13-46b4-8032-4e7dcb4a2e29",t.mid
    assert t.instance_variable_get("@release")
    assert t.instance_variable_get("@artist")
    assert t.instance_variable_get("@puids")
    assert_not_equal 0,t.puids.size
  end

  def test_release
    t = MBWS::Track.find("f797c9de-fa13-46b4-8032-4e7dcb4a2e29")
    assert t.release
    assert t.release.asin
  end
end
