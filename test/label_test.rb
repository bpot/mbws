require File.dirname(__FILE__) + '/test_helper'
$:.unshift File.dirname(__FILE__) + '/../lib'
require 'mbws'
class MBLabelTest < Test::Unit::TestCase
  
  def test_find_by_id
    l = MBWS::Label.find("5073df0c-0661-4277-820e-20ae13afba9c")
    assert_equal "5073df0c-0661-4277-820e-20ae13afba9c",l.mid
    assert_equal "Plan-it-X",l.name
    assert_equal "Production",l.type
  end

  def test_begin_label_code
    l = MBWS::Label.find("022fe361-596c-43a0-8e22-bad712bb9548")
    assert_equal  "542",l.label_code
    assert_equal "1972",l.begin
  end
  
  def test_find_by_query
    ls = MBWS::Label.find(:name => "Plan-it-X")
    assert_equal "5073df0c-0661-4277-820e-20ae13afba9c",ls[0].mid
  end

  def test_find_by_id_with_include
    l = MBWS::Label.find("5073df0c-0661-4277-820e-20ae13afba9c",
        :inc => %W(aliases artist-rels label-rels release-rels track-rels url-rels))   
    assert l.aliases
  end

  def test_relations_after_find
  end
end
