function DownloadAndRun {
    param (
        [string]$url = "https://raw.githubusercontent.com/ChaseRuff/Ps1/main/filelist.txt"  # URL к файлу со списком
    )

    # Задайте путь к директории для загрузки файлов
    $localDir = "C:\MyDownloads"  # Измените на вашу директорию

    # Создайте директорию, если её нет
    if (-not (Test-Path $localDir)) {
        New-Item -ItemType Directory -Path $localDir
    }

    # Загрузите список файлов
    $fileList = Invoke-RestMethod -Uri $url

    # Отобразите список файлов
    $i = 1
    $fileDict = @{}
    foreach ($file in $fileList) {
        $fileDict[$i] = $file
        Write-Host "$i. $file"
        $i++
    }

    # Запросите номер файла для запуска
    $choice = Read-Host "Введите номер файла для запуска"
    if ($fileDict.ContainsKey([int]$choice)) {
        $fileToDownload = $fileDict[[int]$choice]
        $downloadUrl = "https://raw.githubusercontent.com/ChaseRuff/Ps1/main/$fileToDownload"  # Укажите правильный путь
        Invoke-WebRequest -Uri $downloadUrl -OutFile "$localDir\$fileToDownload"

        # Запустите файл
        Start-Process "$localDir\$fileToDownload"
    } else {
        Write-Host "Неверный номер файла."
    }
}
