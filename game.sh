#!/bin/bash

# Color codes
green="\e[1;32m"
yellow="\e[1;33m"
red="\e[1;31m"
reset="\e[0m"

# Trap for Ctrl+C
trap ctrl_c INT
ctrl_c() {
  echo -e "\n${yellow}😇 Bye! See you next time! 🐍${reset}"
  exit 0
}

# Game variables
pacman="C"
dot="."
ghost="G"
empty=" "
width=10
height=10
score=0
pacman_x=1
pacman_y=1
ghost_x=$((RANDOM % width))
ghost_y=$((RANDOM % height))

# Function to draw the game board
draw_board() {
  clear
  for ((y=0; y<height; y++)); do
    for ((x=0; x<width; x++)); do
      if [[ $x -eq $pacman_x && $y -eq $pacman_y ]]; then
        echo -ne "${green}$pacman${reset}"
      elif [[ $x -eq $ghost_x && $y -eq $ghost_y ]]; then
        echo -ne "${red}$ghost${reset}"
      else
        echo -ne "$dot"
      fi
    done
    echo
  done
  echo -e "${yellow}Score: $score${reset}"
}

# Function to move Pacman
move_pacman() {
  read -s -n 1 input
  case $input in
    w) ((pacman_y--)) ;;  # Move up
    s) ((pacman_y++)) ;;  # Move down
    a) ((pacman_x--)) ;;  # Move left
    d) ((pacman_x++)) ;;  # Move right
  esac

  # Keep Pacman within bounds
  if ((pacman_x < 0)); then pacman_x=0; fi
  if ((pacman_x >= width)); then pacman_x=$((width-1)); fi
  if ((pacman_y < 0)); then pacman_y=0; fi
  if ((pacman_y >= height)); then pacman_y=$((height-1)); fi

  # Check for collision with ghost
  if [[ $pacman_x -eq $ghost_x && $pacman_y -eq $ghost_y ]]; then
    echo -e "${red}Game Over! You were caught by the ghost!${reset}"
    exit 0
  fi

  # Check for collecting dots
  if [[ $pacman_x -ne $ghost_x || $pacman_y -ne $ghost_y ]]; then
    ((score++))
  fi
}

# Main game loop
while true; do
  draw_board
  move_pacman
  sleep 0.1
done
