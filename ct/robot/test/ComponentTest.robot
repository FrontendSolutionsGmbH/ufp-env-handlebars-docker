*** Settings ***
Library	Collections
Library	RequestsLibrary

*** Variables ***
${SERVICE_NAME1}=  ufp-env-handlebars
${SERVICE_PORT1}=  3000
${SERVICE_NAME2}=  ufp-env-handlebars2
${SERVICE_PORT2}=  3000
*** Test Cases ***
Check Service 1 With Current ENV Config in Docker-Compose.yml
	Create Session	local1  http://${SERVICE_NAME1}:${SERVICE_PORT1}
	${resp}=	Get Request  local1  /
	Should Be Equal As Strings  ${resp.status_code}  200
	Should Contain  ${resp.text}  MENU 3
	Should Contain  ${resp.text}  MENU 2
	Should Contain  ${resp.text}  http://www.froso.de
	Should Contain  ${resp.text}  UFP.DE
	Should Contain  ${resp.text}  w3-blue
	Should Contain  ${resp.text}  github.com
	Should Contain  ${resp.text}  https://github.com
	Log to console  ${resp.text}


Check Service 2 With Current ENV Config in Docker-Compose.yml
	Create Session	local2  http://${SERVICE_NAME2}:${SERVICE_PORT2}
	${resp}=	Get Request  local2  /
	Should Be Equal As Strings  ${resp.status_code}  200
	Should Contain  ${resp.text}  SERVICE 2
	Log to console  ${resp.text}



