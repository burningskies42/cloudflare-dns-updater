#!/bin/sh


# func to added timestamps to echo
log_message() {
    local timestamp
    timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] $1"
}

# Function to check if an environment variable exists
check_env_var() {
  local var_name="$1"
  local var_value="$(eval echo \$$var_name)"
  
  if [ -z "$var_value" ]; then
    echo "Error: Environment variable '${var_name}' is not set."
    exit 1
  fi
}

# Function to check if an environment variable exists
check_intenet_connection() {
  if ping -c 1 8.8.8.8 >/dev/null 2>&1; then
      echo "Internet connectivity is working."
  else
      echo "No internet connectivity."
      exit 1
  fi
}

check_dns_working() {
  if nslookup google.com >/dev/null 2>&1; then
      echo "DNS resolution is working."
  else
      echo "DNS resolution is not working."
      exit 1
  fi
}
