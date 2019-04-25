# Google-Cloud-Run-Flask-Template

A basic template for locally developing, live debugging and deploying a Flask app to [Cloud Run](https://cloud.google.com/run/).

## Requirements

[Docker](https://docs.docker.com/install/) for local development with live debugging.

[gcloud](https://cloud.google.com/sdk/install) to deploy to Cloud Run.

## Local Development & Live Debugging

The app can be built with `docker-compose build` and then run with `docker-compose run`.

After which you'll be able to view the app at [localhost:8080](http://localhost:8080/).

Any changes to the code will be reflected after a page refresh.

## Deploying

As Cloud Run is in Beta you'll need to install the gcloud beta component:
`gcloud components install beta`

Using Cloud Build, build and host your image:
`gcloud builds submit --tag gcr.io/[PROJECT-ID]/helloworld`
Replacing [PROJECT-ID] with your GCP project ID. You can view a list of projects available to you by using `gcloud projects list`.

Deploy your image to Cloud Run:
`gcloud beta run deploy --image gcr.io/[PROJECT-ID]/helloworld`
Again replacing [PROJECT-ID] with your GCP project ID.

When prompted, select region us-central1 as Cloud Run is currently only available here, confirm the service name, and respond y to allow unauthenticated invocations.

Wait a few moments until the deployment is complete. On success, the command line displays the service URL.
