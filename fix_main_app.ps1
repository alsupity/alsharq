$manifestPath = 'E:\alsharq\android\app\src\main\AndroidManifest.xml'
$buildGradlePath = 'E:\alsharq\android\app\build.gradle'

# 1. Read current package name from AndroidManifest.xml
$manifest = Get-Content $manifestPath
$packageMatch = $manifest | Select-String -Pattern 'package="([^"]+)"'
$packageName = $packageMatch.Matches.Groups[1].Value

# 2. Remove package attribute from AndroidManifest.xml
$newManifest = $manifest -replace 'package="[^"]+"', ''
$newManifest | Set-Content $manifestPath
Write-Host "Removed package attribute from AndroidManifest.xml"

# 3. Add namespace to build.gradle if it doesn't exist
$buildGradle = Get-Content $buildGradlePath -Raw
if ($buildGradle -notmatch "namespace '$packageName'") {
    $buildGradle = $buildGradle -replace 'android \{', "android {`n    namespace '$packageName'"
    $buildGradle | Set-Content $buildGradlePath
    Write-Host "Added namespace '$packageName' to build.gradle"
} else {
    Write-Host "Namespace already exists in build.gradle"
}

Write-Host "Fix completed for main application."
