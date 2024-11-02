# Установите адрес репозитория
$githubUser = "ChaseRuff"
$repoName = "Ps1"
$baseUrl = "https://api.github.com/repos/$githubUser/$repoName/contents"

# Получаем содержимое репозитория
$response = Invoke-RestMethod -Uri $baseUrl -Headers @{"User-Agent" = "PowerShell"}

# Создаем хэш-таблицу для файлов
$files = @{}

# Обрабатываем все элементы в репозитории
foreach ($item in $response) {
    if ($item.type -eq "file" -and $item.name.EndsWith(".txt")) {
        # Читаем текстовые файлы с указанием кодировки
        $fileContent = Invoke-RestMethod -Uri $item.download_url -Headers @{"User-Agent" = "PowerShell"}
        $fileName = $item.name

        # Добавляем каждую строку файла как отдельный файл для скачивания
        $lines = $fileContent -split "`n"
        for ($i = 0; $i -lt $lines.Count; $i++) {
            $files["$fileName - $($i + 1): $($lines[$i].Trim())"] = $lines[$i].Trim()
        }
    }
}

# Устанавливаем кодировку консоли для корректного отображения кириллицы
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Выводим список файлов с их номерами
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
