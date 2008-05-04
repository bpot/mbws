require File.dirname(__FILE__) + '/test_helper'
$:.unshift File.dirname(__FILE__) + '/../lib'
require 'mbws'
class MBReleaseTest < Test::Unit::TestCase
  
  def test_find_by_id
    a = MBWS::Release.find("02232360-337e-4a3f-ad20-6cdd4c34288c")
    assert_equal "02232360-337e-4a3f-ad20-6cdd4c34288c",a.mid
    assert_equal "Album",a.type
    assert_equal "Official",a.status
    assert a.asin
  end
  
  def test_find_by_id_with_includes
    a = MBWS::Release.find("02232360-337e-4a3f-ad20-6cdd4c34288c",
          :inc => %W(artist discs counts release-events tracks artist-rels))
    assert_equal "02232360-337e-4a3f-ad20-6cdd4c34288c",a.mid
    # Artist
    assert_equal "Tori Amos",a.artist.name
    assert_equal "c0b2500e-0cef-4130-869d-732b23ed9df5",a.artist.mid
    # Counts
    # TODO
    # Release Events
    assert a.release_events.size > 2
    assert a.release_events[0]["date"]
    assert a.release_events[0]["country"]
  end

  def test_find_by_title
    a = MBWS::Release.find(:title => "Jaw")
    a.each do |artist|
      assert_match(/Jaw/i,artist.title)
    end
  end

  def test_find_by_discid
    a = MBWS::Release.find(:discid => "ipi2T32n0nneDSAYLV85Q9JZqvU-")
    assert_equal a[0].mid, "56db4963-266b-4c39-8515-57ee7a11f0d1"
  end

  def test_by_artist
    a = MBWS::Release.find(:artistid => "c0b2500e-0cef-4130-869d-732b23ed9df5")
    a.each do |album|
      assert album.status
    end
  end

  def test_discs
    a = MBWS::Release.find("02232360-337e-4a3f-ad20-6cdd4c34288c")
    @discs = a.discs
    assert_not_nil @discs
    assert_not_equal 0,@discs.size
  end

end
