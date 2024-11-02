# launcher.ps1

# Загружаем и запускаем меню в новой консоли PowerShell
Start-Process powershell -ArgumentList "-NoExit", "-Command", "irm 'https://ссылка_на_ваш_скрипт/menu.ps1' | iex"
