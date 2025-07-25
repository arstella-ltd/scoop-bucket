# Auto PR creation script for Scoop bucket updates
param(
    [Parameter(Mandatory=$true)]
    [string]$AppName,
    
    [Parameter(Mandatory=$true)]
    [string]$Version,
    
    [string]$Branch = "update-$AppName-$Version"
)

$ErrorActionPreference = "Stop"

# ブランチの作成
git checkout -b $Branch

# マニフェストファイルのパス
$manifestPath = "./bucket/$AppName.json"

if (-not (Test-Path $manifestPath)) {
    Write-Error "Manifest file not found: $manifestPath"
    exit 1
}

# バージョンの更新
$content = Get-Content $manifestPath -Raw
$content = $content -replace '"version":\s*"[^"]*"', "`"version`": `"$Version`""

# ファイルの保存
$content | Set-Content $manifestPath -NoNewline

# コミット
git add $manifestPath
git commit -m "Update $AppName to version $Version"

# プッシュ
git push origin $Branch

Write-Host "Branch '$Branch' has been created and pushed." -ForegroundColor Green
Write-Host "Please create a pull request on GitHub." -ForegroundColor Yellow