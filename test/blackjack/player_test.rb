require 'test_helper'
require 'blackjack'

class TestPlayer < Minitest::Test
  Card     = Blackjack::Card
  HandCard = Blackjack::HandCard
  Player   = Blackjack::Player

  def setup
    @player = Player.new('Otis')
  end

  def test_initialize_state
    assert_equal 'Otis', @player.name
    assert_equal :normal, @player.state
    assert_instance_of HandCard, @player.hand
  end

  def test_take_card
    hand = @player.take_card Card.new('J')

    assert_instance_of HandCard, hand
    assert_equal HandCard.new([Card.new('J')]), @player.hand
  end

  def test_take_card_with_state_change
    @player.take_card Card.new('J')
    assert_equal :normal, @player.state

    @player.take_card Card.new('A')
    assert_equal :blackjack, @player.state

    @player.take_card Card.new('K')
    @player.take_card Card.new('3')
    assert_equal :bust, @player.state
  end

  def test_hit_and_take_card_is_the_same
    hand_insert_by_take_card = @player.take_card(Card.new('J'))
    hand_insert_by_hit       = @player.take_card(Card.new('J'))

    assert hand_insert_by_take_card == hand_insert_by_hit
  end

  def test_define_state
    assert_respond_to @player, :normal?
    assert_respond_to @player, :stay?
    assert_respond_to @player, :bust?
    assert_respond_to @player, :blackjack?

    assert_respond_to @player, :be_normal
    assert_respond_to @player, :be_stay
    assert_respond_to @player, :be_bust
    assert_respond_to @player, :be_blackjack

    assert_respond_to @player, :states
  end

  def test_question_state
    @player.state = :normal
    assert @player.normal?

    @player.state = :stay
    assert @player.stay?

    @player.state = :bust
    assert @player.bust?

    @player.state = :blackjack
    assert @player.blackjack?
  end

  def test_be_state
    @player.be_normal
    assert_equal :normal, @player.state

    @player.be_stay
    assert_wqual :stay, @player.state

    @player.be_bust
    assert_equal :bust, @player.state

    @player.be_blackjack
    assert_equal :blakcjack, @player.state
  end

  def test_want_hit_or_stay
    original_hand_size = @player.hand.size

    @player.stub :should_i_hit?, true do
      @player.hit_or_stay
      assert_equal original_hand_size,  @player.hand.size
    end

    @player.stub :should_i_hit?, false do
      @player.hit_or_stay
      assert_equal original_hand_size, @player.hand.size
      assert_equal :stay, @player.state
    end
  end

  def test_over?
    refute @player.over?

    @player.state = :stay
    assert @player.over?

    @player.state = :bust
    assert @player.over?

    @player.state = :blackjack
    assert @player.over?
  end

  def test_should_i_hit?
    @player.hand.stub :points, 15 do
      assert @player.send :should_i_hit?
    end

    @player.hand.stub :points, 16 do
      refute @player.send :should_i_hit?
    end
  end
end