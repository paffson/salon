#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

MAIN_MENU() {
  SERVICES=$($PSQL "select * from services")
  echo "$SERVICES" | while read SERVICE_ID BAR NAME
  do
    echo -e "$SERVICE_ID) $NAME"

  done
  read SERVICE_ID_SELECTED
  SERVICE_ID=$($PSQL "select service_id from services where service_id = $SERVICE_ID_SELECTED")
  if [[ -z $SERVICE_ID ]]
  then
    MAIN_MENU "Invalid input or unknown case."
  else
    GET_CUSTOMER_DATA $SERVICE_ID
  fi
}
GET_CUSTOMER_DATA() {
  read -p "Give me your phone number:" CUSTOMER_PHONE
  CUSTOMER_DATA=$($PSQL "select customer_id, name from customers where phone = '$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_DATA ]]
  then
    read -p "Give me your name:" CUSTOMER_NAME
    echo $($PSQL "insert into customers(name, phone) values ('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
  fi
  CUSTOMER_DATA=$($PSQL "select customer_id, name from customers where phone = '$CUSTOMER_PHONE'")
  read -p "Give me the time:" SERVICE_TIME
  
  echo "$CUSTOMER_DATA" 
  #| read CUSTOMER_ID BAR CUSTOMER_NAME
  echo $CUSTOMER_NAME
  #echo $($PSQL "insert into appointments(customer_id, service_id, time" values($CUSTOMER_ID, $1, '$SERVICE_TIME'))
}
MAIN_MENU