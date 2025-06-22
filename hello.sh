Vaijan apnar take arekto modify korlam nen : 

 #!/bin/bash

# Color codes
green="\e[1;32m"
blue="\e[1;34m"
red="\e[1;31m"
cyan="\e[1;36m"
yellow="\e[1;33m"
reset="\e[0m"

# Trap for Ctrl+C
trap ctrl_c INT
ctrl_c() {
  echo -e "\n${yellow}😇 বাই বাই! আবার দেখা হবে সাপ দুনিয়ায়... 🐍${reset}"
  exit 0
}

# Typing effect function
type_writer() {
  text=$1
  for ((i = 0; i < ${#text}; i++)); do
    echo -ne "${text:$i:1}"
    sleep 0.01
  done
  echo
}

# Dependency check
check_dependencies() {
  for cmd in cowsay lolcat; do
    if ! command -v $cmd &> /dev/null; then
      echo -e "${yellow}Installing $cmd...${reset}"
      pkg install $cmd -y > /dev/null
    fi
  done
}

# Main Menu
while true; do
  clear
  echo -e "${green}"
  echo "=================================="
  echo " 🐍 S N A K E   F U N   T O O L 🐍"
  echo "         by Karim (v2.0)"
  echo "=================================="
  echo -e "${cyan}1. সাপের মতো বৃষ্টি"
  echo "2. রঙিন সাপ চলাচল"
  echo "3. গরু ডাকে – “সাপ আসছে!”"
  echo "4. ফেক ভাইরাস সাপ"
  echo "5. Exit${reset}"
  echo "=================================="
  echo -ne "${yellow}আপনার অপশন নির্বাচন করুন: ${reset}"
  read choice

  case $choice in
    1)
      while true; do
        for i in $(seq 1 20); do
          echo -e "${green}🐍💧🐍💧🐍💧🐍💧🐍💧🐍💧${reset}"
        done
        echo -e "${blue}Press Ctrl+C to stop...${reset}"
        sleep 0.2
        clear
      done
      ;;

    2)
      pos=0
      dir=1
      while true; do
        clear
        line=$(printf "%*s🐍" $pos "")
        echo -e "${cyan}$line-----সাপ চলছে-----${reset}"
        sleep 0.05
        ((pos+=dir))
        if (( pos > 40 || pos < 0 )); then
          ((dir*=-1))
        fi
      done
      ;;

    3)
      check_dependencies
      echo
      cowsay "বাঁচাও! বাড়িতে সাপ ঢুকছে! 🐍" | lolcat
      echo
      read -p "Enter চাপলে মেনুতে ফিরবেন..."
      ;;

    4)
      while true; do
        echo -e "${red}🐍 সাপ সিস্টেমে ঢুকেছে... VENOM ইনজেক্টING...${reset}"
        sleep 0.5
        echo -e "${red}☠ সিস্টেম ধ্বংস হচ্ছে... bye bye!${reset}"
        sleep 1
        clear
        echo -e "${yellow}Press Ctrl+C to stop the venom...${reset}"
      done
      ;;

    5)
      type_writer "${green}ধন্যবাদ ভাই! আবার আসবেন সাপের মেলায়! 🐍🐍🐍${reset}"
      exit
      ;;

    *)
      echo -e "${red}❌ ভুল অপশন! আবার দিন।${reset}"
      sleep 1
      ;;
  esac
done
