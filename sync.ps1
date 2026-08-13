<#
.SYNOPSIS
Sync the .skills/ folder from the agentic repo into the current project.

.DESCRIPTION
Sparse-clones https://github.com/PSNapier/agentic, copies .skills/ into a
destination folder (default .skills), then removes the temporary clone.

By default existing files are left untouched; only new files are added.
Pass -Force to overwrite files that already exist in the destination.

.PARAMETER Dest
Destination folder, relative to the current directory or absolute.
Defaults to .skills

.PARAMETER Force
Overwrite existing files instead of skipping them.

.EXAMPLE
irm https://raw.githubusercontent.com/PSNapier/agentic/main/sync.ps1 | iex

.EXAMPLE
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/PSNapier/agentic/main/sync.ps1))) -Force -Dest .claude/skills
#>
[CmdletBinding()]
param(
    [string]$Dest = '.skills',
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

$repo = 'https://github.com/PSNapier/agentic.git'
$tmp = Join-Path $env:TEMP ('agentic-' + [guid]::NewGuid())

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw 'git not found on PATH'
}

$target = if ([System.IO.Path]::IsPathRooted($Dest)) { $Dest } else { Join-Path (Get-Location) $Dest }

try {
    # --no-checkout so the sparse rules are set before any file hits disk. Paths
    # elsewhere in the repo that are illegal on Windows then never get materialized.
    git clone --depth 1 --filter=blob:none --sparse --no-checkout $repo $tmp
    if ($LASTEXITCODE -ne 0) { throw "git clone failed: $LASTEXITCODE" }

    git -C $tmp sparse-checkout set .skills
    if ($LASTEXITCODE -ne 0) { throw "sparse-checkout failed: $LASTEXITCODE" }

    git -C $tmp checkout
    if ($LASTEXITCODE -ne 0) { throw "git checkout failed: $LASTEXITCODE" }

    $flags = if ($Force) { @('/IS', '/IT') } else { @('/XC', '/XN', '/XO') }
    robocopy (Join-Path $tmp '.skills') $target /E @flags /R:1 /W:1 | Out-Null
    if ($LASTEXITCODE -ge 8) { throw "robocopy failed: $LASTEXITCODE" }

    $mode = if ($Force) { 'overwrite' } else { 'no overwrite' }
    Write-Host "Synced .skills to $target ($mode)"
}
finally {
    if (Test-Path $tmp) { Remove-Item $tmp -Recurse -Force }
}
