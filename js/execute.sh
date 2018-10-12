#!/usr/bin/env bash


echo ""

echo " _______ _______ ______      _______ _______ ___ ___ "
echo "|   |   |    ___|   __ \    |    ___|    |  |   |   |"
echo "|   |   |    ___|    __/    |    ___|       |   |   |"
echo "|_______|___|   |___|       |_______|__|____|\_____/ "

echo ""


echo "Executing Handlebars Render pass"



node handlebars


echo "Starting server"
node server/server
