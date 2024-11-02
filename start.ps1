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
    $downloadUrl = "https://raw.githubusercontent.com/ChaseRuff/Ps1/main/$fileToDownload"  # Получаем прямой путь
    Invoke-WebRequest -Uri $downloadUrl -OutFile "$localDir\$fileToDownload"

    # Запускаем файл
    Start-Process "$localDir\$fileToDownload"
} else {
    Write-Host "Некорректный номер файла."
}
