class Game
  attr_accessor :human_player, :enemies_in_sight, :players_left

  def initialize(name)
    @human_player = HumanPlayer.new(name)
    @enemies_in_sight = []
    @players_left = 10
  end

  def kill_player(player)
    @enemies_in_sight.delete(player)
  end

  def is_still_ongoing?
    @human_player.life_points > 0 && (@players_left > 0 || !@enemies_in_sight.empty?)
  end

  def show_players
    @human_player.show_state
    puts "Ennemis restants dans le jeu : #{@players_left}"
    puts "Ennemis en vue : #{@enemies_in_sight.length}"
  end

  def menu
    puts "\nQuelle action veux-tu effectuer ?"
    puts "a - chercher une meilleure arme"
    puts "s - chercher à se soigner"
    puts "attaquer un joueur en vue :"
    @enemies_in_sight.each_with_index do |enemy, index|
        print "#{index} - "
        enemy.show_state
    end
  end

  def menu_choice(string)
    case string
    when "a"
      @human_player.search_weapon
    when "s"
      @human_player.search_health_pack
    else
      index = string.to_i
      if index < @enemies_in_sight.length
        target = @enemies_in_sight[index]
        @human_player.attacks(target)
        kill_player(target) if target.life_points <= 0
      end
    end
  end

  def enemies_attack
    @enemies_in_sight.each do |enemy|
      enemy.attacks(@human_player) if @human_player.life_points > 0
    end
end

def new_players_in_sight
return puts "Tous les joueurs sont déjà en vue" if @enemies_in_sight.length == @players_left

roll = rand(1..6)
case roll
    when 1
        puts "Aucun nouveau joueur adverse n'arrive."
    when 2..4
    new_enemy = Player.new("joueur_#{rand(1000..9999)}")
    @enemies_in_sight << new_enemy
    @players_left -= 1
    puts "Un nouvel adversaire arrive en vue !"
    when 5..6
    2.times do
    if @players_left > 0
        @enemies_in_sight << Player.new("joueur_#{rand(1000..9999)}")
        @players_left -= 1
    end
    end
    puts "Deux nouveaux adversaires arrivent en vue !"
end
end

def end_game
puts "La partie est finie"
@human_player.life_points > 0 ? (puts "BRAVO ! TU AS GAGNE !") : (puts "Loser ! Tu as perdu !")
end
end