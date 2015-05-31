module Blackjack

  class Player
    attr_reader :name, :hand
    attr_accessor :state

    def self.define_states(*states)
      states.each do |state|
        define_method("be_#{state}") do
          @state = state.to_sym
        end

        define_method("#{state}?") do
          @state == state.to_sym
        end
      end

      define_method :states do
        states
      end
    end

    define_states :normal, :stay, :blackjack, :bust

    def initialize(name, options = {})
      @name = name
      @hand = HandCard.new()
      @state = :normal
    end

    def hit(card)
      @hand << card

      if @hand.blackjack?
        be_blackjack
      elsif @hand.bust?
        be_bust
      end
    end
    alias_method :take_card, :hit

    def hit_or_stay
      if should_i_hit?
        say "Hit"
        true
      else
        say "Stay"
        be_stay
        false
      end
    end

    def over?
      !normal?
    end

    private

    # AI
    def should_i_hit?
      @hand.points < 16
    end

    def say(msg)
      puts "Player(#{name}): " + msg
    end
  end

  class RealPlayer < Player
    def should_i_hit?
      STDIN.gets.chomp.downcase != 's'
    end
  end

end
