$filePath = 'C:\Users\GIA\AppData\Local\Pub\Cache\hosted\pub.dev\country_codes-2.2.0\android\build.gradle'
$content = Get-Content $filePath
$newContent = $content -replace "namespace 'com.example.country_codes'", "namespace 'com.miguelruivo.flutter.plugin.countrycodes.country_codes'"
$newContent | Set-Content $filePath
Write-Host "Namespace replaced successfully."
