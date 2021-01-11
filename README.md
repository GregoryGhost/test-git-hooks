# TestGitHooks

TEST TEst changes
This project was generated with [Angular CLI](https://github.com/angular/angular-cli) version 11.0.3.

## Development server

Run `ng serve` for a dev server. Navigate to `http://localhost:4200/`. The app will automatically reload if you change any of the source files.

## Code scaffolding

Run `ng generate component component-name` to generate a new component. You can also use `ng generate directive|pipe|service|class|guard|interface|enum|module`.

## Build

Run `ng build` to build the project. The build artifacts will be stored in the `dist/` directory. Use the `--prod` flag for a production build.

## Running unit tests

Run `ng test` to execute the unit tests via [Karma](https://karma-runner.github.io).

## Running end-to-end tests

Run `ng e2e` to execute the end-to-end tests via [Protractor](http://www.protractortest.org/).

## Further help

To get more help on the Angular CLI use `ng help` or go check out the [Angular CLI Overview and Command Reference](https://angular.io/cli) page.

## Inject git hooks inspection

To get git hooks package Husky v4:

```bash
npm i husky --save-dev
```

For pretty format source code in the project:

```bash
> npm i --save-dev --save-exact prettier
```

And add basic configs for `prettier` to ignore folders (`.prettierignore`):

```text
# Ignore artifacts:
build
coverage
dist
node_modules
scripts
```

And prettier format config `.prettierrc`:

For linting project you need follow simple steps in this [article](https://github.com/angular-eslint/angular-eslint#migrating-an-angular-cli-project-from-codelyzer-and-tslint).
Generally, you need to do this steps:

```bash
> ng add @angular-eslint/schematics
> ng g @angular-eslint/schematics:convert-tslint-to-eslint {{YOUR_PROJECT_NAME_GOES_HERE}}
> rm tslint.json
> npm uninstall tslint codelyzer
```

Add some eslint rules in eslint config `.eslintrc.json`:

```text
{
  "root": true,
  "ignorePatterns": ["projects/**/*"],
  "overrides": [
    {
      "files": ["*.ts"],
      "parserOptions": {
        "project": ["tsconfig.json", "e2e/tsconfig.json"],
        "createDefaultProgram": true
      },
      "extends": [
        "plugin:@angular-eslint/ng-cli-compat",
        "plugin:@angular-eslint/ng-cli-compat--formatting-add-on",
        "plugin:@angular-eslint/template/process-inline-templates"
      ],
      "rules": {
        "@angular-eslint/component-selector": [
          "error",
          {
            "type": "element",
            "prefix": "app",
            "style": "kebab-case"
          }
        ],
        "@angular-eslint/directive-selector": [
          "error",
          {
            "type": "attribute",
            "prefix": "app",
            "style": "camelCase"
          }
        ],
        "@typescript-eslint/no-explicit-any": "error"
      }
    },
    {
      "files": ["*.html"],
      "extends": ["plugin:@angular-eslint/template/recommended"],
      "rules": {}
    }
  ]
}
```

Added inspection scripts to `package.json`:

```json
{
  "scripts": {
    "build": "ng build",
    "lint": "ng lint",
    "commit-code-style-changes": "powershell -NoProfile -ExecutionPolicy RemoteSigned -Command ./scripts/apply-code-style.ps1",
    "prettier-format": "npx prettier --write . && npm run commit-code-style-changes",
    "check-git-changes": "powershell -NoProfile -ExecutionPolicy RemoteSigned -Command ./scripts/check-git-changes.ps1",
    "pre-build": "npm run build && npm run prettier-format && npm run lint && npm run build"
  },
  "husky": {
    "hooks": {
      "pre-push": "npm run check-git-changes && npm run pre-build"
    }
  },
  ...
}
```
