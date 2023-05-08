#!/bin/bash

SMTP_ADDRESS=smtp.direktiv.io:2525

./sendEmail.pl -f "from@address.com" -t "to1@address.com" "to2@address.com" "to3@address.com" -u "Example of a stripped attachment email" -m "This email is an exmaple of how the attachments would be stripped. It has 2 images attached." -s "$SMTP_ADDRESS" -v -o message-content-type=text -o message-charset=utf-8 -a direktiv-overview.png image.png
