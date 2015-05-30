module Blackjack

  class Dealer < Player
    attr_reader :cards_in_the_box

    def initialize(name = 'Dealer', deck_number = 1)
      @cards_in_the_box = Card.all_names * deck_number
      super(name)
    end

    def shuffle_cards
      @cards_in_the_box.shuffle!
    end

    def next_card
      Card.new(@cards_in_the_box.pop)
    end

    def ask_hit_or_stay_until_over(player)
      until (player.over?) do
        say "ask => #{player.name} | #{player.hand.display} : Hit or Stay? (h/s)"

        if player.hit_or_stay?
          deal(player)
        end

        if player.state_bust?
          player.to_bust
        end
      end
    end

    def deal(player)
      if player.hand.size == 0
        next_c = next_card
        player.take_card(next_c)
        say "#{player.name} got #{next_c.name}"
      else
        next_c = next_card.flip
        player.take_card(next_c)
        say "#{player.name} got #{next_c.name}"
      end
    end

    private

    def say(msg)
      puts "Dealer(#{name}): #{msg}"
    end
  end

end