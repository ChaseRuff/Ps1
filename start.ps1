# Устанавливаем адрес репозитория
$githubUser = "ChaseRuff"
$repoName = "Ps1"
$baseUrl = "https://api.github.com/repos/$githubUser/$repoName/contents"

# Получаем содержимое репозитория
$response = Invoke-RestMethod -Uri $baseUrl -Headers @{"User-Agent" = "PowerShell"}

# Получаем содержимое файла "Папки.txt"
$foldersUrl = "https://raw.githubusercontent.com/ChaseRuff/Ps1/refs/heads/main/Папки.txt"
$foldersContent = Invoke-RestMethod -Uri $foldersUrl -Headers @{"User-Agent" = "PowerShell"}

# Разделяем содержимое на строки для папок
$folders = $foldersContent -split "`n"

# Устанавливаем кодировку консоли для корректного отображения кириллицы
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Выводим список папок с их номерами
$folders | ForEach-Object { 
    Write-Host "$($_)"
}

# Запрашиваем у пользователя название папки
$selectedFolderName = Read-Host "Введите название папки для загрузки"

# Получаем содержимое выбранной папки
$files = @{}
foreach ($item in $response) {
    if ($item.type -eq "file" -and $item.name.EndsWith(".txt")) {
        # Чтение текстового файла
        $fileContent = Invoke-RestMethod -Uri $item.download_url -Headers @{"User-Agent" = "PowerShell"}
        if ($item.name -like "$selectedFolderName*") { # Проверка, соответствует ли имя папки
            $fileName = $item.name

            # Добавляем каждую строку файла как отдельный файл для скачивания
            $lines = $fileContent -split "`n"
            for ($i = 0; $i -lt $lines.Count; $i++) {
                $files["$fileName - $($i + 1): $($lines[$i].Trim())"] = $lines[$i].Trim()
            }
        }
    }
}

# Выводим список файлов в выбранной папке с их номерами
$files.GetEnumerator() | ForEach-Object { 
    Write-Host "$($_.Key)"
}

# Запрашиваем у пользователя номер файла
$fileName = Read-Host "Введите название файла (с номером) для загрузки"
$fileUrl = $files[$fileName]

if ($fileUrl) {
    # Загрузка файла
    $tempPath = Join-Path $env:TEMP $fileUrl
    Invoke-WebRequest -Uri $fileUrl -OutFile $tempPath
    Write-Host "Файл загружен: $tempPath"
} else {
    Write-Host "Файл не найден."
}
