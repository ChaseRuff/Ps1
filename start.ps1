# ���������� ����� �����������
$githubUser = "ChaseRuff"
$repoName = "Ps1"
$baseUrl = "https://api.github.com/repos/$githubUser/$repoName/contents"

# �������� ���������� �����������
$response = Invoke-RestMethod -Uri $baseUrl -Headers @{"User-Agent" = "PowerShell"}

# ������� ���-������� ��� ������
$files = @{}

# ������������ ��� �������� � �����������
foreach ($item in $response) {
    if ($item.type -eq "file" -and $item.name.EndsWith(".txt")) {
        # ������ ��������� ����� � ��������� ���������
        $fileContent = Invoke-RestMethod -Uri $item.download_url -Headers @{"User-Agent" = "PowerShell"}
        $fileName = $item.name

        # ��������� ������ ������ ����� ��� ��������� ���� ��� ����������
        $lines = $fileContent -split "`n"
        for ($i = 0; $i -lt $lines.Count; $i++) {
            $files["$fileName - $($i + 1): $($lines[$i].Trim())"] = $lines[$i].Trim()
        }
    }
}

# ������������� ��������� ������� ��� ����������� ����������� ���������
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# ������� ������ ������ � �� ��������
$files.GetEnumerator() | ForEach-Object { 
    Write-Host "$($_.Key)"
}

# ����������� � ������������ ����� �����
$fileName = Read-Host "������� �������� ����� (� �������) ��� ��������"
$fileUrl = $files[$fileName]

if ($fileUrl) {
    # �������� �����
    $tempPath = Join-Path $env:TEMP $fileUrl
    Invoke-WebRequest -Uri $fileUrl -OutFile $tempPath
    Write-Host "���� ��������: $tempPath"
} else {
    Write-Host "���� �� ������."
}
