module Blackjack

  class Player
    attr_reader :name, :hand

    def self.define_states(*states)
      states.each do |state|
        define_method("to_#{state}") do
          @state = state.to_sym
        end

        define_method("state_#{state}?") do
          current_state == state.to_sym
        end

        define_method("state_#{state}") do
          state.to_sym
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
      @state = state_normal
    end

    def hit(card)
      @hand << card
    end
    alias_method :take_card, :hit

    def hit_or_stay?
      if should_i_hit?
        say "Hit"
        true
      else
        say "Stay"
        to_stay
        false
      end
    end

    def state_bust?(check_unflipped_card = false)
      current_state(check_unflipped_card) == state_bust
    end

    def current_state(check_unflipped_card = false)
      if @hand.points == 21
        state_blackjack
      elsif @hand.select{ |c| c.flipped? || check_unflipped_card }.points > 21
        state_bust
      else
        @state
      end
    end

    def over?
      !state_normal?
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
    def hit_or_stay?
      if STDIN.gets.chomp.downcase == 'h'
        say 'Hit'
        true
      else
        say 'Stay'
        to_stay
        false
      end
    end
  end

end
