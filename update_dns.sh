#!/bin/sh

# func to added timestamps to echo
log_message() {
    local timestamp
    timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] $1"
}

# Redirect both stdout and stderr to /dev/stdout
exec >/dev/stdout 2>&1

while true; do

  # get current ip
  current_ip=$(curl -s https://ifconfig.me)

  # get current DNS record
  json_data=$(curl -s --request GET \
    --url https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records \
    -H 'Content-Type: application/json' \
    -H "Authorization: Bearer ${API_TOKEN}"
  )
  dns_record=$(echo "$json_data" | jq -r '.result[] | select(.type == "A") | .content')
  record_name=$(echo "$json_data" | jq -r '.result[] | select(.type == "A") | .name')
  record_id=$(echo "$json_data" | jq -r '.result[] | select(.type == "A") | .id')

  log_message "current ip: $current_ip"
  log_message "dns record for $record_name is $dns_record"

  # if record does no match current ip, then update
  if [ "$current_ip" = "$dns_record" ]; then
      log_message "No update required"
  else
    request_data=\'{\"type\":\"A\",\"name\":\"${record_name}\",\"content\":\"$current_ip\"}\'
    url="https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$record_id"
    resonse=$(curl -s -X PUT $url \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer ${API_TOKEN}" \
        --data '{"type":"A","name":"'$record_name'","content":"'$current_ip'","ttl":1,"proxied":false}' 
      )

    # log result of request
    success=$(echo $resonse | jq -r '.success')
    if [ "$success" = true ]; then
      echo success
    else
      echo failed
      echo $resonse
    fi

  fi

  # wait for 10 minutes
  sleep 300

done