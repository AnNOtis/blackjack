require 'test_helper'
require 'blackjack'

class TestDealer < MiniTest::Test
  Card = Blackjack::Card
  Dealer = Blackjack::Dealer
  Player = Blackjack::Player

  def setup
    @dealer = Dealer.new('DDDDDealer')
    @player = Player.new('player1')
  end

  def test_next_card
    last_card = Card.new(@dealer.cards_in_the_box.last)

    assert_equal last_card, @dealer.next_card
    refute @dealer.next_card.flipped?
  end

  def test_deal
    @dealer.deal(@player)

    assert_equal 1, @player.hand.size
  end
end