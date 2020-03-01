vol=$(amixer sget -D pulse Master | grep "Front Right:" | awk -F'[][]' '{ print $2 }')

amixer -D pulse sset Master 10%+

if [ "$vol" = "100%" ]; then
  play -q -n synth 0.1 sin 880 || echo -e "\a"
else
  echo 2
fi