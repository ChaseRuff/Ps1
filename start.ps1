# ��������� ��������� UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# URL ����� �� �������
$url = "https://raw.githubusercontent.com/ChaseRuff/Ps1/main/filelist.txt"  # URL ����� �� �������

# ������ ���������� ��� ���������� ������
$localDir = "C:\MyDownloads"  # ������� ���� �� ������ ����������

# ���������, ���������� �� ����������, ���� ��� � �������
if (-not (Test-Path $localDir)) {
    New-Item -ItemType Directory -Path $localDir
}

# ��������� ������ ������
$fileList = Invoke-RestMethod -Uri $url

# ���������� ������ ������
$i = 1
$fileDict = @{}
foreach ($file in $fileList) {
    $fileDict[$i] = $file
    Write-Host "$i. $file"
    $i++
}

# ����������� ����� ����� ��� ����������
$choice = Read-Host "������� ����� ����� ��� ����������"
if ($fileDict.ContainsKey([int]$choice)) {
    $fileToDownload = $fileDict[[int]$choice]
    
    # ������� ������������ ������� �� ����� �����
    $fileToDownload = [System.IO.Path]::GetFileName($fileToDownload)

    $downloadUrl = "https://raw.githubusercontent.com/ChaseRuff/Ps1/main/$fileToDownload"  # �������� ������ ����
    $outputFile = "$localDir\$fileToDownload"

    try {
        # ��������� ����
        Invoke-WebRequest -Uri $downloadUrl -OutFile $outputFile
        
        # ���������, ���������� �� ���� ����� ����������
        if (Test-Path $outputFile) {
            # ��������� ����
            Start-Process $outputFile
        } else {
            Write-Host "������: ���� �� ��� ������."
        }
    } catch {
        Write-Host "������ ��� ���������� �����: $_"
    }
} else {
    Write-Host "������������ ����� �����."
}
