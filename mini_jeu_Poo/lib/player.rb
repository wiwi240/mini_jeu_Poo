# La classe Player sert de base pour tous les personnages (les bots)
class Player
  # attr_accessor crée automatiquement des méthodes pour LIRE et MODIFIER les variables
  # On pourra faire : player1.name = "Toto" ou puts player1.life_points
  attr_accessor :name, :life_points

  # La méthode initialize s'exécute AUTOMATIQUEMENT quand on fait Player.new("Nom")
  def initialize(name)
    @name = name # Le @ transforme la variable en "Variable d'instance" (elle reste en mémoire dans l'objet)
    @life_points = 10 # Chaque bot commence avec 10 points de vie
  end

  # Cette méthode sert juste à afficher le texte de l'état du joueur dans le terminal
  def show_state
    puts "#{@name} a #{@life_points} points de vie"
  end

  # Cette méthode gère la réception des coups
  # Elle prend un argument (un nombre entier) qui est le montant des dégâts
  def gets_damage(damage_received)
    @life_points = @life_points - damage_received # On soustrait les dégâts de la vie actuelle
    
    # Si après le coup la vie tombe sous 0, on la remet à 0 (pour ne pas avoir -5 PV)
    if @life_points <= 0
      @life_points = 0
      puts "le joueur #{@name} a été tué !" # Message d'alerte si le joueur meurt
    end
  end

  # Cette méthode permet à un joueur d'attaquer une cible (un autre objet Player)
  def attacks(player_to_attack)
    puts "le joueur #{@name} attaque le joueur #{player_to_attack.name}"
    
    # On appelle la méthode compute_damage (voir plus bas) pour savoir combien on tape
    damage = compute_damage
    puts "il lui inflige #{damage} points de dommages"
    
    # On applique ces dégâts à la cible en appelant SA méthode gets_damage
    player_to_attack.gets_damage(damage)
  end

  # Simule un dé à 6 faces pour déterminer la force du coup
  def compute_damage
    return rand(1..6) # rand(1..6) choisit un nombre entier au hasard entre 1 et 6
  end
end

# --------------------------------------------------------------------------
# La classe HumanPlayer "hérite" (<) de Player. 
# Elle récupère toutes les méthodes de Player mais on va en modifier certaines.
# --------------------------------------------------------------------------
class HumanPlayer < Player
  # On ajoute une nouvelle variable : le niveau de l'arme
  attr_accessor :weapon_level

  def initialize(name)
    @name = name # On garde le nom
    @life_points = 100 # MODIFICATION : l'humain est plus costaud (100 PV)
    @weapon_level = 1 # NOUVEAUTÉ : il commence avec une arme de niveau 1
  end

  # On "écrase" la méthode show_state de base pour afficher aussi le niveau de l'arme
  def show_state
    puts "#{@name} a #{@life_points} points de vie et une arme de niveau #{@weapon_level}"
  end

  # On "écrase" le calcul des dégâts : le dé est multiplié par le niveau de l'arme
  def compute_damage
    return rand(1..6) * @weapon_level
  end

  # Méthode spécifique à l'humain : chercher une arme
  def search_weapon
    new_weapon_level = rand(1..6) # On trouve une arme au hasard (niveau 1 à 6)
    puts "Tu as trouvé une arme de niveau #{new_weapon_level}"
    
    # Comparaison : on ne garde l'arme QUE si elle est meilleure que l'actuelle
    if new_weapon_level > @weapon_level
      @weapon_level = new_weapon_level
      puts "Youhou ! elle est meilleure que ton arme actuelle : tu la prends."
    else
      puts "... elle n'est pas mieux que ton arme actuelle..."
    end
  end

  # Méthode spécifique : chercher de la vie
  def search_health_pack
    dice = rand(1..6) # On lance un dé
    
    if dice == 1
      puts "Tu n'as rien trouvé... "
    elsif dice >= 2 && dice <= 5
      # Entre 2 et 5 : +50 PV
      @life_points += 50
      # On plafonne à 100 PV (on ne peut pas avoir 130/100)
      @life_points = 100 if @life_points > 100
      puts "Bravo, tu as trouvé un pack de +50 points de vie !"
    else
      # Si on fait 6 : +80 PV
      @life_points += 80
      @life_points = 100 if @life_points > 100
      puts "Waow, tu as trouvé un pack de +80 points de vie !"
    end
  end
end