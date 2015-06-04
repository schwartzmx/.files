Set-Location $HOME
Set-Variable HOSTS "C:\Windows\System32\drivers\etc\hosts" -Force

# Load posh-git example profile
if(Test-Path Function:\Prompt) {Rename-Item Function:\Prompt PrePoshGitPrompt -Force}
. 'C:\tools\poshgit\dahlbyk-posh-git-869d4c5\profile.example.ps1'
Rename-Item Function:\Prompt PoshGitPrompt -Force
function Prompt() {if(Test-Path Function:\PrePoshGitPrompt){++$global:poshScope; New-Item function:\script:Write-host -value "param([object] `$object, `$backgroundColor, `$foregroundColor, [switch] `$nonewline) " -Force | Out-Null;$private:p = PrePoshGitPrompt; if(--$global:poshScope -eq 0) {Remove-Item function:\Write-Host -Force}}PoshGitPrompt}

# Python 3, used when Python 2.7 is also installed
Set-Alias python3 -Value C:\Python34\python.exe 
Set-Alias pip3 -Value pip3.4.exe

# Kill all Chrome Helper (tabs) sessions
Function Chrome-Kill {
    Get-Process | Where { $_.ProcessName -eq "chrome" } | Select -Skip 1 | ForEach-Object { $_.Kill() }
}

# For Editing your PowerShell profile
Function Edit-Profile
{
    vim $profile
}

# Edit hosts file
Function Edit-Hosts
{
  vim $HOSTS
}

# For Editing your Vim settings
Function Edit-Vimrc
{
    vim $home\_vimrc
}

# Find files with a specified string in them
# String Search Directory > ss-dir Directory String
Function ss-dir {
	If (Test-Path -Path $args[0] -PathType Container) {
		Get-ChildItem $args[0] -recurse | Select-String -pattern “$args[1]” | Group path | Select name
	}
	Else {
		Write-Host "Path specified is not a directory. Usage: ss-dir Directory String"
	}
}

# Quick access to Projects
Function p
{
    cd C:\Users\Fed-Phil\Projects
}
# Remove recursive force
Function rmrf {
    for($i=0; $i -lt $args.length; $i++){
        Remove-Item -Recurse -Force $args[$i]
    }
}


function New-Zip
{
    param([string]$zipfilename)
    set-content $zipfilename ("PK" + [char]5 + [char]6 + ("$([char]0)" * 18))
    (dir $zipfilename).IsReadOnly = $false
}
# usage: new-zip c:\demo\myzip.zip

function Add-Zip
{
    param([string]$zipfilename)

    if(-not (test-path($zipfilename))) {
        set-content $zipfilename ("PK" + [char]5 + [char]6 + ("$([char]0)" * 18))
        (dir $zipfilename).IsReadOnly = $false  
    }
                        
    $shellApplication = new-object -com shell.application
    $zipPackage = $shellApplication.NameSpace($zipfilename)
                              
    foreach($file in $input) { 
        $zipPackage.CopyHere($file.FullName)
        Start-sleep -milliseconds 500
    }
}
#usage: dir c:\demo\files\*.* -Recurse | add-Zip c:\demo\myzip.zip

function Get-Zip
{
    param([string]$zipfilename)
    if(test-path($zipfilename)) {
        $shellApplication = new-object -com shell.application
        $zipPackage = $shellApplication.NameSpace($zipfilename)
        $zipPackage.Items() | Select Path
    }
}

#usage: Get-Zip c:\demo\myzip.zip

function Extract-Zip
{
    param([string]$zipfilename, [string] $destination)

    if(test-path($zipfilename)) { 
        $shellApplication = new-object -com shell.application
        $zipPackage = $shellApplication.NameSpace($zipfilename)
        $destinationFolder = $shellApplication.NameSpace($destination)
        $destinationFolder.CopyHere($zipPackage.Items())
    }
}


New-Alias import Import-Module
New-Alias cl clear
New-Alias which get-command
New-Alias open explorer
Set-Alias notepad -Value "C:\Program Files (x86)\Notepad++\notepad++.exe"
Set-Alias subl -Value "C:\Program Files\Sublime Text 3\sublime_text.exe"

# Assumes GitBash is installed
# $env:path += ";" + (Get-Item "Env:ProgramFiles(x86)").Value + "\Git\bin"      
If (Test-Path -Path "C:\Program Files (x86)\Git\bin\" -PathType Container) {
  Set-Alias antiword -Value "C:\Program Files (x86)\Git\bin\antiword.exe"
  Set-Alias basename -Value "C:\Program Files (x86)\Git\bin\basename.exe"
  Set-Alias bash -Value "C:\Program Files (x86)\Git\bin\bash.exe"
  Set-Alias bison -Value "C:\Program Files (x86)\Git\bin\bison.exe"
  Set-Alias bzip2 -Value "C:\Program Files (x86)\Git\bin\bzip2.exe"
  Set-Alias chmod -Value "C:\Program Files (x86)\Git\bin\chmod.exe"
  Set-Alias cmp -Value "C:\Program Files (x86)\Git\bin\cmp.exe"
  Set-Alias connect -Value "C:\Program Files (x86)\Git\bin\connect.exe"
  Set-Alias cut -Value "C:\Program Files (x86)\Git\bin\cut.exe"
  Set-Alias date -Value "C:\Program Files (x86)\Git\bin\date.exe"
  Set-Alias dirname -Value "C:\Program Files (x86)\Git\bin\dirname.exe"
  Set-Alias dos2unix -Value "C:\Program Files (x86)\Git\bin\dos2unix.exe"
  Set-Alias du -Value "C:\Program Files (x86)\Git\bin\du.exe"
  Set-Alias env -Value "C:\Program Files (x86)\Git\bin\env.exe"
  Set-Alias expr -Value "C:\Program Files (x86)\Git\bin\expr.exe"
  Set-Alias false -Value "C:\Program Files (x86)\Git\bin\false.exe"
  Set-Alias find -Value "C:\Program Files (x86)\Git\bin\find.exe"
  Set-Alias flex -Value "C:\Program Files (x86)\Git\bin\flex.exe"
  Set-Alias gawk -Value "C:\Program Files (x86)\Git\bin\gawk.exe"
  Set-Alias getcp -Value "C:\Program Files (x86)\Git\bin\getcp.exe"
  Set-Alias git -Value "C:\Program Files (x86)\Git\bin\git.exe"
  Set-Alias gpg -Value "C:\Program Files (x86)\Git\bin\gpg.exe"
  Set-Alias gpgkeys_curl -Value "C:\Program Files (x86)\Git\bin\gpgkeys_curl.exe"
  Set-Alias gpgkeys_finger -Value "C:\Program Files (x86)\Git\bin\gpgkeys_finger.exe"
  Set-Alias gpgkeys_hkp -Value "C:\Program Files (x86)\Git\bin\gpgkeys_hkp.exe"
  Set-Alias gpgkeys_ldap -Value "C:\Program Files (x86)\Git\bin\gpgkeys_ldap.exe"
  Set-Alias gpgsplit -Value "C:\Program Files (x86)\Git\bin\gpgsplit.exe"
  Set-Alias gpgv -Value "C:\Program Files (x86)\Git\bin\gpgv.exe"
  Set-Alias grep -Value "C:\Program Files (x86)\Git\bin\grep.exe"
  Set-Alias gunzip -Value "C:\Program Files (x86)\Git\bin\gunzip.exe"
  Set-Alias gzip -Value "C:\Program Files (x86)\Git\bin\gzip.exe"
  Set-Alias hd2u -Value "C:\Program Files (x86)\Git\bin\hd2u.exe"
  Set-Alias head -Value "C:\Program Files (x86)\Git\bin\head.exe"
  Set-Alias iconv -Value "C:\Program Files (x86)\Git\bin\iconv.exe"
  Set-Alias id -Value "C:\Program Files (x86)\Git\bin\id.exe"
  Set-Alias less -Value "C:\Program Files (x86)\Git\bin\less.exe"
  Set-Alias ln -Value "C:\Program Files (x86)\Git\bin\ln.exe"
  Set-Alias m4 -Value "C:\Program Files (x86)\Git\bin\m4.exe"
  Set-Alias md5sum -Value "C:\Program Files (x86)\Git\bin\md5sum.exe"
  Set-Alias mkdir -Value "C:\Program Files (x86)\Git\bin\mkdir.exe"
  Set-Alias msmtp -Value "C:\Program Files (x86)\Git\bin\msmtp.exe"
  Set-Alias openssl -Value "C:\Program Files (x86)\Git\bin\openssl.exe"
  Set-Alias patch -Value "C:\Program Files (x86)\Git\bin\patch.exe"
  Set-Alias pdfinfo -Value "C:\Program Files (x86)\Git\bin\pdfinfo.exe"
  Set-Alias pdftotext -Value "C:\Program Files (x86)\Git\bin\pdftotext.exe"
  Set-Alias perl -Value "C:\Program Files (x86)\Git\bin\perl.exe"
  Set-Alias rebase -Value "C:\Program Files (x86)\Git\bin\rebase.exe"
  Set-Alias rxvt -Value "C:\Program Files (x86)\Git\bin\rxvt.exe"
  Set-Alias scp -Value "C:\Program Files (x86)\Git\bin\scp.exe"
  Set-Alias sed -Value "C:\Program Files (x86)\Git\bin\sed.exe"
  Set-Alias sh -Value "C:\Program Files (x86)\Git\bin\sh.exe"
  Set-Alias split -Value "C:\Program Files (x86)\Git\bin\split.exe"
  Set-Alias ssh-add -Value "C:\Program Files (x86)\Git\bin\ssh-add.exe"
  Set-Alias ssh-agent -Value "C:\Program Files (x86)\Git\bin\ssh-agent.exe"
  Set-Alias ssh-keygen -Value "C:\Program Files (x86)\Git\bin\ssh-keygen.exe"
  Set-Alias ssh-keyscan -Value "C:\Program Files (x86)\Git\bin\ssh-keyscan.exe"
  Set-Alias ssh -Value "C:\Program Files (x86)\Git\bin\ssh.exe"
  Set-Alias tail -Value "C:\Program Files (x86)\Git\bin\tail.exe"
  Set-Alias tar -Value "C:\Program Files (x86)\Git\bin\tar.exe"
  Set-Alias tclsh -Value "C:\Program Files (x86)\Git\bin\tclsh.exe"
  Set-Alias tclsh85 -Value "C:\Program Files (x86)\Git\bin\tclsh85.exe"
  Set-Alias touch -Value "C:\Program Files (x86)\Git\bin\touch.exe"
  Set-Alias tr -Value "C:\Program Files (x86)\Git\bin\tr.exe"
  Set-Alias true -Value "C:\Program Files (x86)\Git\bin\true.exe"
  Set-Alias uname -Value "C:\Program Files (x86)\Git\bin\uname.exe"
  Set-Alias uniq -Value "C:\Program Files (x86)\Git\bin\uniq.exe"
  Set-Alias unix2dos -Value "C:\Program Files (x86)\Git\bin\unix2dos.exe"
  Set-Alias unzip -Value "C:\Program Files (x86)\Git\bin\unzip.exe"
  Set-Alias wc -Value "C:\Program Files (x86)\Git\bin\wc.exe"
  Set-Alias wish -Value "C:\Program Files (x86)\Git\bin\wish.exe"
  Set-Alias wish85 -Value "C:\Program Files (x86)\Git\bin\wish85.exe"
  Set-Alias xargs -Value "C:\Program Files (x86)\Git\bin\xargs.exe"
}
