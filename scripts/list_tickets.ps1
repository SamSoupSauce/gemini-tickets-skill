<#
.SYNOPSIS
Helper utility for the 'tickets' school skill.
Lists, validates, and manages tickets in the tickets/ directory.
#>
param(
    [switch]$Init
)

$current = (Get-Location).Path
$ticketsDir = Join-Path $current "tickets"

if ($Init) {
    if (-not (Test-Path $ticketsDir)) {
        New-Item -ItemType Directory -Path $ticketsDir -Force | Out-Null
        Write-Host "Created tickets directory at: $ticketsDir" -ForegroundColor Green
    }
}

if (-not (Test-Path $ticketsDir)) {
    Write-Host "Tickets directory not found: $ticketsDir" -ForegroundColor Red
    Write-Host "Run with -Init to create it." -ForegroundColor Yellow
    exit 1
}

$files = Get-ChildItem -Path $ticketsDir -Filter "*.md" | Sort-Object Name
$pending = @()
$completed = @()

foreach ($f in $files) {
    if ($f.Name -match '^(\d{4})-([a-z0-9-]+)\.complete\.md$') {
        $completed += [PSCustomObject]@{
            Number = [int]$matches[1]
            Slug   = $matches[2]
            Name   = $f.Name
            Path   = $f.FullName
        }
    } elseif ($f.Name -match '^(\d{4})-([a-z0-9-]+)\.md$') {
        $pending += [PSCustomObject]@{
            Number = [int]$matches[1]
            Slug   = $matches[2]
            Name   = $f.Name
            Path   = $f.FullName
        }
    }
}

Write-Host "=== Tickets in $ticketsDir ===" -ForegroundColor Cyan
Write-Host "Total: $($pending.Count + $completed.Count) (Pending: $($pending.Count), Completed: $($completed.Count))`n"

if ($completed.Count -gt 0) {
    Write-Host "[Completed Tickets]" -ForegroundColor DarkGreen
    foreach ($t in ($completed | Sort-Object Number)) {
        Write-Host "  [x] $(('{0:D4}' -f $t.Number))-$($t.Slug) ($($t.Name))" -ForegroundColor DarkGreen
    }
    Write-Host ""
}

if ($pending.Count -gt 0) {
    Write-Host "[Pending Tickets]" -ForegroundColor Yellow
    $first = $true
    foreach ($t in ($pending | Sort-Object Number)) {
        $marker = if ($first) { "-->" } else { "   " }
        $color = if ($first) { "Cyan" } else { "Yellow" }
        Write-Host "  $marker $(('{0:D4}' -f $t.Number))-$($t.Slug) ($($t.Name))" -ForegroundColor $color
        $first = $false
    }
    $next = ($pending | Sort-Object Number)[0]
    Write-Host "`nNext ticket up: $(('{0:D4}' -f $next.Number))-$($next.Slug)" -ForegroundColor Green
} else {
    Write-Host "No pending tickets remaining! All tickets complete." -ForegroundColor Green
}
