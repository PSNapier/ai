# ai
A collection of my AI resources. For my own use, YMMV. 

`$repo='https://github.com/PSNapier/ai.git'; $tmp=Join-Path $env:TEMP ("ai-cursor-"+[guid]::NewGuid()); git clone --depth 1 --filter=blob:none --sparse $repo $tmp; git -C $tmp sparse-checkout set cursor; robocopy (Join-Path $tmp 'cursor') (Join-Path (Get-Location) '.cursor') /E /XC /XN /XO /R:1 /W:1; if($LASTEXITCODE -ge 8){ throw "robocopy failed: $LASTEXITCODE" }; Remove-Item $tmp -Recurse -Force`
