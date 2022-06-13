#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

MAIN_MENU() {
if [[ $1 ]]
then
 echo -e "\n$1"
fi

echo -e "\n~~~ Welcome to the Salon Appointment Scheduler ~~~\n"
echo -e "\nMain Menu\n"
echo -e "\n1) Basic Cut\n2) Shampoo and Condition\n3) Beard Trim\n4) Exit"
read SERVICE_ID_SELECTED
echo $SERVICE_ID_SELECTED
if [[ $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]] && [[ $SERVICE_ID_SELECTED -lt 5 ]] && [[ $SERVICE_ID_SELECTED -gt 0 ]]
then
  if [[ $SERVICE_ID_SELECTED == 4 ]]
  then
    EXIT
  fi
  #SCHEDULE_APPOINTMENT
  # Input phone number and check if they are a customer
  echo -e "\nPlease enter your phone number."
  read CUSTOMER_PHONE
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  # If they are not a customer
  if [[ -z $CUSTOMER_ID ]]
    # User enters Name
  then
    echo -e "\nWe do not have you listed as a customer. What is your name?"
    read CUSTOMER_NAME
    # Enter user into system
    NAME_INSERTED=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  else
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  fi
  # Prompt user for appointment time
  echo -e "\nWhat time would you like to schedule your appointment?"
  read SERVICE_TIME
  # Enter all data into appointment table
  SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  APPOINTMENT_SCHEDULED=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  echo -e "\nI have put you down for a$SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
else
  MAIN_MENU "Please enter a valid option."
fi
}

EXIT() {
  echo -e "\nThank you for stopping in.\n"
}

MAIN_MENU