# Settings
$directoryPath = "D:\scriptstest\test"  # Path to remove folders inside.
$daysOld = 30  # Number of days after which files should be deleted.
$maintLogFilePath = "D:\scriptstest\FolderCleaner.Main.txt"  # Path to info logs.
$errorLogFilePath = "D:\scriptstest\FolderCleaner.Error.txt"  # Path to error logs.
$encounteredError = $false

$cutoffDate = (Get-Date).AddDays(-$daysOld) # Calculate date to remove folders older than.
$foldersToDelete = Get-ChildItem -Path $directoryPath -Directory | Where-Object { $_.LastWriteTime -lt $cutoffDate } # Get folders older than cutoffDate.

foreach ($folder in $foldersToDelete)
{
    try
    {
        Remove-Item -Path $folder.FullName -Force -Recurse -ErrorAction Stop #ErrorAction needed to make sure it will catch error
        $logMessage = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [INF] Removed folder: $($folder.FullName)"
        Write-Output $logMessage
        Add-Content -Path $maintLogFilePath -Value $logMessage
    } 
    catch
    {
        $encounteredError = $true
        $errorMessage = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [ERR] Error during deleting folder: $($folder.FullName) - $($_.Exception.Message)"
        Write-Output $errorMessage
        Add-Content -Path $errorLogFilePath -Value $errorMessage
    }
}

if ($encounteredError) 
{
    exit 1
} 
else 
{
    exit 0
}