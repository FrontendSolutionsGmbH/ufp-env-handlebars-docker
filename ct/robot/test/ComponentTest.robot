*** Settings ***
Documentation     This test assumes that the docker-compose-service.yml stack is running and performs checks against the current configured environment variables to be present in the outputed pathes
Library           Collections
Library           RequestsLibrary

*** Variables ***
${SERVICE_NAME1}    ufp-env-handlebars
${SERVICE_PORT1}    3000
${SERVICE_NAME2}    ufp-env-handlebars2
${SERVICE_PORT2}    3000

*** Test Cases ***
Check Service 1 With Current ENV Config in Docker-Compose.yml
    [Documentation]    This test checks that configured env variables from docker-compose-service.yml are found in service 1
    [Tags]    critical
    Create Session    local    http://${SERVICE_NAME1}:${SERVICE_PORT1}
    ${resp}=    Get Request    local    /
    Should Be Equal As Strings    ${resp.status_code}    200
    Should Contain    ${resp.text}    MENU 3
    Should Contain    ${resp.text}    MENU 2
    Should Contain    ${resp.text}    UFP
    Should Contain    ${resp.text}    btn-primary
    Should Contain    ${resp.text}    btn-secondary
    Should Contain    ${resp.text}    github.com
    Should Contain    ${resp.text}    https://github.com
    Log    ${resp.text}

Check Service 1 Path 2 With Current ENV Config in Docker-Compose.yml
    [Documentation]    This test checks that the second sub folder file is exported and accessible as well
    [Tags]    critical
    Create Session    local    http://${SERVICE_NAME1}:${SERVICE_PORT1}
    ${resp}=    Get Request    local    /folder2
    Should Be Equal As Strings    ${resp.status_code}    200
    Should Contain    ${resp.text}    container-fluid
    Log    ${resp.text}

Check Service 2 With Current ENV Config in Docker-Compose.yml
    [Documentation]    This test checks that configured env variables from docker-compose-service.yml are found in service 2
    [Tags]    critical
    Create Session    local    http://${SERVICE_NAME2}:${SERVICE_PORT2}
    ${resp}=    Get Request    local    /
    Should Be Equal As Strings    ${resp.status_code}    200
    Should Contain    ${resp.text}    SERVICE 2
    Log    ${resp.text}
