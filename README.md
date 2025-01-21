# AshBaseTemplate

Base project using Ash and Phoenix, with authentication, authorization, email sending, security for apis, error tracking and more.

## Features

- Github actions setup for all checks and deployment to Fly.io
- Formatters configured
- Authentication and authorization samples
- Protected admin
- Simple User roles
- Automatic version update, tag and release creation.
- Dependabot and Renovate setup for all dependencies (pick 1)
- Honeybadger and Sentry and in project error tracking

## After cloning

### Install pre-commit

<https://pre-commit.com/#install>

### Rename all folders and modules according to your project

### Get dependencies

```bash
mix deps.get
```

### Rename project

```bash
mix rename AshBaseTemplate MyNewProject
```

### Setup the database

```bash
mix ash.setup
```

### Test pre-commit

```bash
pre-commit run --all-files
```

### Start the project

```bash
mix phx.server
```

- Home: <http://localhost:4000>
- Sign in: <http://localhost:4000/sign-in>
  - After registering or requesting the magic link, you will see in the terminal the link to login.
- Admin: <http://localhost:4000/admin>
  - You have to update the user you registered to have the role `admin` in the database.
- Swagger: <http://localhost:4000/swagger>

### Pre commit to run:

- Dialyzer
- Sobelow
- mix format
- credo
- mix tests, with bash script to only run tests related to modifications we have done

Other features:

- Oban for background jobs, and ObanLiveDashboard for monitoring.
- Error tracking / reporting using Tower.
- Email sending with Swoosh.
- Auth using AshAuthentication.
- Security for APIs with OpenApiSpex and Plug.Cors.
- Error reporting with TowerErrorTracker.
- Testing with ExUnit, Mneme, Mox, and Smokestack.
- Code quality with Credo, Styler.
- Security scanning with Sobelow, Hammer and MixAudit.
