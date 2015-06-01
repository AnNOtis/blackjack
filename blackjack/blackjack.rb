require_relative 'card'
require_relative 'player'
require_relative 'dealer'

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
      hint <<-EOF.gsub(/^ */, '')
        開始遊戲
        Dealer: #{@dealer.name}
        Players: #{@players.map(&:name).to_a.join(' ')}
      EOF

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

      unless everyone_bust?
        @dealer.ask_hit_or_stay_until_over(@dealer)
      end

      flip_everyones_hand

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

    def hint(msg)
      puts "\n===============\n" + msg.chomp + "\n===============\n\n"
    end

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

      puts "#{@dealer.name.ljust(10)} | " + @dealer.hand.display.ljust(15) + " | (#{@dealer.hand.points}) #{@dealer.state}"

      @players.each do |player|
        puts "#{player.name.ljust(10)} | " + player.hand.display.ljust(15) + " | (#{player.hand.points}) #{player.state}"
      end

      puts "====================================\n"
    end

    def flip_everyones_hand
      @players.each{ |player| player.hand.flip_all }
    end

    def everyone_bust?
      @players.all?(&:bust?)
    end

    def judge_winner
      winner =
        if @dealer.blackjack?
          @dealer
        elsif @players.any?(&:blackjack?)
          @players.find(&:blackjack?)
        else
          @players.push(@dealer)
            .reject(&:bust?)
            .max_by{ |player| player.hand.points }
        end

      puts "勝利者是 #{winner.name}(#{winner.hand.points})"
    end
  end
end

Blackjack::Game.start