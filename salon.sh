#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "\nWelcome to My Salon, how can I help you?\n"

GET_CUSTOMER_INFO(){
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  
  # if doesn't exist
  CHECK_CUSTOMER_PHONE=$($PSQL "SELECT phone FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  if [[ -z $CHECK_CUSTOMER_PHONE ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    
    # insert name and number into database
    NAME_PHONE=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
    SELECTED_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID")
    echo -e "\nWhat time would you like your $SELECTED_SERVICE, $CUSTOMER_NAME?"
    
    # SET A TIME
    read SERVICE_TIME
    
    # INSERT APPOINTMENT
    GET_CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    SET_CUSTOMER_DATA=$($PSQL "INSERT INTO appointments(time, customer_id, service_id) VALUES('$SERVICE_TIME', '$GET_CUSTOMER_ID', '$SERVICE_ID')")
    echo -e "\nI have put you down for a $SELECTED_SERVICE at $SERVICE_TIME, $CUSTOMER_NAME.\n"
    
  
  else
    # which service was selected
    SELECTED_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID")
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    echo -e "\nWhat time would you like your $SELECTED_SERVICE, $CUSTOMER_NAME?"
    
    # SET A TIME
    read SERVICE_TIME
    
    # INSERT APPOINTMENT
    GET_CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    SET_CUSTOMER_DATA=$($PSQL "INSERT INTO appointments(time, customer_id, service_id) VALUES('$SERVICE_TIME', '$GET_CUSTOMER_ID', '$SERVICE_ID')")
    echo -e "\nI have put you down for a $SELECTED_SERVICE at $SERVICE_TIME, $CUSTOMER_NAME.\n"
  fi

}

MENU(){
# display services
SERVICES=$($PSQL "SELECT * FROM services")
echo "$SERVICES" | while read ID BAR NAME
do
  echo "$ID) $NAME"
done

# read customer input
read SERVICE_ID_SELECTED
SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE service_id=$SERVICE_ID_SELECTED")


#if doesn't exist
if [[ -z "$SERVICE_ID" ]]
then
  echo -e "\nI could not find that service. What would you like today?"
  RETURN_TO_MENU
else
# customer info
  GET_CUSTOMER_INFO
fi
}

RETURN_TO_MENU(){
  MENU
}
MENU