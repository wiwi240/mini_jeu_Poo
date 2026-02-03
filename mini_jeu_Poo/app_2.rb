require 'bundler'
Bundler.require
require_relative 'lib/player'

# 1. Message d'accueil
puts "------------------------------------------------"
puts "|Bienvenue sur 'ILS VEULENT TOUS MA POO' !      |"
puts "-------------------------------------------------"

# 2. Création du héros
print "Quel est ton prénom ? > "
name = gets.chomp
user = HumanPlayer.new(name)

# 3. Création des méchants
# On les met dans un tableau (Array) pour les manipuler plus facilement
enemies = [Player.new("Josiane"), Player.new("José")]

# 4. Boucle de jeu
# On continue tant que l'humain est vivant ET qu'au moins un ennemi est vivant
while user.life_points > 0 && (enemies[0].life_points > 0 || enemies[1].life_points > 0)
  puts "\n"
  user.show_state # Affiche la vie et l'arme de l'utilisateur
  
  # --- MENU DES CHOIX ---
  puts "Quelle action veux-tu effectuer ?"
  puts "a - chercher une meilleure arme"
  puts "s - chercher à se soigner"
  puts "attaquer un joueur en vue :"
  
  # On affiche les ennemis seulement s'ils sont vivants
  print "0 - "
  enemies[0].show_state
  print "1 - "
  enemies[1].show_state
  
  print "> "
  choice = gets.chomp
  
  # --- ACTION DU JOUEUR ---
  case choice
  when "a"
    user.search_weapon
  when "s"
    user.search_health_pack
  when "0"
    user.attacks(enemies[0])
  when "1"
    user.attacks(enemies[1])
  else
    puts "Tu as paniqué et passé ton tour !"
  end

  # --- RIPOSTE DES ENNEMIS ---
  puts "\nLes autres joueurs t'attaquent !"
  enemies.each do |enemy|
    # Un ennemi mort ne peut pas attaquer
    if enemy.life_points > 0
      enemy.attacks(user)
    end
  end
end

# 5. Fin de partie
puts "\nLa partie est finie."
if user.life_points > 0
  puts "BRAVO ! TU AS GAGNE !"
else
  puts "Loser ! Tu as perdu !"
end