require 'bundler'
Bundler.require
require_relative 'lib/player'

puts "------------------------------------------------"
puts "|Bienvenue sur 'ILS VEULENT TOUS MA POO' !      |"
puts "|Le but du jeu est d'être le dernier survivant !|"
puts "-------------------------------------------------"

puts "Quel est ton prénom ?"
user_name = gets.chomp
user = HumanPlayer.new(user_name)

enemies = [Player.new("Josiane"), Player.new("José")]

while user.life_points > 0 && (enemies[0].life_points > 0 || enemies[1].life_points > 0)
  user.show_state
  puts "Quelle action veux-tu effectuer ?"
  puts "a - chercher une meilleure arme"
  puts "s - chercher à se soigner"
  puts "attaquer un joueur en vue :"
  enemies.each_with_index do |enemy, index|
    print "#{index} - "
    enemy.show_state
  end

  choice = gets.chomp
  case choice
  when "a" then user.search_weapon
  when "s" then user.search_health_pack
  when "0" then user.attacks(enemies[0])
  when "1" then user.attacks(enemies[1])
  end

  puts "\nLes autres joueurs t'attaquent !"
  enemies.each do |enemy|
    enemy.attacks(user) if enemy.life_points > 0
  end
end

puts "La partie est finie"
user.life_points > 0 ? (puts "BRAVO ! TU AS GAGNE !") : (puts "Loser ! Tu as perdu !")