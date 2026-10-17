@echo off
echo Starting local web server for Flipbook Viewer...
start http://localhost:3000/index.html
npx serve -l 3000
pause
