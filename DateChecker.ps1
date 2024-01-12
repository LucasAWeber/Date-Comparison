$xml = [xml](Get-Content Properties/Settings.settings)
$xsdPath = "$(($xml.SettingsFile.Settings.Setting | ? {$_.Name -eq "ConfigPath"} | select Value).Value.InnerText)$(($xml.SettingsFile.Settings.Setting | ? {$_.Name -eq "SchemaFile"} | select Value).Value.InnerText)"
$xsdFile = Get-Item $xsdPath
if ($xsdFile.Name -eq $null) {
    # Building application offline or file moved
    Write-Host "Schema info file not found. Either building application offline or file was moved"
}
$csFile = Get-Item "ImportExport\SystemLayout.cs"

if ($xsdFile.LastWriteTime -gt $csFile.LastWriteTime) {
    throw "'$($csFile.Name)' file is out of date with the latest '$($xsdFile.Name)' schema file! `n"
}
else {
    Write-Host "'$($csFile.Name)' file is up to date with the latest '$($xsdFile.Name)' schema file."
}
