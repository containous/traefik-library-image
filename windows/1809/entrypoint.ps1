if ($null -eq $args[0]) {
    /traefik
    exit $LASTEXITCODE 
}

if ($args[0].StartsWith("-")) {
    /traefik $args
    exit $LASTEXITCODE
} 

(/traefik $args[0] --help 2>&1>$null)

if ($LASTEXITCODE -eq 0) {
    /traefik $args
    exit $LASTEXITCODE
}

Invoke-Expression "$args"
exit $LASTEXITCODE