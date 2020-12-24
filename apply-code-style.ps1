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
} elseif ($haveUncommitedChanges) {
    Write-Error "Есть не закоммиченные изменения.`
        Существующие варианты решения:`
        - закоммитить изменения;`
        - поместить изменения в stash;`
        - убрать изменения.";
 exit 1;
} else
{
    Write-Output "Применяю настройки codestyle'а";
    try {
        $isOkCodeStyle = Invoke-Expression -Command "npx prettier --write . | git commit -am ""[Autocommit] Prettier formatted files"" | npm run build | npm run lint" | Out-Null; $?;
        if ($isOkCodeStyle) { exit 0; } { throw }
    } catch {
        Write-Error "Произошла ошибка в применении настроек codestyle'а";
        throw
    }
}