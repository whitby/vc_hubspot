vc_hubspot
==========

Checks [Veracross](http://www.veracross.com/) for the most recent changes and sends notifications to Slack.
The script is containerized using Docker and runs hourly via cron.

Credentials are read from the config.yaml file.

TODO:
* send latest changes to contacts using HubSpot API


# Cron Job

```5 * * * * docker run -i -t --rm --name vc_hubspot vc_hubspot```

# Docker Build
```docker build -t vc_hubspot . ```
