#!/usr/bin/env tclsh

# Get the Player name  
puts "Enter your character's name: "
set char_name [gets stdin]

# Define game variables and character stats
set character(name) "$char_name"
set character(health) 100
set character(attack) 10
set character(defense) 5
set character(gold) 0
set character(level) 1
set character(experience) 0
 
# Function to handle leveling up
proc level_up {} {
    global character
    incr character(level)
    incr character(attack) 5
    incr character(defense) 3
    incr character(health) 20
    set character(experience) 0
    puts "Congratulations! You are now level $character(level)!"
}
 
# Function to handle battles with monsters
proc battle {monster_name monster_hp monster_attack} {
    global character
    while { $monster_hp > 0 } {
        puts "-----------------------------------------"
        puts "You ($character(name)) vs. $monster_name"
        puts "1. Attack"
        puts "2. Run"
        puts -nonewline "Your choice: "
        set choice [gets stdin]
 
        switch -exact $choice {
            1 {
                set damage [expr {int(rand() * $character(attack))}]
                puts "You attack $monster_name for $damage damage!"
                set monster_hp [expr $monster_hp - $damage]
                if { $monster_hp <= 0 } {
                    puts "You defeated $monster_name!"
                    set character(gold) [expr $character(gold) + 10]
                    set character(experience) [expr $character(experience) + 20]
                    if { $character(experience) >= [expr $character(level) * 100] } {
                        level_up
                    }
                } else {
                    set damage [expr {int(rand() * $monster_attack)}]
                    puts "$monster_name counterattacks for $damage damage!"
                    set character(health) [expr $character(health) - $damage]
                    if { $character(health) <= 0 } {
                        puts "You were defeated by $monster_name. Game Over!"
                        exit
                    }
                }
		puts "Name: $character(name) (Level: $character(level), HP: $character(health), Attack: $character(attack), Gold: $character(gold))"

            }
            2 {
                puts "You run away from $monster_name. Coward!"
                return
            }
            default {
                puts "Invalid choice. Try again."
            }
        }
    }
}
 
# Function to handle quests
proc complete_quest {quest_name quest_reward_xp quest_reward_gold} {
    global character
    puts "You completed the quest '$quest_name' and earned $quest_reward_xp XP and $quest_reward_gold gold!"
    incr character(experience) $quest_reward_xp
    incr character(gold) $quest_reward_gold
}
 
# Main game loop
while { 1 } {
    puts "-----------------------------------------"
    puts "Name: $character(name) (Level: $character(level), HP: $character(health), Attack: $character(attack), Gold: $character(gold))"
    puts "1. Battle Monster"
    puts "2. Complete Quest"
    puts "3. Quit"
    puts -nonewline "Your choice: "
    set choice [gets stdin]
 
    switch -exact $choice {
        1 {
            set monster_name "Dragon"
            set monster_hp [expr {50 + ($character(level) - 1) * 10}]
            set monster_attack [expr {10 + ($character(level) - 1) * 2}]
            battle $monster_name $monster_hp $monster_attack
        }
        2 {
            puts "Available Quests:"
            puts "1. Slay 3 Goblins (Reward: 30 XP, 15 Gold)"
            puts "2. Defeat the Evil Wizard (Reward: 60 XP, 30 Gold)"
            puts "3. Gather Herbs in the Forest (Reward: 20 XP, 10 Gold)"
            puts -nonewline "Enter the quest number you want to complete (or 0 to cancel): "
            set quest_number [gets stdin]
 
            switch -exact $quest_number {
                1 {
                    complete_quest "Slay 3 Goblins" 30 15
                }
                2 {
                    complete_quest "Defeat the Evil Wizard" 60 30
                }
                3 {
                    complete_quest "Gather Herbs in the Forest" 20 10
                }
                0 {
                    puts "Quest canceled."
                }
                default {
                    puts "Invalid quest number. Try again."
                }
            }
        }
        3 {
            puts "Thanks for playing!"
            exit
        }
        default {
            puts "Invalid choice. Try again."
        }
    }
}
