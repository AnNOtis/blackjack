require 'test_helper'
require 'blackjack'

class TestRealPlayer < Minitest::Test
  Card       = Blackjack::Card
  HandCard   = Blackjack::HandCard
  Player     = Blackjack::Player
  RealPlayer = Blackjack::RealPlayer

  def setup
    @player = RealPlayer.new('Otis')
  end

  def test_should_i_hit?
    answer = @player.send :should_i_hit?
    out = capture_io do
      puts "h"
    end

    assert (answer == true)

    answer = @player.send :should_i_hit?
    out = capture_io do
      puts "s"
    end

    assert (answer == false)
  end
end