# Family Seams #
Application for connection management.

## Projects ##

* [API](./packages/api) - REST Service for managing application data.
* [Web](./packages/web) - Website UI for application.

## Development Tools ##

* [node](https://nodejs.org/en/download/)
* [docker](https://docs.docker.com/get-docker/)
* [terraform](https://www.terraform.io/downloads.html)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [helm](https://helm.sh/docs/intro/install/)

## Development Setup ##

After checkout run the following command from the root of the
checkout directory to install all node modules for root and
all packages.

```bash
npm install
npm run lerna -- bootstrap
```

### Run All Locally

This project includes a docker-compose that will start all projects in development 
mode. The docker-compose expects node_modules to be populated for each project, so 
`npm install` needs to be run before these will work.

```bash
# Start all projects in detached mode
docker-compose up -d

# View container status
docker-compose ps

# Remove, stop, and remove volumes from all containers.
# Recommended way to tear down everything locally
docker-compose rm -fsv
```

## Lerna ##
[Lerna](https://github.com/lerna/lerna) is used to manage the monorepo.
There is no need to install this globaly, and instead the following
script alias can be used for any Lerna command.

```bash
npm run lerna -- lerna commands
```

## Tests ##
Tests are run by [Jest](https://jestjs.io/docs/en/getting-started.html).
This project will use the [package.json](https://jestjs.io/docs/en/configuration) for Jest configuration.
Customize the run with [Jest CLI Options](https://jestjs.io/docs/en/cli) passed to the `npm test` command.

```bash
# Run all tests
npm test

# Run unit tests only
npm test -- --selectProjects unit

# Run e2e tests only
npm test -- --selectProjects e2e

# Run all tests for single project
npm test -- --runTestsByPath packages/{project folder}
```
