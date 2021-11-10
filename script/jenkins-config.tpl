    export HAL_COMMAND='hal --daemon-endpoint http://spinnaker-spinnaker-halyard:8064'
    # echo "START"
    cd
   
    wget https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
    chmod +x jq-linux64
    mv jq-linux64 jq

    _jenkinsPw="${jenkinsPassword}"
    _jenkinsCrumb=$(curl -s --cookie-jar /tmp/cookies -u admin:$_jenkinsPw http://jenkins-insecure.${dns_zone}/crumbIssuer/api/json | ./jq -r ".crumb")
    _apiToken=$(curl -sX POST -H "Jenkins-Crumb:$_jenkinsCrumb" --cookie /tmp/cookies http://jenkins-insecure.${dns_zone}/me/descriptorByName/jenkins.security.ApiTokenProperty/generateNewToken --user admin:$_jenkinsPw | ./jq -r ".data.tokenValue")
    
    $HAL_COMMAND config ci jenkins enable
    $HAL_COMMAND config ci jenkins master add k8s-jenkins --address http://jenkins-insecure.${dns_zone} --username admin --password $_apiToken --no-validate
    $HAL_COMMAND config artifact github enable
    $HAL_COMMAND deploy apply

    # echo "-----"
    # echo $_jenkinsPw
    # echo $_jenkinsCrumb
    # echo $_apiToken
    # echo "-----"

    # echo "DONE"
  