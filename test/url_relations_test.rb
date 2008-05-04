require File.dirname(__FILE__) + '/test_helper'
$:.unshift File.dirname(__FILE__) + '/../lib'
require 'mbws'
class MBUrlRelationsTest < Test::Unit::TestCase
  def test_artist
    a = MBWS::Artist.find("c0b2500e-0cef-4130-869d-732b23ed9df5",:inc => "url-rels")
    a.url_rels.each do |r|
      assert r[:url]
      assert r[:type]
    end
  end
  
  def test_relations_by_type
    a = MBWS::Artist.find("c0b2500e-0cef-4130-869d-732b23ed9df5",:inc => "url-rels")
    a.url_rels.relations_by_type("Discography").each do |r|
      assert_equal "Discography",r[:type]
    end
  end
end
