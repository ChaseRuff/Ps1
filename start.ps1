# Установка кодировки UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# URL файла со списком
$url = "https://raw.githubusercontent.com/ChaseRuff/Ps1/main/filelist.txt"  # URL файла со списком

# Задаем директорию для скачивания файлов
$localDir = "C:\MyDownloads"  # Укажите путь на нужную директорию

# Проверяем, существует ли директория, если нет — создаем
if (-not (Test-Path $localDir)) {
    New-Item -ItemType Directory -Path $localDir
}

# Скачиваем список файлов
$fileList = Invoke-RestMethod -Uri $url

# Отображаем список файлов
$i = 1
$fileDict = @{}
foreach ($file in $fileList) {
    $fileDict[$i] = $file
    Write-Host "$i. $file"
    $i++
}

# Запрашиваем номер файла для скачивания
$choice = Read-Host "Введите номер файла для скачивания"
if ($fileDict.ContainsKey([int]$choice)) {
    $fileToDownload = $fileDict[[int]$choice]
    
    # Удаляем недопустимые символы из имени файла
    $fileToDownload = [System.IO.Path]::GetFileName($fileToDownload)

    $downloadUrl = "https://raw.githubusercontent.com/ChaseRuff/Ps1/main/$fileToDownload"  # Получаем прямой путь
    $outputFile = "$localDir\$fileToDownload"

    try {
        # Скачиваем файл
        Invoke-WebRequest -Uri $downloadUrl -OutFile $outputFile
        
        # Проверяем, существует ли файл после скачивания
        if (Test-Path $outputFile) {
            # Запускаем файл
            Start-Process $outputFile
        } else {
            Write-Host "Ошибка: файл не был скачан."
        }
    } catch {
        Write-Host "Ошибка при скачивании файла: $_"
    }
} else {
    Write-Host "Некорректный номер файла."
}
