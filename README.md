# Email attachment workflows

This workflow will use the Direktiv SMTP listener to take the decomposed email (JSON objects) received from the SMTP listener, store the attachments in an Azure Storage container, store the location URLs in a database and re-compile the email and send it to recipients.

## Workflow overview

The workflow steps are as follow:
1. Receives an inbound email and decomposes it into JSON objects using the Direktiv SMTP listener (https://github.com/direktiv/direktiv-listeners/tree/main/smtp-receiver)
2. Stores the attachments as objects in Direktiv
3. Uploads the attachments as Blobs to Azure storage with the following information:
    - Storage account: `direktiv`
    - Container: `emails`
4. Writes to a database (MySQL) in AWS (the following URL: @emails.uid.region.rds.amazonaws.com:3306/direktiv)
    - Username: `admin`
    - Password: `password`
    - Database: `direktiv`
    - Table: `emails` (structure `create_time`, `update_time`, `from`, `to`, `subject`, `message`, `attachement_links`)
5. Creates an email template with all the details
6. Sends an email to the `To` recipients with the email template created above
7. Sends a Slack message 
8. Sends a Team message
9. To start the workflow, I have added 2 files to the GitHub repository you can use:
    - `sendemail.sh` which is a shell wrapper for the sendEmail.pl script (you can customise this).
    - `sendEmail.pl` which can send the email to the {<direktiv-url>}:2525 listener.

*You need the following components to run this workflow:*
- Ability to upload to an Azure Storage Container, with Azure Events configured to send to Direktiv namespace (https://docs.direktiv.io/events/cloud/azure/). Example screenshots have been included in the repository.
- The email attachments are uploaded to the `Storage accounts -> direktiv | Containers -> emails`.
 
 ## Variables

 - email-template.tpl: Mustache email template to create an HTML template with original message and new links

## Secrets

 - AZURE_USER, AZURE_PASSWORD, AZURE_TENANTID, AZURE_STORAGE_ACCOUNT: Azure credentials to access the Storage account and containers
 - SQL_USER, SQL_PASSWORD, SQL_ADDRESS: MySQL (or other) username and password
 - EMAIL_USER, EMAIL_PASSWORD: email acccess credentials
 - SLACK_URL: Slack channel URL
 - TEAMS_WEBHOOK_URL: Microsoft Teams application channel

## Namespace Services

 - None

## Input examples

Example input to the workflow for a decomposed email:

```json
{
  "smtp.message": {
    "data": {
      "attachments": [
        {
          "data": "base64encodedmessage",
          "name": "direktiv-overview.png",
          "type": "image/png"
        },
        {
          "data": "base64encodedmessage",
          "name": "image.png",
          "type": "image/png"
        }
      ],
      "from": "from@address.com",
      "message": "This email is an exmaple of how the attachments would be stripped. It has 2 images attached.\r\n",
      "subject": "Example of a stripped attachment email",
      "to": [
        "to1@address.com",
        "to2@address.com",
        "to3@address.com"
      ]
    },
    "id": "smtp-cloud-3308467094367886911",
    "source": "direktiv/listener/smtp",
    "specversion": "1.0",
    "traceparent": "00-26e4b1276acb31ec60c846dd6ca5504c-49b92df654e37b21-00",
    "type": "smtp.message"
  }
}
```

## External links:

 - Blog article: https://blog.direktiv.io/turn-your-code-into-a-serverless-api-748490acd470ß