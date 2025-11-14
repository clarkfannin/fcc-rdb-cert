#! /bin/bash

PSQL='psql --username=freecodecamp --dbname=salon -t -c'

MAIN_MENU() {
if [[ $1 ]]
then
echo -e "\n$1\n"
fi
SERVICE_ID_RESULT=$($PSQL "SELECT service_id, name FROM services")
echo "$SERVICE_ID_RESULT" | while read SERVICE_ID BAR NAME
do
if [[ "$SERVICE_ID" =~ ^[0-9]+$ ]]; then
echo "$SERVICE_ID) $NAME"
fi
done
}
MAIN_MENU "Welcome to the salon! Choose a service:"
read SERVICE_ID_SELECTED
SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
if [[ -z $SERVICE_NAME ]]
then
MAIN_MENU "Please make a valid choice."
else
echo -e "\nPlease enter your phone number:"
read CUSTOMER_PHONE
EXISTING_CUSTOMER=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
if [[ -z $EXISTING_CUSTOMER ]]
then
    echo -e "\nNew customer! Please enter your name:"
    read CUSTOMER_NAME
    CUSTOMER_INSERT_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
else
    CUSTOMER_NAME=$EXISTING_CUSTOMER
fi
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
echo -e "\nPlease enter a time for your appointment:"
read SERVICE_TIME
APPOINTMENT_INSERT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
fi