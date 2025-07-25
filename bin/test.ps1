# Scoop bucket test script
param(
    [string]$AppName = ""
)

$ErrorActionPreference = "Stop"

# テスト対象のマニフェストファイルを取得
if ($AppName) {
    $manifests = @(Get-Item "./bucket/$AppName.json" -ErrorAction SilentlyContinue)
} else {
    $manifests = Get-ChildItem "./bucket" -Filter "*.json"
}

if ($manifests.Count -eq 0) {
    Write-Error "No manifest files found"
    exit 1
}

# 各マニフェストをテスト
foreach ($manifest in $manifests) {
    Write-Host "Testing $($manifest.Name)..." -ForegroundColor Green
    
    try {
        # JSONの妥当性チェック
        $content = Get-Content $manifest.FullName -Raw | ConvertFrom-Json
        
        # 必須フィールドのチェック
        $requiredFields = @("version", "description", "homepage", "license", "bin")
        foreach ($field in $requiredFields) {
            if (-not $content.$field) {
                throw "Missing required field: $field"
            }
        }
        
        # アーキテクチャのチェック
        if ($content.architecture) {
            foreach ($arch in $content.architecture.PSObject.Properties) {
                if (-not $arch.Value.url) {
                    throw "Missing URL for architecture: $($arch.Name)"
                }
                if (-not $arch.Value.hash) {
                    throw "Missing hash for architecture: $($arch.Name)"
                }
            }
        }
        
        Write-Host "✓ $($manifest.Name) is valid" -ForegroundColor Green
    }
    catch {
        Write-Error "✗ $($manifest.Name) validation failed: $_"
        exit 1
    }
}

Write-Host "`nAll tests passed!" -ForegroundColor Green