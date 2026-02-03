require 'bundler'
Bundler.require
require_relative 'lib/game'
require_relative 'lib/player'

# 1. Initialisation
puts "Lancement du jeu version 3.0..."
print "Ton nom de héros ? > "
user_name = gets.chomp

# On crée l'objet "my_game" qui contient tout l'univers du jeu
my_game = Game.new(user_name)

# 2. Boucle de jeu principale
# On utilise la méthode is_still_ongoing? qu'on a codée dans Game
while my_game.is_still_ongoing?
  
  # Affiche les PV de l'humain et le nombre d'ennemis restants
  my_game.show_players
  
  # Fait apparaître de nouveaux ennemis (spawn)
  my_game.new_players_in_sight
  
  # Affiche les options (a, s, 0, 1...)
  my_game.menu
  
  # Récupère le choix de l'utilisateur
  print "\nTon choix > "
  user_input = gets.chomp
  
  # Envoie ce choix à l'objet my_game pour qu'il le traite
  my_game.menu_choice(user_input)
  
  # Fait attaquer tous les bots présents
  my_game.enemies_attack
  
  # Petite pause pour laisser le temps de lire le terminal
  puts "\nAppuie sur Entrée pour le prochain tour..."
  gets.chomp
end

# 3. Fin du jeu
my_game.end_game