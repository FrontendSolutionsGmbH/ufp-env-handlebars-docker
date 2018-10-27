*** Settings ***
Documentation     This test assumes that the docker-compose-service.yml stack is running and performs checks against the current configured environment variables to be present in the outputed pathes
Library           Collections
Library           SeleniumLibrary
Library           RequestsLibrary

*** Variables ***
${SERVICE_NAME1}    development-overview
${SERVICE_PORT1}    3000

*** Test Cases ***
Check Localhost:8080 Is Working
    [Documentation]    This test checks that configured env variables from docker-compose-service.yml are found in service 1
    [Tags]    critical
    Open Browser    http://${SERVICE_NAME1}:${SERVICE_PORT1}    Chrome
    Wait Until Page Contains    Ufp-Env-Handlebars-Docker
    Capture Page Screenshot    ScreenshotDebug.png
