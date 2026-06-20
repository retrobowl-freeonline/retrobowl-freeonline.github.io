# ==========================
# CONFIG
# ==========================
$htmlFile = "index.html"
$cssFile = "style.css"
$outputCss = "style-clean.css"

# Safe classes (never remove)
$safeClasses = @(
"active","show","open","hidden","visible",
"menu","modal","dropdown","sidebar",
"current","selected","expanded",
"dark","light","loading","loaded"
)

# ==========================
# READ HTML
# ==========================
$html = Get-Content $htmlFile -Raw

# Extract used classes
$classMatches = [regex]::Matches($html, 'class\s*=\s*["'']([^"'']+)["'']')

$usedClasses = @{}

foreach ($match in $classMatches) {
    $classes = $match.Groups[1].Value -split '\s+'

    foreach ($cls in $classes) {
        if ($cls.Trim()) {
            $usedClasses[$cls.Trim()] = $true
        }
    }
}

# Extract IDs
$idMatches = [regex]::Matches($html, 'id\s*=\s*["'']([^"'']+)["'']')

$usedIds = @{}

foreach ($match in $idMatches) {
    $usedIds[$match.Groups[1].Value.Trim()] = $true
}

# ==========================
# READ CSS
# ==========================
$css = Get-Content $cssFile -Raw

$regex = '(?s)([^{]+)\{([^{}]*(?:\{[^{}]*\}[^{}]*)*)\}'
$matches = [regex]::Matches($css, $regex)

$output = New-Object System.Collections.Generic.List[string]

foreach ($match in $matches) {

    $selectorText = $match.Groups[1].Value.Trim()
    $block = $match.Value.Trim()

    $keep = $false

    $selectors = $selectorText -split ','

    foreach ($selector in $selectors) {

        $clean = $selector.Trim()

        # Remove pseudo selectors
        $clean = $clean -replace '::?.*$', ''

        # Match classes
        $classMatches = [regex]::Matches($clean, '\.([a-zA-Z0-9_-]+)')

        foreach ($cls in $classMatches) {

            $className = $cls.Groups[1].Value

            if ($safeClasses -contains $className) {
                $keep = $true
                break
            }

            if ($usedClasses.ContainsKey($className)) {
                $keep = $true
                break
            }
        }

        # Match IDs
        $idMatches = [regex]::Matches($clean, '#([a-zA-Z0-9_-]+)')

        foreach ($id in $idMatches) {

            $idName = $id.Groups[1].Value

            if ($usedIds.ContainsKey($idName)) {
                $keep = $true
                break
            }
        }

        # Keep element selectors
        if ($clean -match '^(html|body|div|span|img|a|button|input|section|header|footer|nav|main|ul|li)$') {
            $keep = $true
        }

        if ($keep) { break }
    }

    if ($keep) {
        $output.Add($block)
    }
}

# Save cleaned CSS
$output -join "`r`n`r`n" | Set-Content $outputCss -Encoding UTF8

Write-Host ""
Write-Host "Done!"
Write-Host "Created: $outputCss"