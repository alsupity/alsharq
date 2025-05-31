$manifestPath = 'C:\Users\GIA\AppData\Local\Pub\Cache\hosted\pub.dev\syncfusion_flutter_pdfviewer-22.2.12\android\src\main\AndroidManifest.xml'
$buildGradlePath = 'C:\Users\GIA\AppData\Local\Pub\Cache\hosted\pub.dev\syncfusion_flutter_pdfviewer-22.2.12\android\build.gradle'

# 1. Remove package attribute from AndroidManifest.xml
$manifest = Get-Content $manifestPath
$newManifest = $manifest -replace 'package="com.syncfusion.flutter.pdfviewer"', ''
$newManifest | Set-Content $manifestPath
Write-Host "Removed package attribute from AndroidManifest.xml"

# 2. Add namespace to build.gradle if it doesn't exist
$buildGradle = Get-Content $buildGradlePath -Raw
if ($buildGradle -notmatch "namespace 'com.syncfusion.flutter.pdfviewer'") {
    $buildGradle = $buildGradle -replace 'android \{', "android {`n    namespace 'com.syncfusion.flutter.pdfviewer'"
    $buildGradle | Set-Content $buildGradlePath
    Write-Host "Added namespace to build.gradle"
} else {
    Write-Host "Namespace already exists in build.gradle"
}

Write-Host "Fix completed."
