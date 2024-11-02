# Задайте пути к директориям для загрузки файлов
$tempDir = "$env:TEMP\DownloadedFiles"  # Временная директория для загружаемых файлов
$downloadsDir = [System.IO.Path]::Combine($env:USERPROFILE, "Downloads")  # Папка Загрузки по умолчанию

# Создайте временную директорию, если её нет
if (-not (Test-Path $tempDir)) {
    New-Item -ItemType Directory -Path $tempDir
}

# URL к вашему файлу со списком
$url = "https://raw.githubusercontent.com/ChaseRuff/Ps1/main/filelist.txt"  # Укажите правильный путь

# Загрузите список файлов
$fileList = Invoke-RestMethod -Uri $url

# Создайте новый список файлов для CMD
$fileNames = @()
$i = 1
foreach ($file in $fileList) {
    $fileNames += "$i. $file"
    $i++
}

# Сформируйте команду для запуска CMD
$cmdCommand = "cmd.exe /k `"`"echo Введите номер файла для запуска`"; "
$cmdCommand += $fileNames -join '; '
$cmdCommand += "; set /p choice=Введите номер файла: "
$cmdCommand += "if %choice% lss $i (set /p saveChoice=Выберите, куда сохранить файл (1 - Temp, 2 - Загрузки): & if %saveChoice%==1 (set localDir=%tempDir%) else (set localDir=$downloadsDir); call %localDir%\%fileList[%choice%]%) else (echo Неверный номер файла & exit)"

# Откройте новый экземпляр CMD и выполните команду
Start-Process cmd.exe -ArgumentList "/c $cmdCommand"
