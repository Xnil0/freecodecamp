#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

$PSQL "TRUNCATE TABLE games, teams"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # Skip first line.
  if [[ $YEAR != 'year' ]]
  then
    # Insert Winner in teams table
    COUNT=$($PSQL "SELECT COUNT(*) FROM teams WHERE name = '$WINNER'")
    if [[ $COUNT -ne 1 ]]
    then
      $PSQL "INSERT INTO teams (name) VALUES ('$WINNER')"
    fi

    # Insert Opponent in teams table
    COUNT=$($PSQL "SELECT COUNT(*) FROM teams WHERE name = '$OPPONENT'")
    if [[ $COUNT -ne 1 ]]
    then
      $PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT')"
    fi

    # Get Winner and Opponent IDs from teams table
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")

    # Insert Game in games table
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games (winner_id, opponent_id, year, round, winner_goals, opponent_goals) VALUES ($WINNER_ID, $OPPONENT_ID, $YEAR, '$ROUND', $WINNER_GOALS, $OPPONENT_GOALS)")
  fi
done