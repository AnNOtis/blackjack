require_relative 'blackjack/card'
require_relative 'blackjack/player'
require_relative 'blackjack/dealer'

module Blackjack
  class Game
    def self.start
      Game.new.start
    end

    def initialize
      @dealer = Dealer.new('👽 ', 2)
      @players = [Player.new('👺 '), RealPlayer.new('😚 ')]
    end

    def start
      puts '開始遊戲'
      puts "Dealer: #{@dealer.name}"
      puts "Players: #{@players.map(&:name).to_a.join(' ')}"
      puts '============'

      shuffle_card
      blackjack_progress
      game_over
      again?
    end

    def shuffle_card
      @dealer.shuffle_cards
    end

    def blackjack_progress
      deal_to_players_in_the_beginning

      until everyplayer_stop_deal?
        @players.each do |player|
          @dealer.ask_hit_or_stay_until_over(player)
        end
      end

      unless everyplayer_bust?
        @dealer.ask_hit_or_stay_until_over(@dealer)
      end

      display_everyones_hand

      judge_winner
    end

    def game_over
      puts '遊戲結束'
    end

    def again?
      puts '再來一場嗎？(Y/n)'
      if STDIN.gets.chomp.downcase == 'y'
        restart
      end
    end

    def restart
      puts '重來一場！！'
      Game.start
    end

    private

    def deal_to_players_in_the_beginning
      @players.cycle(2) do |player|
        @dealer.deal(player)
      end
    end

    def everyplayer_stop_deal?
      @players.reduce(true) do |other_state_over, player|
        other_state_over && player.over?
      end
    end

    def display_everyones_hand
      puts "\n=========== 統計結果 ===============\n"

      puts "#{@dealer.name.ljust(10)} | " + @dealer.hand.display.ljust(15) + " | (#{@dealer.hand.points}) #{@dealer.current_state(true)}"

      @players.each do |player|
        puts "#{player.name.ljust(10)} | " + player.hand.display.ljust(15) + " | (#{player.hand.points}) #{player.current_state(true)}"
      end
    end

    def everyplayer_bust?
      @players.all?{ |player| player.state_bust?(true) }
    end

    def judge_winner
      winner =
        if @dealer.state_blackjack?
          @dealer
        elsif @players.any?(&:state_blackjack?)
          @players.find(&:state_blackjack?)
        else
          @players.push(@dealer)
            .reject{ |p| p.state_bust?(true) }
            .max_by{ |player| player.hand.points }
        end

      puts "勝利者是 #{winner.name}(#{winner.hand.points})"
    end
  end
end

# Blackjack::Game.start