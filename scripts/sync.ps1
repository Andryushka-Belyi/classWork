param (
    [string]$SourceRepo,
    [string]$TargetRepo
)

Write-Host "🔍 Проверка путей..."

if (!(Test-Path $SourceRepo) -or !(Test-Path $TargetRepo)) {
    Write-Host "❌ Один из путей не существует"
    exit
}

if ($SourceRepo -eq $TargetRepo) {
    Write-Host "❌ Пути совпадают"
    exit
}

Write-Host "📥 git pull..."
Set-Location $SourceRepo
git pull

Write-Host "🧹 Очистка target (кроме .git)..."

Get-ChildItem -Path $TargetRepo -Force | Where-Object {
    $_.Name -ne ".git"
} | Remove-Item -Recurse -Force

Write-Host "📂 Копирование..."

Copy-Item -Path "$SourceRepo\*" -Destination $TargetRepo -Recurse -Force

Write-Host "🧽 Удаление .git (если скопировался)..."
Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$TargetRepo\.git"

Write-Host "✅ Синхронизация завершена"

$push = Read-Host "🚀 Сделать git push? (y/n)"

if ($push -eq "y") {
    Set-Location $TargetRepo
    git add .
    git commit -m "Full sync overwrite"
    git push
}

Write-Host "🎉 Готово"