@echo off
echo Starting local web server for Flipbook Reader...
start http://localhost:3000/wordpress.html
npx serve -l 3000
pause
