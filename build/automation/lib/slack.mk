# TODO: Slack
slack-notification: #Mandatory CONTENT=json WEBHOOK_URL=slack url
	curl -X POST -H 'Content-type: application/json' --data $(CONTENT) $(WEBHOOK_URL)
