#!/usr/bin/env bash



echo " _______ _______ ______      _______ _______ ___ ___ "
echo "|   |   |    ___|   __ \    |    ___|    |  |   |   |"
echo "|   |   |    ___|    __/    |    ___|       |   |   |"
echo "|_______|___|   |___|       |_______|__|____|\_____/ "



echo "Executing Handlebars Render pass"
node handlebars


echo "Starting server"
node server/server
