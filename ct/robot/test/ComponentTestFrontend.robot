*** Settings ***
Documentation     This test assumes that the docker-compose-service.yml stack is running and performs checks against the current configured environment variables to be present in the outputed pathes
Library           Collections
Library           SeleniumLibrary
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
    Open Browser    http://${SERVICE_NAME1}:${SERVICE_PORT1}    Chrome
    Wait Until Page Contains    UFP
    Capture Page Screenshot    ScreenshotFrontend1.png

Check Service 2 With Current ENV Config in Docker-Compose.yml
    [Documentation]    This test checks that configured env variables from docker-compose-service.yml are found in service 1
    [Tags]    critical
    Open Browser    http://${SERVICE_NAME2}:${SERVICE_PORT2}    Chrome
    Wait Until Page Contains    UFP
    Capture Page Screenshot    ScreenshotFrontend2.png
