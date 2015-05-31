require 'test_helper'
require 'blackjack'

class TestCard < MiniTest::Test

  def setup
    @card = Blackjack::Card.new('J')
    @card_ace = Blackjack::Card.new('A')
  end

  def test_all_names
    expect_names = %w(A 2 3 4 5 6 7 8 9 10 J Q K)

    assert_equal expect_names, Blackjack::Card.all_names
  end

  def test_default_card_is_flipped
    assert @card.flipped
    assert @card.flipped?
  end

  def test_flip
    refute @card.flip.flipped?
  end

  def test_flip_should_return_self
    assert_same @card.flip, @card
  end

  def test_point
    assert_equal 1, Blackjack::Card.new('A').point
    assert_equal 10, Blackjack::Card.new('J').point
  end

  def test_equal_sign
    assert @card_ace == Blackjack::Card.new('A')
    refute @card_ace == Blackjack::Card.new('J')
  end

  def test_to_s
    assert_equal 'A', @card_ace.to_s
  end

end