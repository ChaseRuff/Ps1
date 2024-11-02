$url = "https://raw.githubusercontent.com/ChaseRuff/Ps1/main/filelist.txt"  # URL к файлу со списком
$localDir = "C:\MyDownloads"  # Измените на вашу директорию
if (-not (Test-Path $localDir)) {
    New-Item -ItemType Directory -Path $localDir
}
$fileList = Invoke-RestMethod -Uri $url
$i = 1
$fileDict = @{}
foreach ($file in $fileList) {
    $fileDict[$i] = $file
    Write-Host "$i. $file"
    $i++
}
$choice = Read-Host "Введите номер файла для запуска"
if ($fileDict.ContainsKey([int]$choice)) {
    $fileToDownload = $fileDict[[int]$choice]
    $downloadUrl = "https://raw.githubusercontent.com/ChaseRuff/Ps1/main/$fileToDownload"
    Invoke-WebRequest -Uri $downloadUrl -OutFile "$localDir\$fileToDownload"
    Start-Process "$localDir\$fileToDownload"
} else {
    Write-Host "Неверный номер файла."
}
