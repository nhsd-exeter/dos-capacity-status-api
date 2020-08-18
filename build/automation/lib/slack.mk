# TODO: Slack
slack-notification: #Mandatory CONTENT=json WEBHOOK_URL=slack url
	curl -X POST -H 'Content-type: application/json' --data $(CONTENT) $(WEBHOOK_URL)

slack-send-notification: # TODO: Change data to template with overlay of message BUILD NUMBER: $(BUILD_ID): STATUS FAIL etc
	aws=($$(make aws-assume-role-export-variables PROFILE=dev | cut -d '=' -f 2))
	export AWS_ACCESS_KEY_ID=$${aws[0]}
	export AWS_SECRET_ACCESS_KEY=$${aws[1]}
	export AWS_SESSION_TOKEN=$${aws[2]}
	webhook_url=$$(make aws-secret-get NAME=$(PROJECT_GROUP_SHORT)-$(PROJECT_NAME_SHORT)/deployment | jq --raw-output '.webhook_url')
	curl -X POST -H 'Content-type: application/json' --data '{"text": "hello"}' $$webhook_url
