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

# Создайте новый список файлов
$fileNames = @()
$i = 1
foreach ($file in $fileList) {
    $fileNames += "$i. $file"
    $i++
}

# Отобразите список файлов
Write-Host "Доступные файлы:"
$fileNames | ForEach-Object { Write-Host $_ }

# Запросите номер файла для запуска
$choice = Read-Host "Введите номер файла"
if ($choice -gt 0 -and $choice -lt $i) {
    # Запросите, куда сохранить файл
    $saveChoice = Read-Host "Выберите, куда сохранить файл (1 - Temp, 2 - Загрузки)"
    
    # Определите директорию сохранения
    if ($saveChoice -eq "1") {
        $localDir = $tempDir
    } elseif ($saveChoice -eq "2") {
        $localDir = $downloadsDir
    } else {
        Write-Host "Неверный выбор сохранения."
        exit
    }

    # Загрузите файл
    $fileToDownload = $fileList[$choice - 1]  # Корректировка индекса
    $downloadUrl = "https://raw.githubusercontent.com/ChaseRuff/Ps1/main/$fileToDownload"  # URL к файлу
    $outputPath = Join-Path -Path $localDir -ChildPath $fileToDownload

    Invoke-WebRequest -Uri $downloadUrl -OutFile $outputPath

    # Запустите файл
    Start-Process -FilePath $outputPath
} else {
    Write-Host "Неверный номер файла."
}
