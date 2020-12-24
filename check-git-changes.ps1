$gitStatus = Invoke-Expression -Command "git status --porcelain";
$haveUntrackedChanges = $gitStatus |Where {$_ -match '^\?\?'};
$haveUncommitedChanges = $gitStatus |Where {$_ -notmatch '^\?\?'};
if ($haveUntrackedChanges)
{
 Write-Error "Есть не отслеживаемые изменения.`
    Существующие варианты решения:`
    - затрекать и закоммитить изменения;`
    - поместить изменения в stash;`
    - убрать изменения.";
 exit 1;
}
if ($haveUncommitedChanges) 
{
    Write-Error "Есть не закоммиченные изменения.`
        Существующие варианты решения:`
        - закоммитить изменения;`
        - поместить изменения в stash;`
        - убрать изменения.";
 exit 1;
}