#make slack-send-standard-notification NAME=jenkins-pipeline

slack-send-standard-notification: ### NAME=[notifcation template name]
	make slack-send-notification FILE=$(LIB_DIR)/slack/$(NAME).json

slack-send-notification: ### TODO: Change data to template with overlay of message BUILD NUMBER: $(BUILD_ID): STATUS FAIL etc- MANDATORY PROFILE=[name], GIT_TAG=this.GIT_TAG, FILE,SLACK_WEBHOOK_URL
	message=$$(make slack-render-template FILE=$(FILE))
	curl -X POST -H 'Content-type: application/json' --data "$$message" $(SLACK_WEBHOOK_URL)

slack-render-template: ### Reads text from file and replaces variables in template - mandatory: FILE
	make -s file-copy-and-replace SRC=$(FILE) DEST=$(TMP_DIR)/$(@).json > /dev/null 2>&1 && trap "{ rm -f $(TMP_DIR)/$(@).json; }" EXIT
	file=$$(cat $(TMP_DIR)/$(@).json)
	echo $$file

.SILENT: \
	slack-render-template
