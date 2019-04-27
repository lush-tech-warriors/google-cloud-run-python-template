# Google Cloud Run Flask Template

A basic template for locally developing, live debugging and deploying a Flask app to [Cloud Run](https://cloud.google.com/run/).

## Requirements

[Docker](https://docs.docker.com/install/) for local development with live debugging.

[gcloud](https://cloud.google.com/sdk/install) to deploy to Cloud Run.

## Local Development & Live Debugging

The app can be built with `docker-compose build` and then run with `docker-compose run`.

After which you'll be able to view the app at [localhost:8080](http://localhost:8080/).

Any changes to the code will be reflected after a page refresh.

## Deploying

**As Cloud Run is in Beta you'll need to install the gcloud beta component:**

`gcloud components install beta`.

**Using Cloud Build, build and host your image:**

`gcloud builds submit --tag gcr.io/[PROJECT-ID]/helloworld`
Replacing [PROJECT-ID] with your GCP project ID. You can view a list of projects available to you by using `gcloud projects list`.

**Deploy your image to Cloud Run:**

You can either deploy your app through the web UI at [cloud.google.com/run](https://cloud.google.com/run) or by via the command-line as shown below.

`gcloud beta run deploy --image gcr.io/[PROJECT-ID]/helloworld`
Again replacing [PROJECT-ID] with your GCP project ID.

When prompted, select region us-central1 as Cloud Run is currently only available here, confirm the service name, and respond y to allow unauthenticated invocations.

Wait a few moments until the deployment is complete. On success, the command line displays the service URL.

## Continuous Deployment from Github

### Edit cloudbuild.yaml

In the repository root edit cloudbuild.yaml by replacing **[SERVICE-NAME]** and **[REGION]** with the name and region of the Cloud Run service you are deploying to.

### Grant the "Cloud Run Admin" and "Service Account User" roles to the Cloud Build service account

We'll need to need to know the name of your Cloud Build service account, it will have the suffix *@cloudbuild.gserviceaccount.com*.

You can find it using the following:

`gcloud projects get-iam-policy [PROJECT-ID] | grep @cloudbuild.gserviceaccount.com`
Replacing [PROJECT-ID] with your GCP project ID.

Once we have the we the Cloud Build service account we can grant the *run.admin* role to allow Cloud Build to manipulate Cloud Run resources, and the *iam.serviceAccountUser* role to allow Cloud Build to act as other service accounts, which include your Cloud Run services, by using the following:

 `gcloud projects add-iam-policy-binding tech-warriors-stage-global --member='[SERVICE-ACCOUNT]' --role='roles/run.admin'`

 `gcloud projects add-iam-policy-binding tech-warriors-stage-global --member='[SERVICE-ACCOUNT]' --role='roles/iam.serviceAccountUser'`

### Create a Build Trigger

*We'll need to do this part using the cloud.google.com site as there is not yet a way to create a build trigger through gcloud, see [this issue](https://github.com/GoogleCloudPlatform/cloud-builders/issues/99) if you are interested in more information.*

1. Visit the [Cloud Build triggers page](https://console.cloud.google.com/cloud-build/triggers)

2. Click Create Trigger.

3. From the displayed repository list, select your repository and click Continue. For more information on specifying which branches to autobuild, see [Creating a build trigger](https://cloud.google.com/cloud-build/docs/running-builds/automate-builds#creating_a_build_triggerr).

4. Select cloudbuild.yaml in Build Configuration.

5. Click Create.

**You're finished! From this point on, anytime you push to your repository, you automatically trigger a build and a deployment to your Cloud Run service.**
