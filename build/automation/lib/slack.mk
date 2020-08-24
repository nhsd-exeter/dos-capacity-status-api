slack-notification: # For local sending message to slack
	CONTENT=$$(make slack-read-template)
	echo $$CONTENT
	curl -X POST -H 'Content-type: application/json' --data "$$CONTENT" $(WEBHOOK_URL)

slack-send-notification: # TODO: Change data to template with overlay of message BUILD NUMBER: $(BUILD_ID): STATUS FAIL etc- MANDATORY PROFILE=[name], GIT_TAG=this.GIT_TAG
	aws=($$(make aws-assume-role-export-variables PROFILE=$(PROFILE) | cut -d '=' -f 2))
	export AWS_ACCESS_KEY_ID=$${aws[0]}
	export AWS_SECRET_ACCESS_KEY=$${aws[1]}
	export AWS_SESSION_TOKEN=$${aws[2]}
	webhook_url=$$(make aws-secret-get NAME=$(PROJECT_GROUP_SHORT)-$(PROJECT_NAME_SHORT)/deployment | jq --raw-output '.webhook_url')
	CONTENT=$$(make slack-read-template NEW_GIT_TAG=$(GIT_TAG))
	curl -X POST -H 'Content-type: application/json' --data "$$CONTENT" $$webhook_url

slack-read-template: # Reads text from file and replaces variables in template
	make -s file-replace-variables FILE=build/Slack-template.txt
	file=$$(cat build/Slack-template.txt)
	echo $$file

.SILENT: \
	slack-formatter \
	slack-read-template \
