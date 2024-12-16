# AshBaseTemplate

Base project using Ash and Phoenix, with authentication, authorization, email sending, security for apis, and error tracking and more.

Features:
- Github actions setup for all checks and deployment to Fly.io
- Formatters configured
- Authentication and authorization samples
- Protected admin
- Simple User roles
- Automatic version update, tag and release creation.

Pre commit to run:

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
