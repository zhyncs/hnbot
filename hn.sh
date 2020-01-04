#!/bin/bash

cat > top<<-EOF
$(curl -s https://hacker-news.firebaseio.com/v0/topstories.json | sed "s/^\[//" | sed "s/.\]//")
EOF

for ((i = 1; i <= 30; ++i)); do
  id=$(cat top | cut -d ',' -f${i})
  url="https://hacker-news.firebaseio.com/v0/item/"${id}".json"
  exist=$(curl -s ${url} | grep "url")
  if [[ -n $exist ]]; then
    link=$(curl -s ${url} | jq '.url' | cut -d '"' -f2 | sed "s/%/%25/g;s/ /%2520/g;s/+/%2520/g")
    curl -X POST "https://api.telegram.org/bot$API_TOKEN/sendMessage" -d "chat_id=@$CHANNEL_ID&disable_notification=true&text="${link}
  fi
done
