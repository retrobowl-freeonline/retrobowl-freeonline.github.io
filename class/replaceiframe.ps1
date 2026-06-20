# mapping file ka path (jo tumne diya hai)
$mapFile = "mapping.txt"

# mapping load karo
$map = @{}
Get-Content $mapFile | ForEach-Object {
    if ($_ -match "^(.*?)\s*\|\s*(https?://.+)$") {
        $name = $matches[1].Trim()
        $url = $matches[2].Trim()
        $map[$name] = $url
    }
}

Get-ChildItem -Directory | ForEach-Object {

    $folder = $_.Name
    $index = Join-Path $_.FullName "index.html"

    if (!(Test-Path $index)) { return }

    $html = Get-Content $index -Raw

    if ($html -notmatch "iframepaste-here") { return }

    # agar mapping me link mila
    if ($map.ContainsKey($folder)) {
        $iframe = $map[$folder]

        $html = $html -replace "iframepaste-here", $iframe

        Set-Content $index $html -Encoding UTF8

        Write-Host "Done: $folder"
    }
    else {
        Write-Host "No iframe found for: $folder"
    }
}