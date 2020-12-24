function Check-Build-Project {
    return Invoke-Expression -Command "npm run build" | Out-Null; $?;
}

function Check-Lint-Project {
    return Invoke-Expression -Command "npm run lint" | Out-Null; $?;
}

function Apply-CodeStyle {
    return Invoke-Expression -Command "npx prettier --write . | git commit -am ""[Autocommit] Prettier formatted files""" | Out-Null; $?;
}


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
    Write-Output "Применяю настройки codestyle'а ...`n";
    try {
        if (-Not (Check-Build-Project)) {
            Write-Error "Сборка проекта не прошла.";
            exit 1;
        }
        if (-Not (Check-Lint-Project)) {
            Write-Error "Проверка проекта с помощью линтера не прошла.";
            exit 1;
        }
        if (-Not (Apply-CodeStyle)) {
            Write-Error "Не удалось применить настройки форматирования. 
                Запустите prettier отдельно:
                > npx prettier --write .";
            exit 1;
        }

        Write-Output "Настройки codeStyle'а были применены.
            Перепроверяю сборку и отсутствие ошибок от линтера ...`n";
        
        if (-Not (Check-Build-Project)) {
            Write-Error "Сборка проекта не прошла.";
            exit 1;
        }
        if (-Not (Check-Lint-Project)) {
            Write-Error "Проверка проекта с помощью линтера не прошла.";
            exit 1;
        }
        Write-Output "Сборка и линтер прошли, настройки codeStyle'а применены.`n";
    } catch {
        Write-Error "Произошла ошибка в применении настроек codeStyle'а";
        throw
    }
}