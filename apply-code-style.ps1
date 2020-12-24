$gitStatus = Invoke-Expression -Command "git status --porcelain";
$haveUntrackedChanges = $gitStatus |Where {$_ -match '^\?\?'};
$haveUncommitedChanges = $gitStatus |Where {$_ -notmatch '^\?\?'};
if ($haveUntrackedChanges -or $haveUncommitedChanges)
{
    Invoke-Expression "git commit -am ""[Autocommit] Prettier formatted files"""
} 