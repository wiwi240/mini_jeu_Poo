require 'bundler'
Bundler.require # Charge toutes les gems du Gemfile (comme Pry)

# On lie les fichiers de logique pour que app.rb puisse utiliser les classes Player
require_relative 'lib/player'

# 1. Création des combattants
player1 = Player.new("Josiane")
player2 = Player.new("José")

# 2. Boucle de combat
# Tant que les deux ont plus de 0 points de vie, le combat continue
while player1.life_points > 0 && player2.life_points > 0
  puts "\n--- Voici l'état de nos joueurs ---"
  player1.show_state
  player2.show_state
  
  puts "\nPassons à la phase d'attaque :"
  
  # Josiane attaque José
  player1.attacks(player2)
  
  # On vérifie si José est mort pour arrêter le combat immédiatement
  break if player2.life_points <= 0
  
  # José attaque Josiane
  player2.attacks(player1)
end

puts "\nLe combat est terminé !"