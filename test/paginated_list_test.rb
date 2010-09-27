require 'helper'

class PaginatedListTest < Test::Unit::TestCase
  def setup
    @shots_results = { 
      "total"=>750,
      "shots"=>[{}, {}],
      "page"=>1, 
      "pages"=>375,
      "per_page"=>2
    }
  end

  def test_initialize_gathers_pagination_data
    list = Dribbble::PaginatedList.new(@shots_results, 'shots')

    assert_equal 375, list.pages
    assert_equal 750, list.total
    assert_equal 1, list.page
    assert_equal 2, list.per_page
  end

  def test_list_behaves_as_array
    list = Dribbble::PaginatedList.new(@shots_results, 'shots')
    assert list.is_a? Array
    assert list.respond_to?(:each)
    assert list.respond_to?(:first)
  end

  def test_initialize_collects_shots_by_default
    list = Dribbble::PaginatedList.new(@shots_results, 'shots')
    assert_equal 2, list.size
    list.each do |shot|
      assert shot.instance_of?(Dribbble::Shot), "#{shot.inspect} is not an instance of Dribbble::Shot."
    end
  end

  def test_initialize_collecting_players
    player_followers_results = {
      "players"=> [{}, {}], 
      "total"=>201,
      "page"=>1,
      "pages"=>101,
      "per_page"=>2
    } 

    list = Dribbble::PaginatedList.new(player_followers_results, 'players')
    assert_equal 2, list.size
    list.each { |p| assert p.is_a?(Dribbble::Player), "#{p.inspect} is not a Dribbble::Player" }
  end
end
