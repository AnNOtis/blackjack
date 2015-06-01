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
      Card.new(@cards_in_the_box.pop, false)
    end

    def ask_hit_or_stay_until_over(player)
      until (player.over?) do
        say "ask => #{player.name} | #{player.hand.display} : Hit or Stay? (h/s)"

        if player.hit_or_stay
          deal(player)
        end
      end
    end

    def deal(player)
      current_next_card = next_card
      player.take_card(current_next_card)

      say "#{player.name} got #{current_next_card.name}"
    end

    private

    def say(msg)
      puts "Dealer(#{name}): #{msg}"
    end
  end

end