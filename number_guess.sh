#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read USERNAME
SANITIZED_USERNAME=$(echo "$USERNAME" | sed "s/'/''/g")

# Check if user exists
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$SANITIZED_USERNAME';")

if [[ -z $USER_ID ]]; then
  # New user
  $PSQL "INSERT INTO users(username) VALUES('$SANITIZED_USERNAME');" > /dev/null
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$SANITIZED_USERNAME';")
  echo "Welcome, $USERNAME! It looks like this is your first time here."
else
  # Returning user
  GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games WHERE user_id=$USER_ID;")
  BEST_GAME=$($PSQL "SELECT MIN(guesses) FROM games WHERE user_id=$USER_ID;")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

# Generate secret number 1..1000
SECRET=$(( RANDOM % 1000 + 1 ))

echo "Guess the secret number between 1 and 1000:"

GUESSES=0
while true; do
  read GUESS
  GUESSES=$(( GUESSES + 1 ))

  if [[ ! $GUESS =~ ^[0-9]+$ ]]; then
    echo "That is not an integer, guess again:"
    continue
  fi

  if (( GUESS < SECRET )); then
    echo "It's higher than that, guess again:"
  elif (( GUESS > SECRET )); then
    echo "It's lower than that, guess again:"
  else
    break
  fi
done

# Save game result
$PSQL "INSERT INTO games(user_id, guesses) VALUES($USER_ID, $GUESSES);" > /dev/null

echo "You guessed it in $GUESSES tries. The secret number was $SECRET. Nice job!"

