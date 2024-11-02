# Установите адрес репозитория
$githubUser = "ChaseRuff"
$repoName = "Ps1"
$baseUrl = "https://api.github.com/repos/$githubUser/$repoName/contents"

# Получаем содержимое репозитория
$response = Invoke-RestMethod -Uri $baseUrl -Headers @{"User-Agent" = "PowerShell"}

# Создаем хэш-таблицу для текстовых файлов
$txtFiles = @{}

# Обрабатываем все элементы в репозитории
foreach ($item in $response) {
    if ($item.type -eq "file" -and $item.name.EndsWith(".txt")) {
        # Сохраняем названия файлов без расширения
        $fileNameWithoutExtension = [System.IO.Path]::GetFileNameWithoutExtension($item.name)
        $txtFiles[$fileNameWithoutExtension] = $item.download_url
    }
}

# Устанавливаем кодировку консоли для корректного отображения кириллицы
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Выводим список текстовых файлов с их номерами
$index = 1
foreach ($fileName in $txtFiles.Keys) {
    Write-Host ($index.ToString() + ": " + $fileName)  # Используем конкатенацию строк
    $index++
}

# Запрашиваем у пользователя номер текстового файла для загрузки
$fileIndex = Read-Host "Введите номер текстового файла для загрузки"
$selectedFileName = $txtFiles.Keys[$fileIndex - 1]
$fileUrl = $txtFiles[$selectedFileName]

if ($fileUrl) {
    # Чтение содержимого текстового файла
    $fileContent = Invoke-RestMethod -Uri $fileUrl -Headers @{"User-Agent" = "PowerShell"}
    
    # Разделяем содержимое на строки и выводим с нумерацией
    $lines = $fileContent -split "`n"
    $numberedLines = @{}
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $numberedLines["$($i + 1): $($lines[$i].Trim())"] = $lines[$i].Trim()
    }

    # Выводим содержимое файла с нумерацией
    Write-Host "`nСодержимое файла '$selectedFileName':"
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
