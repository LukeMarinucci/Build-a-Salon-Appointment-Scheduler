#! /bin/bash

PSQL="psql --username=freecodecamp dbname=salon --tuples-only -c"

function selection() {

if [[ $1 ]]
then
  echo -e "\n$1"
fi

serviceQuery=$($PSQL "SELECT * from services")

echo -e "\nPlease select a service number:"

echo "$serviceQuery" | while read ID BAR NAME
do
echo "$ID) $NAME"
done

read SERVICE_ID_SELECTED

if [[ $SERVICE_ID_SELECTED > 3 || $SERVICE_ID_SELECTED <  1 ]]
then
  selection "This service does not exist"
else
  echo -e "\nWhats your number"?
  read CUSTOMER_PHONE
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  NUMBERCHECK=$($PSQL "SELECT phone FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  if [[ -z $NUMBERCHECK ]]
  then
    echo -e "\nI don't have you in our system, what's your name?"
    read CUSTOMER_NAME
    echo -e  "\nAnd what time would you like the appointment?"
    read SERVICE_TIME
    INSERTCUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name = '$CUSTOMER_NAME'")
    INSERTAPPOINTMENT=$($PSQL "INSERT INTO appointments(service_id, time, customer_id) VALUES($SERVICE_ID_SELECTED, '$SERVICE_TIME', $CUSTOMER_ID)")
    echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  else
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name = '$(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')'")
    echo $CUSTOMER_ID
    echo -e "\nWhat time would you like your$SERVICE_NAME,$CUSTOMER_NAME?"
    read SERVICE_TIME
    INSERTAPPOINTMENT=$($PSQL "INSERT INTO appointments(service_id, time, customer_id) VALUES($SERVICE_ID_SELECTED, '$SERVICE_TIME', $CUSTOMER_ID)")
    echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME,$CUSTOMER_NAME."
  fi
fi

}

selection
