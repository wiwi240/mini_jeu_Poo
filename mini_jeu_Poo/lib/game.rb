class Game
  # attr_accessor permet de lire et modifier les variables d'instance de l'objet
  # @human_player : l'objet HumanPlayer (l'utilisateur)
  # @enemies_in_sight : le tableau (Array) contenant les ennemis actuellement sur le terrain
  # @players_left : le nombre d'ennemis total restant à faire apparaître dans le jeu
  attr_accessor :human_player, :enemies_in_sight, :players_left

  # La méthode initialize crée l'univers du jeu quand on fait Game.new("Nom")
  def initialize(name)
    @human_player = HumanPlayer.new(name) # On crée notre héros
    @enemies_in_sight = []                # Personne sur le terrain au début
    @players_left = 10                     # Objectif : 10 ennemis au total
  end

  # Supprime un objet Player du tableau des ennemis (utilisé quand un bot meurt)
  def kill_player(player)
    @enemies_in_sight.delete(player)
  end

  # Vérifie si la partie doit continuer
  # Le jeu s'arrête si l'humain meurt OU s'il n'y a plus d'ennemis (réserve + terrain)
  def is_still_ongoing?
    @human_player.life_points > 0 && (@players_left > 0 || !@enemies_in_sight.empty?)
  end

  # Affiche les informations de santé du héros et le stock d'ennemis
  def show_players
    @human_player.show_state
    puts "Ennemis restants en réserve : #{@players_left}"
    puts "Ennemis actuellement face à toi : #{@enemies_in_sight.length}"
  end

  # Affiche les choix possibles pour l'utilisateur dans le terminal
  def menu
    puts "\n--- QUELLE ACTION CHOISIR ? ---"
    puts "a - Chercher une meilleure arme"
    puts "s - Chercher à se soigner"
    puts "\nAttaquer un joueur en vue :"
    
    # On parcourt le tableau des ennemis présents pour proposer des cibles
    @enemies_in_sight.each_with_index do |enemy, index|
      # Affiche l'index (0, 1, 2...) pour que l'utilisateur puisse taper le chiffre
      print "#{index} - "
      enemy.show_state
    end
  end

  # Reçoit le choix (string) et déclenche l'action correspondante
  def menu_choice(string)
    case string
    when "a"
      @human_player.search_weapon
    when "s"
      @human_player.search_health_pack
    else
      # Si l'utilisateur tape un chiffre, on le transforme en entier (index)
      index = string.to_i
      # On vérifie si cet index existe bien dans notre tableau d'ennemis
      if index >= 0 && index < @enemies_in_sight.length
        target = @enemies_in_sight[index]
        @human_player.attacks(target)
        # Si l'attaque a tué l'ennemi, on le retire immédiatement du terrain
        kill_player(target) if target.life_points <= 0
      else
        puts "Cible invalide ! Tu frappes dans le vide."
      end
    end
  end

  # Fait attaquer tous les ennemis présents sur le terrain un par un
  def enemies_attack
    # Si le tableau est vide, personne n'attaque
    return if @enemies_in_sight.empty?
    
    puts "\n--- RIPOSTE DES ENNEMIS ---"
    @enemies_in_sight.each do |enemy|
      # L'ennemi attaque seulement si le joueur humain est toujours vivant
      if @human_player.life_points > 0
        enemy.attacks(@human_player)
      end
    end
  end

  # Système d'apparition aléatoire de nouveaux ennemis (Spawn)
  def new_players_in_sight
    # On s'arrête si tous les ennemis prévus (10) sont déjà apparus
    if (@enemies_in_sight.length + (10 - @players_left - @enemies_in_sight.length)) >= 10 && @players_left <= 0
      puts "Tous les joueurs sont déjà en vue."
      return
    end

    roll = rand(1..6) # Lancer de dé pour le spawn
    case roll
    when 1
      puts "Rien ne se passe... tu es tranquille pour l'instant."
    when 2..4
      # On crée un nouveau Player avec un nom unique (chiffre aléatoire)
      new_enemy = Player.new("joueur_#{rand(1000..9999)}")
      @enemies_in_sight << new_enemy
      @players_left -= 1
      puts "Alerte : Un nouvel ennemi vient d'apparaître !"
    when 5..6
      # On essaie d'en faire apparaître deux
      2.times do
        if @players_left > 0
          @enemies_in_sight << Player.new("joueur_#{rand(1000..9999)}")
          @players_left -= 1
        end
      end
      puts "Attention : DEUX nouveaux ennemis débarquent d'un coup !"
    end
  end

  # Méthode de conclusion (appelée à la fin du fichier app_3.rb)
  def end_game
    puts "\n" + "="*30
    puts "      LA PARTIE EST FINIE"
    puts "="*30
    
    if @human_player.life_points > 0
      puts "VICTOIRE ! Tu es le dernier survivant de l'arène."
    else
      puts "DEFAITE... Tu as rejoint le cimetière des POO."
    end
  end
end