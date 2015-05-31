require 'test_helper'
require 'blackjack'

class TestHandCard < Minitest::Test
  Card     = Blackjack::Card
  HandCard = Blackjack::HandCard

  def setup
    @hand = HandCard.new([
      Card.new('3'),
      Card.new('2'),
      Card.new('6'),
      Card.new('2')
    ]) # 13

    @hand_with_unflipped_card = HandCard.new([
      Card.new('5', false),
      Card.new('3'),
      Card.new('2')
    ]) # 10

    @hand_blackjack = HandCard.new([
      Card.new('2'),
      Card.new('4'),
      Card.new('5'),
      Card.new('J')
    ]) # 21

    @hand_blackjack_2 = HandCard.new([
      Card.new('A'),
      Card.new('10')
    ]) # 21

    @hand_bust = HandCard.new([
      Card.new('J'),
      Card.new('K'),
      Card.new('4')
    ]) # 24

    @hand_with_ace = HandCard.new([
      Card.new('A'),
      Card.new('4')
    ]) # 15

    @hand_with_two_ace = HandCard.new([
      Card.new('A'),
      Card.new('A'),
      Card.new('4')
    ]) # 16

    @hand_with_multiple_ace = HandCard.new([
      Card.new('A'),
      Card.new('A'),
      Card.new('A'),
      Card.new('J'),
      Card.new('4')
    ]) # 17

    @hand_with_multiple_ace_2 = HandCard.new([
      Card.new('A'),
      Card.new('A'),
      Card.new('A'),
      Card.new('3'),
      Card.new('2')
    ]) # 18
  end

  def test_min_points
    assert_equal 13, (@hand.send :min_points)
    assert_equal  5, (@hand_with_unflipped_card.send :min_points)
    assert_equal 10, (@hand_with_unflipped_card.send :min_points, false)
  end

  def test_points
    assert_equal 13, @hand.points
    assert_equal 21, @hand_blackjack.points
    assert_equal 21, @hand_blackjack_2.points
    assert_equal 24, @hand_bust.points
    assert_equal 15, @hand_with_ace.points
    assert_equal 16, @hand_with_two_ace.points
    assert_equal 17, @hand_with_multiple_ace.points
    assert_equal 18, @hand_with_multiple_ace_2.points
    assert_equal  5, @hand_with_unflipped_card.points
    assert_equal 10, @hand_with_unflipped_card.points(false)
  end

  def test_select
    @selected_result = @hand.select{ |card| card != Card.new('2') }

    refute @selected_result.include? Card.new('2')
    assert_instance_of HandCard, @selected_result
  end

  def test_ace_count
    assert_equal 1, @hand_with_ace.send(:ace_counts)
    assert_equal 3, @hand_with_multiple_ace.send(:ace_counts)

    hand = HandCard.new([
      Card.new('A'),
      Card.new('A', false)
    ])
    assert_equal 1, hand.send(:ace_counts)
    assert_equal 2, hand.send(:ace_counts, false)
  end

  def test_bust?
    bust_with_unflipped_card = HandCard.new([
      Card.new('J', false),
      Card.new('10'),
      Card.new('5')
    ])

    refute @hand.bust?
    assert @hand_bust.bust?
    refute bust_with_unflipped_card.bust?
  end

  def test_blackjack?
    blackjack_with_unflipped_card = HandCard.new([
      Card.new('5', false),
      Card.new('A'),
      Card.new('5')
    ])

    assert @hand_blackjack.blackjack?
    assert blackjack_with_unflipped_card.blackjack?
  end

  def test_flip_all
    @hand.flip_all
    all_cards_flipped_state =
      @hand.inject(true){ |state, card| state && card.flipped? }

    assert all_cards_flipped_state
  end
end