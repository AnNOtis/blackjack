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
    STDIN.stub :gets, 'h' do
      answer = @player.send :should_i_hit?
      assert (answer == true)
    end

    STDIN.stub :gets, 's' do
      answer = @player.send :should_i_hit?
      assert (answer == false)
    end
  end
end