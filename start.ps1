# Установите адрес репозитория
$githubUser = "ChaseRuff"
$repoName = "Ps1"
$baseUrl = "https://api.github.com/repos/$githubUser/$repoName/contents"

# Получаем содержимое репозитория
$response = Invoke-RestMethod -Uri $baseUrl -Headers @{"User-Agent" = "PowerShell"}

# Создаем хэш-таблицу для текстовых файлов
$txtFiles = @{}
$folders = @{}

# Обрабатываем все элементы в репозитории
foreach ($item in $response) {
    if ($item.type -eq "file" -and $item.name.EndsWith(".txt")) {
        # Сохраняем названия файлов без расширения
        $fileNameWithoutExtension = [System.IO.Path]::GetFileNameWithoutExtension($item.name)
        $txtFiles[$fileNameWithoutExtension] = $item.download_url
    }
}

# Получаем содержимое нового текстового документа с папками
$foldersUrl = "https://raw.githubusercontent.com/ChaseRuff/Ps1/refs/heads/main/Папки.txt"
$foldersContent = Invoke-RestMethod -Uri $foldersUrl -Headers @{"User-Agent" = "PowerShell"}
$folders = $foldersContent -split "`n" | ForEach-Object { $_.Trim() }

# Устанавливаем кодировку консоли для корректного отображения кириллицы
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Выводим список папок с их номерами
$index = 1
foreach ($folder in $folders) {
    Write-Host "${index}: $folder"
    $index++
}

# Запрашиваем у пользователя номер папки для загрузки
$folderIndex = Read-Host "Введите номер папки для просмотра содержимого"
$selectedFolder = $folders[$folderIndex - 1]

# Выводим содержимое выбранной папки
Write-Host "Содержимое папки: $selectedFolder"
$selectedFileUrl = $txtFiles[$selectedFolder]

if ($selectedFileUrl) {
    # Чтение содержимого текстового файла
    $fileContent = Invoke-RestMethod -Uri $selectedFileUrl -Headers @{"User-Agent" = "PowerShell"}
    
    # Разделяем содержимое на строки и выводим с нумерацией
    $lines = $fileContent -split "`n"
    $numberedLines = @{}
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $numberedLines["$($i + 1): $($lines[$i].Trim())"] = $lines[$i].Trim()
    }

    # Выводим содержимое файла с нумерацией
    $numberedLines.GetEnumerator() | ForEach-Object { 
        Write-Host "$($_.Key)"
    }

    # Запрашиваем у пользователя номер строки для загрузки
    $lineNumber = Read-Host "Введите номер строки для скачивания файла"

    if ($lineNumber -gt 0 -and $lineNumber -le $lines.Count) {
        $selectedLine = $lines[$lineNumber - 1].Trim()
        Write-Host "Вы выбрали: $selectedLine"
        # Здесь можно добавить логику для загрузки выбранного файла, если он существует
    } else {
        Write-Host "Неверный номер строки."
    }
} else {
    Write-Host "Файл не найден."
}
