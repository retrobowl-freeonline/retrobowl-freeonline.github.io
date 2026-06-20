# Input / Output
$inputFile = "style.css"
$outputFile = "style-clean.css"

# Read full CSS
$content = Get-Content $inputFile -Raw

# Split CSS blocks safely
$regex = [regex]'(?s)([^{]+)\{([^{}]*(?:\{[^{}]*\}[^{}]*)*)\}'

$matches = $regex.Matches($content)

$seen = @{}
$output = @()

foreach ($m in $matches) {

    # Full exact block
    $block = $m.Value.Trim()

    # Normalize only for duplicate checking
    $normalized = ($block `
        -replace '\s+', ' ' `
        -replace '\s*:\s*', ':' `
        -replace '\s*;\s*', ';' `
        -replace '\s*,\s*', ',' `
        -replace '\s*\{\s*', '{' `
        -replace '\s*\}\s*', '}').Trim()

    if (-not $seen.ContainsKey($normalized)) {
        $seen[$normalized] = $true
        $output += $block
    }
}

# Save cleaned CSS
$output -join "`r`n`r`n" | Out-File $outputFile -Encoding utf8

Write-Host "Done! Saved as $outputFile"# Files
$inputFile = "style.css"
$outputFile = "style-clean.css"

# Read CSS
$content = Get-Content $inputFile -Raw

# Extract CSS blocks properly
$pattern = '(?s)([^{]+)\{([^{}]*(?:\{[^{}]*\}[^{}]*)*)\}'
$matches = [regex]::Matches($content, $pattern)

$seen = @{}
$result = New-Object System.Collections.Generic.List[string]

foreach ($match in $matches) {

    $selector = $match.Groups[1].Value.Trim()
    $body = $match.Groups[2].Value.Trim()

    # Normalize spaces for duplicate compare
    $normalizedSelector = ($selector -replace '\s+', ' ').Trim()

    $normalizedBody = ($body `
        -replace '\s+', ' ' `
        -replace '\s*:\s*', ':' `
        -replace '\s*;\s*', ';' `
        -replace '\s*,\s*', ',').Trim()

    # Unique key
    $key = "$normalizedSelector{$normalizedBody}"

    # Keep first occurrence only
    if (-not $seen.ContainsKey($key)) {
        $seen[$key] = $true
        $result.Add($match.Value.Trim())
    }
}

# Save cleaned CSS
$result -join "`r`n`r`n" | Set-Content $outputFile -Encoding UTF8

Write-Host "Done! Duplicate blocks removed."
Write-Host "Saved as: $outputFile"