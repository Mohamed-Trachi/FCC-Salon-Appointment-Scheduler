#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"


echo -e "\n~~~~~ MY SALON ~~~~~"

echo -e "\nWelcome to My Salon, how can I help you?"
SERVICES_MENU() {
  $PSQL "select service_id, name from services" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo -e "$SERVICE_ID) $SERVICE_NAME"
  done
  read SERVICE_ID_SELECTED
  SERVICE_NAME=$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED")
  while [[ -z $SERVICE_NAME ]]
  do
    $PSQL "select service_id, name from services" | while read SERVICE_ID BAR SERVICE_NAME
    do
      echo -e "$SERVICE_ID) $SERVICE_NAME"
    done
    read SERVICE_ID_SELECTED
    SERVICE_NAME=$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED")
  done 
  echo -e "What's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')") 
  fi
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
  read SERVICE_TIME
  INSERT_APPOINTEMENT_RESULT=$($PSQL "INSERT INTO APPOINTMENTS(customer_id, service_id,time) VALUES('$CUSTOMER_ID', '$SERVICE_ID_SELECTED','$SERVICE_TIME')") 
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}

SERVICES_MENU