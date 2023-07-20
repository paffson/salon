#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

MAIN_MENU() {
  echo -e "\n~~~~~ MY SALON ~~~~~\n"
  if [[ $1 ]]
  then
  echo $1
  fi
  SERVICES=$($PSQL "select * from services")
  echo "$SERVICES" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done
  read SERVICE_ID_SELECTED
    if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  then
    MAIN_MENU "Invalid input or unknown case."
  else
  SERVICE_NAME=$($PSQL "select name from services where service_id = $SERVICE_ID_SELECTED")
  if [[ -z $SERVICE_NAME ]]
  then
    MAIN_MENU "Invalid input or unknown case."
  else
   GET_CUSTOMER_DATA $SERVICE_ID_SELECTED "$SERVICE_NAME"
   # echo "co sie dzieje"
  fi
  fi
}
GET_CUSTOMER_DATA() {
  echo "Give me your phone number: "
  read CUSTOMER_PHONE
  CUSTOMER_DATA=$($PSQL "select customer_id, name from customers where phone = '$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_DATA ]]
  then
    echo "Give me your name: "
    read CUSTOMER_NAME
    RESULT=$($PSQL "insert into customers(name, phone) values ('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
    echo "customer: $RESULT"
  fi
  CUSTOMER_DATA=$($PSQL "select customer_id, name from customers where phone = '$CUSTOMER_PHONE'")
  echo "Give me the time: "
  read SERVICE_TIME
  
  read CUSTOMER_ID BAR CUSTOMER_NAME <<< "$CUSTOMER_DATA"
  RESULT2=$($PSQL "insert into appointments(customer_id, service_id, time) values($CUSTOMER_ID, $1, '$SERVICE_TIME')")
  if [[ $RESULT2 == "INSERT 0 1" ]]
  then
   echo "I have put you down for a$2 at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
}
MAIN_MENU