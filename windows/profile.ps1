
Set-Alias cl Clear-Host
Set-Alias import Import-Module
Set-Alias which get-command
Set-Alias open explorer
Set-Variable $HOME ~
Set-Variable HOSTS "C:\Windows\System32\drivers\etc\hosts" -Force

# Linux-like du 
Function PoSh-DiskUsage {
    param(
        [String]$Path=$($pwd.Path)
    )
    Get-ChildItem $path | % {
        $file = $_; 
        Get-ChildItem -Recurse $_.FullName | 
        Measure-Object -Property Length -Sum | 
        Select  @{ Name= "Name"; Expression= { $file } }, `
            @{ Name = "Sum (GB)"; Expression = {  "{0:N3}" -f ($_.Sum / 1024MB) } }, `
            @{ Name = "Sum (MB)"; Expression = {  "{0:N3}" -f ($_.Sum / 1MB) } }, `
            Sum 
        } | 
        Sort Sum -Desc | 
        Format-Table -Property Name,"Sum (GB)", "Sum (MB)", Sum -AutoSize
}
Set-Alias -Name ps-du -Value PoSh-DiskUsage -Description "linux du-like utility"

##################### GIT Function ###############################
Function isCurrentDirectoryGitRepository {
    if ((Test-Path ".git") -eq $TRUE) {
        return $TRUE
    }
    
    # Test within parent dirs
    $checkIn = (Get-Item .).parent
    while ($checkIn -ne $NULL) {
        $pathToTest = $checkIn.fullname + '/.git'
        if ((Test-Path $pathToTest) -eq $TRUE) {
            return $TRUE
        } else {
            $checkIn = $checkIn.parent
        }
    }
    
    return $FALSE
}

# Get the current branch
Function gitBranchName {
    $currentBranch = ''
    git branch | foreach {
        if ($_ -match "^\* (.*)") {
            $currentBranch += $matches[1]
        }
    }
    return $currentBranch
}

# Extracts status details about the repo
Function gitStatus {
    $untracked = $FALSE
    $added = 0
    $modified = 0
    $deleted = 0
    $ahead = $FALSE
    $aheadCount = 0
    
    $output = git status
    
    $branchbits = $output[0].Split(' ')
    $branch = $branchbits[$branchbits.length - 1]
    
    $output | foreach {
        if ($_ -match "^\#.*origin/.*' by (\d+) commit.*") {
            $aheadCount = $matches[1]
            $ahead = $TRUE
        }
        elseif ($_ -match "deleted:") {
            $deleted += 1
        }
        elseif (($_ -match "modified:") -or ($_ -match "renamed:")) {
            $modified += 1
        }
        elseif ($_ -match "new file:") {
            $added += 1
        }
        elseif ($_ -match "Untracked files:") {
            $untracked = $TRUE
        }
    }
    
    return @{"untracked" = $untracked;
             "added" = $added;
             "modified" = $modified;
             "deleted" = $deleted;
             "ahead" = $ahead;
             "aheadCount" = $aheadCount;
             "branch" = $branch}
}
##################### GIT Function ###############################


######################## Prompt ##################################
Function prompt {
	$path = $pwd.Path.replace("$HOME", "~")
    Write-Host $env:username -NoNewline -ForegroundColor Green
	Write-Host '@' -NoNewline -ForegroundColor Gray
    Write-Host $([System.Environment]::MachineName)  -NoNewline -ForegroundColor Green
    Write-Host ' {' -NoNewline -ForegroundColor Gray
    Write-Host $path -NoNewline -ForegroundColor Yellow
    Write-Host '} ' -NoNewline -ForegroundColor Gray
	$host.UI.RawUi.WindowTitle = $userLocation
    Write-Host($userLocation) -nonewline -foregroundcolor Yellow    
    if (isCurrentDirectoryGitRepository) {
        $status = gitStatus
        $currentBranch = $status["branch"]        
        Write-Host('[') -nonewline -foregroundcolor Gray
        if ($status["ahead"] -eq $FALSE) {
            # We are not ahead of origin
            Write-Host($currentBranch) -nonewline -foregroundcolor Cyan
        } else {
            # We are ahead of origin
            Write-Host($currentBranch) -nonewline -foregroundcolor Red
        }
        Write-Host(' +' + $status["added"]) -nonewline -foregroundcolor Yellow
        Write-Host(' ~' + $status["modified"]) -nonewline -foregroundcolor Yellow
        Write-Host(' -' + $status["deleted"]) -nonewline -foregroundcolor Yellow      
        if ($status["untracked"] -ne $FALSE) {
            Write-Host(' !') -nonewline -foregroundcolor Yellow
        }       
        Write-Host('] ') -nonewline -foregroundcolor Gray 
    }    
	Write-Host('$') -nonewline -foregroundcolor Green    
	return " "
}

Function p
{
    If (Test-Path E:\Projects) { cd E:\Projects }
    Else { Throw "E:\Projects does not exist!" }
}
