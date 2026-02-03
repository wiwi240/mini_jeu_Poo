class Game
  # On a besoin d'accéder au joueur humain et à la liste des ennemis
  attr_accessor :human_player, :enemies_in_sight, :players_left

  def initialize(user_name)
    # On crée l'unique joueur humain avec le nom choisi
    @human_player = HumanPlayer.new(user_name)
    
    # On prépare une liste vide pour les ennemis qui vont apparaître
    @enemies_in_sight = []
    
    # On fixe un objectif : 10 ennemis au total à éliminer pour gagner
    @players_left = 10
  end

  # Supprime un objet Player de la liste (utilisé quand un bot meurt)
  def kill_player(player_obj)
    @enemies_in_sight.delete(player_obj)
  end

  # Cette méthode renvoie "true" (vrai) si la partie doit continuer
  def is_still_ongoing?
    # La partie continue SI l'humain a de la vie ET (s'il reste des gens à faire apparaître OU s'il y a des gens en face)
    if @human_player.life_points > 0 && (@players_left > 0 || @enemies_in_sight.any?)
      return true
    else
      return false
    end
  end

  # Affiche les stats globales
  def show_players
    @human_player.show_state # Santé de l'humain
    puts "Il reste #{@players_left} ennemis en réserve."
  end

  # Affiche le menu texte pour que l'utilisateur sache quoi taper
  def menu
    puts "\nQuelle action veux-tu effectuer ?"
    puts "a - chercher une meilleure arme"
    puts "s - chercher à se soigner"
    puts "\nAttaquer un joueur en vue :"
    
    # On boucle sur le tableau des ennemis présents pour les afficher avec un numéro
    @enemies_in_sight.each_with_index do |enemy, index|
      # index commence à 0, 1, 2...
      print "#{index} - "
      enemy.show_state # Affiche le nom et la vie de l'ennemi ciblé
    end
  end

  # Reçoit la lettre ou le chiffre tapé par l'utilisateur et déclenche l'action
  def menu_choice(input_string)
    if input_string == "a"
      @human_player.search_weapon
    elsif input_string == "s"
      @human_player.search_health_pack
    else
      # Si c'est un chiffre, on le transforme en "Integer" (nombre entier)
      target_index = input_string.to_i
      
      # On vérifie si l'ennemi existe bien à cet index dans le tableau
      if target_index < @enemies_in_sight.length
        target_enemy = @enemies_in_sight[target_index]
        @human_player.attacks(target_enemy) # On attaque l'ennemi
        
        # Si l'ennemi est mort après l'attaque, on le retire du jeu
        if target_enemy.life_points <= 0
          kill_player(target_enemy)
        end
      else
        puts "Cible invalide, tu passes ton tour par maladresse !"
      end
    end
  end

  # Fait attaquer tous les ennemis présents dans @enemies_in_sight
  def enemies_attack
    puts "\nLes ennemis ripostent !"
    @enemies_in_sight.each do |enemy|
      # L'ennemi attaque l'humain SEULEMENT si l'humain est encore en vie
      if @human_player.life_points > 0
        enemy.attacks(@human_player)
      end
    end
  end

  # Logique pour faire apparaître de nouveaux ennemis aléatoirement
  def new_players_in_sight
    # Si tous les ennemis (10) sont déjà là, on ne fait rien
    if @enemies_in_sight.length >= @players_left
      puts "Tous les joueurs sont déjà en vue."
      return
    end

    dice = rand(1..6) # On lance un dé pour le "spawn"
    
    case dice
    when 1
      puts "Rien ne se passe... calme plat."
    when 2, 3, 4
      # On crée 1 nouvel ennemi avec un numéro au hasard pour le nom
      new_bot = Player.new("joueur_#{rand(1000..9999)}")
      @enemies_in_sight << new_bot # On l'ajoute au tableau
      @players_left -= 1 # On baisse le stock de la réserve
      puts "Un nouvel adversaire arrive !"
    when 5, 6
      # On en crée 2 d'un coup
      2.times do
        if @players_left > 0 # On vérifie qu'il en reste en stock
          @enemies_in_sight << Player.new("joueur_#{rand(1000..9999)}")
          @players_left -= 1
        end
      end
      puts "DEUX nouveaux adversaires débarquent !"
    end
  end
end