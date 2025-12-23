#!/bin/bash

sleep 1

API_KEY="32c2e8a080fe4b279ed35832250109"
CITY="Almaty"

DATA=$(curl -s "http://api.weatherapi.com/v1/current.json?key=$API_KEY&q=$CITY")

TEMP=$(echo "$DATA" | jq ".current.temp_c" | cut -d'.' -f1)
COND=$(echo "$DATA" | jq -r ".current.condition.text")

TEMP=$((TEMP + 0))

case "$COND" in
*Sunny* | *Clear*) WEATHER="☀️" ;;
"Partly cloudy") WEATHER="⛅" ;;
*Cloud* | *Overcast*) WEATHER="☁️" ;;
*Rain* | *Drizzle* | *rain*) WEATHER="🌧️" ;;
*Thunder* | *Storm*) WEATHER="⛈️" ;;
*Snow* | *snow*) WEATHER="❄️" ;;
*Fog* | *Mist* | *fog*) WEATHER="🌫️" ;;
*) WEATHER="?" ;;
esac

echo "{\"text\": \"$WEATHER ${TEMP}°C \", \"tooltip\": \"${CITY}: $TEMP°C, $COND\"}"
