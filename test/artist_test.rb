require File.dirname(__FILE__) + '/test_helper'
$:.unshift File.dirname(__FILE__) + '/../lib'
require 'mbws'
class MBArtistTest < Test::Unit::TestCase
  
  def test_find_by_id
    a = MBWS::Artist.find("c0b2500e-0cef-4130-869d-732b23ed9df5")
    assert_equal a.mid,"c0b2500e-0cef-4130-869d-732b23ed9df5"
    assert_equal "Tori Amos",a.name
    assert_equal "Amos, Tori",a.sort_name
    assert_equal "Person",a.type
    assert_equal "1963-08-22",a.begin
    assert_equal nil,a.end
  end
  
  def test_find_by_id_with_includes
    a = MBWS::Artist.find("c0b2500e-0cef-4130-869d-732b23ed9df5", 
          :inc => %W(url-rels track-rels release-rels artist-rels aliases),
          :limit => 1)

    assert_equal a.mid,"c0b2500e-0cef-4130-869d-732b23ed9df5"
    assert a.instance_variable_get("@url_rels")
    assert a.instance_variable_get("@track_rels")
    assert a.instance_variable_get("@artist_rels")
    assert a.instance_variable_get("@release_rels")
    assert a.instance_variable_get("@aliases")
  end

  def test_find_by_name
    a = MBWS::Artist.find(:name => "Jaw")
    a.each do |artist|
      assert_match(/Jaw/i,artist.name)
    end
  end
  
  def test_disambiguation
    a = MBWS::Artist.find("74a627ea-539d-4f27-b6c2-d85de82c759c")
    assert_not_equal nil,a.disambiguation
  end

  def test_url_relations
    a = MBWS::Artist.find("c0b2500e-0cef-4130-869d-732b23ed9df5")
    @url_relations = a.url_rels 
    assert_not_nil @url_relations
    assert_not_equal 0,@url_relations.size
  end

  def test_artist_relations
    a = MBWS::Artist.find("c0b2500e-0cef-4130-869d-732b23ed9df5")
    @artist_relations = a.artist_rels 
    assert_not_nil @artist_relations
    assert_not_equal 0,@artist_relations.size
  end

  def test_release_relations
    a = MBWS::Artist.find("c0b2500e-0cef-4130-869d-732b23ed9df5")
    @release_relations = a.release_rels 
    assert_not_nil @release_relations
    assert_not_equal 0,@release_relations.size
  end

  def test_track_relations
    a = MBWS::Artist.find("c0b2500e-0cef-4130-869d-732b23ed9df5")
    @track_relations = a.track_rels 
    assert_not_nil @track_relations
    assert_not_equal 0,@track_relations.size
  end
  
  def test_aliases
    a = MBWS::Artist.find("c0b2500e-0cef-4130-869d-732b23ed9df5")
    @aliases = a.aliases
    assert_not_nil @aliases
    assert_not_equal 0,@aliases.size
  end
  
  def test_releases
    a = MBWS::Artist.find("c0b2500e-0cef-4130-869d-732b23ed9df5")
    releases = a.releases()
    releases.each do |r|
      #assert_equal "Tori Amos",r.artist_name
    end
  end

  def test_sa_releases
    a = MBWS::Artist.find("c0b2500e-0cef-4130-869d-732b23ed9df5")
    releases = a.sa_releases(:status => :Official) 
    releases.each do |r|
      assert_equal "Official",r.status
    end
  end
  
  def test_va_releases
    a = MBWS::Artist.find("c0b2500e-0cef-4130-869d-732b23ed9df5")
    releases = a.va_releases(:status => :Official) 
    releases.each do |r|
      assert_equal "Official",r.status
    end
  end
  def test_all_sa_releases
    a = MBWS::Artist.find("c0b2500e-0cef-4130-869d-732b23ed9df5")
    releases = a.all_sa_releases
  end

  def test_invalid_mbid
    invalid_mids = ["c0b2500e-0cef-4130-869d",
        "c0b2500e-0cef-4130-869d-732b23ed9df5-fake"]

    invalid_mids.each do |mid|
      assert_raises(InvalidUUID) {
        MBWS::Artist.find(mid)
      }
   end
  end
end
