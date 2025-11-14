#!/bin/bash

sleep 1

API_KEY="32c2e8a080fe4b279ed35832250109"
CITY="Almaty"

# Fetch current weather
DATA=$(curl -s "http://api.weatherapi.com/v1/current.json?key=$API_KEY&q=$CITY")

# Parse values
TEMP=$(echo "$DATA" | jq ".current.temp_c" | cut -d'.' -f1)
COND=$(echo "$DATA" | jq -r ".current.condition.text")

# Map condition text → emoji (you can extend)
case "$COND" in
*Sunny* | *Clear*) WEATHER="☀️" ;;
"Partly cloudy") WEATHER="⛅" ;;
*Cloud* | *Overcast*) WEATHER="☁️" ;;
*Rain* | *Drizzle* | *rain*) WEATHER="🌧️" ;;
*Thunder* | *Storm*) WEATHER="⛈️" ;;
*Snow*) WEATHER="❄️" ;;
*Fog* | *Mist*) WEATHER="🌫️" ;;
*) WEATHER="?" ;;
esac

# Output JSON for Waybar
echo "{\"text\": \"$WEATHER ${TEMP}°C \", \"tooltip\": \"${CITY}: $TEMP°C, $COND\"}"
