# Открытый доступ в Интернет
$пользователь github = "ЧейзRUFF"
$имя_репо = "P.S.1"
$базовый URL-адрес = "https://api.github.com/repos/$пользователь github/$имя_репо/contents"

# Попытка снимка
$ответ = Invoke-RestMethod -Uri $baseUrl -Headers @{"Пользовательский агент" = "PowerShell"}

# Снимок õýø-òàáëèto äëÿ ôàéëîâ
$Файлы = @{}

# Появился новый в мире
foreach ($также в $response) {
    если ($item.type -eq "файл" -и $item.name.EndsWith(".текст")) {
        # ×это универсальный вариант с возможностью запуска
        $fileContent = Invoke-RestMethod -Uri $item.download_url -Headers @{"Пользовательский агент" = "PowerShell"}
        $имя_файла = $item.name

        # Дорогие друзья, но это не так.
        $линии = $fileContent -split "`н"
        для ($я = 0; $я -lt $lines.Count; $я++) {
            $Файлы["$Имя файла - $($я + 1): $($линии[$i].Обрезать())"] = $линии[$i].Обрезать()
        }
    }
}

# Особый набор инструментов и комплектующих для ремонта
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Встроенная версия с ее помощью
$файлы.GetEnumerator() | ForEach-Объект { 
    Write-Host "$($_.Ключ)"
}

# Зарегистрироваться на сайте
$имя_файла = Хост чтения "Варёаедьё неназванное (с наименованием) и замороженное"
$fileUrl = $files[$fileName]

если ($fileUrl) {
    # Запрет на продажу
    $tempPath = Путь к соединению $env:TEMP $fileUrl
    Invoke-WebRequest -Uri $fileUrl -OutFile $tempPath
    Write-Host "У нас есть: $темпПат"
} Еще {
    Write-Host "Тын и имьяри."
}
