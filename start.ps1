# Устанавливаем адрес репозитория
$githubUser = "ChaseRuff"
$repoName = "Ps1"
$baseUrl = "https://api.github.com/repos/$githubUser/$repoName/contents"

# Получаем содержимое репозитория
$response = Invoke-RestMethod -Uri $baseUrl -Headers @{"User-Agent" = "PowerShell"}

# Создаем хэш-таблицу для папок
$folders = @{}

# Обрабатываем все элементы в репозитории
foreach ($item in $response) {
    if ($item.type -eq "dir") {
        # Сохраняем название папки
        $folders[$item.name] = $item.url
    }
}

# Устанавливаем кодировку консоли для корректного отображения кириллицы
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Выводим список папок с их номерами
$folders.GetEnumerator() | ForEach-Object { 
    Write-Host "$($_.Key)"
}

# Запрашиваем у пользователя номер папки
$folderNumber = Read-Host "Введите номер папки для просмотра файлов"

# Получаем выбранную папку по номеру
$selectedFolder = $folders.Keys[$folderNumber - 1]

# Получаем содержимое выбранной папки
$folderUrl = $folders[$selectedFolder]
$folderResponse = Invoke-RestMethod -Uri $folderUrl -Headers @{"User-Agent" = "PowerShell"}

# Создаем хэш-таблицу для файлов в выбранной папке
$files = @{}

# Обрабатываем все элементы в выбранной папке
foreach ($item in $folderResponse) {
    if ($item.type -eq "file" -and $item.name.EndsWith(".txt")) {
        # Чтение текстового файла с указанием кодировки UTF-8
        $fileContent = Invoke-RestMethod -Uri $item.download_url -Headers @{"User-Agent" = "PowerShell"}
        $fileName = $item.name

        # Добавляем каждую строку файла как отдельный файл для скачивания
        $lines = $fileContent -split "`n"
        for ($i = 0; $i -lt $lines.Count; $i++) {
            $files["$fileName - $($i + 1): $($lines[$i].Trim())"] = $lines[$i].Trim()
        }
    }
}

# Выводим список файлов с их номерами
$files.GetEnumerator() | ForEach-Object { 
    Write-Host "$($_.Key)"
}

# Запрашиваем у пользователя номер файла
$fileNumber = Read-Host "Введите номер файла для загрузки"
$fileName = $files.Keys[$fileNumber - 1]
$fileUrl = $files[$fileName]

if ($fileUrl) {
    # Загрузка файла
    $tempPath = Join-Path $env:TEMP $fileUrl
    Invoke-WebRequest -Uri $fileUrl -OutFile $tempPath
    Write-Host "Файл загружен: $tempPath"
} else {
    Write-Host "Файл не найден."
}
