#!/bin/bash

# Terminal Pacman Game
# Version 1.0
# Author: BLACKBOXAI

# Colors
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
MAGENTA='\033[1;35m'
CYAN='\033[1;36m'
NC='\033[0m' # No Color

# Game settings
WIDTH=20
HEIGHT=10
PACMAN='C'
GHOST='G'
DOT='·'
WALL='█'
EMPTY=' '
SCORE=0
LIVES=3
LEVEL=1

# Initialize game board
declare -A BOARD
declare -A DOTS

# Positions
PACMAN_X=1
PACMAN_Y=1
GHOSTS=(
    "$((RANDOM % (WIDTH-2) + 1)) $((RANDOM % (HEIGHT-2) + 1))"
    "$((RANDOM % (WIDTH-2) + 1)) $((RANDOM % (HEIGHT-2) + 1))"
)

# Initialize game board
init_board() {
    for ((y=0; y<HEIGHT; y++)); do
        for ((x=0; x<WIDTH; x++)); do
            if (( x == 0 || x == WIDTH-1 || y == 0 || y == HEIGHT-1 )); then
                BOARD["$x,$y"]=$WALL
            else
                BOARD["$x,$y"]=$DOT
                DOTS["$x,$y"]=1
            fi
        done
    done
    
    # Clear starting positions
    BOARD["$PACMAN_X,$PACMAN_Y"]=$EMPTY
    unset DOTS["$PACMAN_X,$PACMAN_Y"]
    
    for ghost in "${GHOSTS[@]}"; do
        read -r gx gy <<< "$ghost"
        BOARD["$gx,$gy"]=$EMPTY
        unset DOTS["$gx,$gy"]
    done
    
    # Add some internal walls
    for ((i=3; i<WIDTH-3; i+=2)); do
        BOARD["$i,3"]=$WALL
        BOARD["$i,6"]=$WALL
        unset DOTS["$i,3"]
        unset DOTS["$i,6"]
    done
}

# Draw the game board
draw_board() {
    clear
    echo -e "${YELLOW}Terminal Pacman - Level $LEVEL - Score: $SCORE - Lives: $LIVES${NC}"
    echo
    
    for ((y=0; y<HEIGHT; y++)); do
        for ((x=0; x<WIDTH; x++)); do
            cell="${BOARD["$x,$y"]}"
            
            # Check if current cell is Pacman
            if (( x == PACMAN_X && y == PACMAN_Y )); then
                echo -ne "${YELLOW}$PACMAN${NC}"
            # Check if current cell is a ghost
            elif [[ " ${GHOSTS[@]} " =~ " $x $y " ]]; then
                echo -ne "${RED}$GHOST${NC}"
            # Check if current cell is a wall
            elif [[ "$cell" == "$WALL" ]]; then
                echo -ne "${BLUE}$WALL${NC}"
            # Check if current cell is a dot
            elif [[ "$cell" == "$DOT" ]]; then
                echo -ne "${GREEN}$DOT${NC}"
            else
                echo -ne "$EMPTY"
            fi
        done
        echo
    done
}

# Move Pacman
move_pacman() {
    local direction=$1
    
    new_x=$PACMAN_X
    new_y=$PACMAN_Y
    
    case $direction in
        w) ((new_y--)) ;;
        s) ((new_y++)) ;;
        a) ((new_x--)) ;;
        d) ((new_x++)) ;;
    esac
    
    # Check wall collision
    if [[ "${BOARD["$new_x,$new_y"]}" != "$WALL" ]]; then
        PACMAN_X=$new_x
        PACMAN_Y=$new_y
        
        # Check dot collection
        if [[ -n "${DOTS["$PACMAN_X,$PACMAN_Y"]}" ]]; then
            ((SCORE+=10))
            unset DOTS["$PACMAN_X,$PACMAN_Y"]
            BOARD["$PACMAN_X,$PACMAN_Y"]=$EMPTY
        fi
    fi
}

# Move ghosts
move_ghosts() {
    for i in "${!GHOSTS[@]}"; do
        read -r gx gy <<< "${GHOSTS[$i]}"
        
        # Simple AI: move randomly but towards Pacman
        options=()
        
        # Check possible moves (not walls)
        if [[ "${BOARD["$((gx-1)),$gy"]}" != "$WALL" ]]; then
            options+=("$((gx-1)) $gy")
        fi
        if [[ "${BOARD["$((gx+1)),$gy"]}" != "$WALL" ]]; then
            options+=("$((gx+1)) $gy")
        fi
        if [[ "${BOARD["$gx,$((gy-1))"]}" != "$WALL" ]]; then
            options+=("$gx $((gy-1))")
        fi
        if [[ "${BOARD["$gx,$((gy+1))"]}" != "$WALL" ]]; then
            options+=("$gx $((gy+1))")
        fi
        
        # Choose a random move from available options
        if (( ${#options[@]} > 0 )); then
            GHOSTS[$i]="${options[$((RANDOM % ${#options[@]}))]}"
        fi
    done
}

# Check collisions
check_collisions() {
    for ghost in "${GHOSTS[@]}"; do
        read -r gx gy <<< "$ghost"
        if (( PACMAN_X == gx && PACMAN_Y == gy )); then
            ((LIVES--))
            if (( LIVES <= 0 )); then
                game_over
            else
                # Reset positions after losing a life
                PACMAN_X=1
                PACMAN_Y=1
                GHOSTS=(
                    "$((RANDOM % (WIDTH-2) + 1)) $((RANDOM % (HEIGHT-2) + 1))"
                    "$((RANDOM % (WIDTH-2) + 1)) $((RANDOM % (HEIGHT-2) + 1))"
                )
                sleep 1
            fi
        fi
    done
}

# Check win condition
check_win() {
    if (( ${#DOTS[@]} == 0 )); then
        ((LEVEL++))
        init_board
        PACMAN_X=1
        PACMAN_Y=1
        GHOSTS=(
            "$((RANDOM % (WIDTH-2) + 1)) $((RANDOM % (HEIGHT-2) + 1))"
            "$((RANDOM % (WIDTH-2) + 1)) $((RANDOM % (HEIGHT-2) + 1))"
        )
        draw_board
        echo -e "${GREEN}Level Complete!${NC}"
        sleep 2
    fi
}

# Game over
game_over() {
    draw_board
    echo -e "${RED}Game Over!${NC}"
    echo -e "Final Score: $SCORE"
    echo -e "Level Reached: $LEVEL"
    exit 0
}

# Main game loop
main() {
    init_board
    
    while true; do
        draw_board
        
        # Read input with timeout for non-blocking input
        read -rs -n1 -t0.1 input
        
        case $input in
            w|a|s|d) move_pacman "$input" ;;
            q) game_over ;;
        esac
        
        move_ghosts
        check_collisions
        check_win
        
        # Game speed
        sleep 0.2
    done
}

# Start screen
start_screen() {
    clear
    echo -e "${YELLOW}┌──────────────────────────────────────┐"
    echo -e "│      ${RED}TERMINAL PACMAN GAME${YELLOW}           │"
    echo -e "├──────────────────────────────────────┤"
    echo -e "│                                      │"
    echo -e "│  ${GREEN}Controls:${NC}                            │"
    echo -e "│  ${CYAN}W${NC} - Move Up                          │"
    echo -e "│  ${CYAN}A${NC} - Move Left                        │"
    echo -e "│  ${CYAN}S${NC} - Move Down                        │"
    echo -e "│  ${CYAN}D${NC} - Move Right                       │"
    echo -e "│  ${CYAN}Q${NC} - Quit Game                        │"
    echo -e "│                                      │"
    echo -e "│  ${MAGENTA}Collect all dots to advance!${NC}       │"
    echo -e "│  ${RED}Avoid the ghosts (G)!${NC}                 │"
    echo -e "│                                      │"
    echo -e "└──────────────────────────────────────┘${NC}"
    echo
    read -p "Press any key to start..." -n1 -s
}

# Trap Ctrl+C
trap ctrl_c INT
ctrl_c() {
    echo -e "\n${YELLOW}Exiting game...${NC}"
    exit 0
}

start_screen
main
