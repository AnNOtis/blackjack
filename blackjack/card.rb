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

    attr_reader :name, :flipped

    def self.all_names
      POINT_MAPPING.keys
    end

    def initialize(name, flipped = false)
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
    def min_points
      inject(0) do |total_points, card|
        total_points + card.point
      end
    end

    def points
      return min_points if min_points > 11

      points = min_points
      ace_counts.times do
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

    private

    def ace_counts
      count { |card| card == Card.new('A') }
    end
  end

end