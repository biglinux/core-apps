#!/bin/sh

# execute server
python app.py > /dev/null 2>&1 &
echo "Server running..."

sleep 1

# open window and show application
python window.py
echo "Window open..."

# stop server
wget -qO- "http://127.0.0.1:2222/shutdown" &> /dev/null
