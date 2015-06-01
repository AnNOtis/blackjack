module Blackjack

  class Card
    POINT_MAPPING = {
      'A' => 1,
      '2' => 2,
      '3' => 3,
      '4' => 4,
      '5' => 5,
      '6' => 6,
      '7' => 7,
      '8' => 8,
      '9' => 9,
      '10' => 10,
      'J' => 10,
      'Q' => 10,
      'K' => 10
    }

    attr_reader :name
    attr_accessor :flipped

    def self.all_names
      POINT_MAPPING.keys
    end

    def initialize(name, flipped = true)
      @name = name
      @flipped = flipped
    end

    def point
      POINT_MAPPING[@name]
    end

    def flip
      @flipped = true
      self
    end

    def flipped?
      flipped
    end

    def ==(another_card)
      self.name == another_card.name
    end

    def to_s
      name
    end
  end

  class HandCard < Array
    def points(only_flipped = true)
      points = min_points(only_flipped)

      ace_counts(only_flipped).times do
        break if points + 10 > 21
        points += 10
      end
      points
    end

    def display(display_unflipped = false)
      map(&:name).to_a.join(' ')
    end

    def select(&block)
      HandCard.new(super(&block))
    end

    def bust?
      points > 21
    end

    def blackjack?
      points(false) == 21
    end

    def flip_all
      each(&:flip)
    end

    def flipped_only(only_flipped = true)
      only_flipped ? select(&:flipped?) : self
    end

    private

    def min_points(only_flipped = true)
      flipped_only(only_flipped).inject(0) do |total_points, card|
        total_points + card.point
      end
    end

    def ace_counts(only_flipped = true)
      flipped_only(only_flipped).count { |card| card == Card.new('A') }
    end
  end

end