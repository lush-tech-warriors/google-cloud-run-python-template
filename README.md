[![Python 3.7](https://img.shields.io/badge/python-3.7-blue.svg)](https://www.python.org/downloads/release/python-370/) [![Google Cloud Run Python Template Issues](https://img.shields.io/github/issues/LUSHDigital/Google-Cloud-Run-Python-Template.svg)](https://github.com/LUSHDigital/Google-Cloud-Run-Python-Template/issues)

# Google Cloud Run Python Template

A basic template for locally developing, live debugging and deploying a Python app to [Cloud Run](https://cloud.google.com/run/), with examples for [Flask](http://flask.pocoo.org/) & [Hug](https://www.hug.rest/).

Table of Contents
=================

   * [Requirements](#requirements)
   * [Setup](#setup)
   * [Local Development &amp; Live Debugging](#local-development--live-debugging)
   * [Deploying](#deploying)

   * [Optional Extras](#optional-extras)
       * [Continuous Deployment from Github](#continuous-deployment-from-github)
       * [Connecting to GCP services](#connecting-to-gcp-services)


## Requirements

[Docker](https://docs.docker.com/install/) for local development with live debugging.

[gcloud](https://cloud.google.com/sdk/install) to deploy to Cloud Run.

## Setup

Docker expects your app to live in the `app` directory, you can rename either [flask-app](flask-app) or [hug-app](hug-app) to `app` to use either template.

Edit [Dockerfile](Dockerfile) and uncomment the `CMD` line for either Flask or Hug.

## Local Development & Live Debugging

The app can be built with `docker-compose build` and then run with `docker-compose run`.

After which you'll be able to view the app at [localhost:80](http://localhost:80/).

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

---

## Optional Extras

### Continuous Deployment from Github

#### 1. Edit cloudbuild.yaml

In the repository root edit cloudbuild.yaml by replacing **[SERVICE-NAME]** and **[REGION]** with the name and region of the Cloud Run service you are deploying to.

#### 2. Grant the "Cloud Run Admin" and "Service Account User" roles to the Cloud Build service account

We'll need to need to know the name of your Cloud Build service account, it will have the suffix *@cloudbuild.gserviceaccount.com*.

You can find it using the following:

`gcloud projects get-iam-policy [PROJECT-ID] | grep @cloudbuild.gserviceaccount.com`
Replacing [PROJECT-ID] with your GCP project ID.

Once we have the we the Cloud Build service account we can grant the *run.admin* role to allow Cloud Build to manipulate Cloud Run resources, and the *iam.serviceAccountUser* role to allow Cloud Build to act as other service accounts, which include your Cloud Run services, by using the following:

 `gcloud projects add-iam-policy-binding tech-warriors-stage-global --member='[SERVICE-ACCOUNT]' --role='roles/run.admin'`

 `gcloud projects add-iam-policy-binding tech-warriors-stage-global --member='[SERVICE-ACCOUNT]' --role='roles/iam.serviceAccountUser'`

#### 3. Create a Build Trigger

*We'll need to do this part using the cloud.google.com site as there is not yet a way to create a build trigger through gcloud, see [this issue](https://github.com/GoogleCloudPlatform/cloud-builders/issues/99) if you are interested in more information.*

1. Visit the [Cloud Build triggers page](https://console.cloud.google.com/cloud-build/triggers)

2. Click Create Trigger.

3. From the displayed repository list, select your repository and click Continue. For more information on specifying which branches to autobuild, see [Creating a build trigger](https://cloud.google.com/cloud-build/docs/running-builds/automate-builds#creating_a_build_triggerr).

4. Select cloudbuild.yaml in Build Configuration.

5. Click Create.

**You're finished! From this point on, anytime you push to your repository, you automatically trigger a build and a deployment to your Cloud Run service.**

---

### Connecting to GCP services

You can use Cloud Run with the supported GCP services using the client libraries provided by these products. For a list of services supported, and not [see here](https://cloud.google.com/run/docs/using-gcp-services#services_and_tools_recommended_for_use).

There is plenty official documentation with examples of how to use Python client libraries for each GCP service, you may find it easier to read through these first but for quick reference some examples of common services has been supplied in [gcp-services-examples](gcp-services-examples). You will need to uncomment the relevant lines in `app/requirements.txt` for the GCP services that you use.

#### Connecting to GCP services in Cloud run

Note that Cloud Run uses a default runtime service account that has the **Project > Editor** role, which means it is able to call all GCP APIs. You do not need to provide credentials manually inside Cloud Run container instances when using the GCP client libraries.

#### Connecting to GCP services locally

When developing locally however you will need to supply credentials.

Create the service account. Replace **[NAME]** with a name for the service account.

1. `gcloud iam service-accounts create [NAME]`

Grant permissions to the service account. Replace **[PROJECT_ID]** with your project ID.

2. `gcloud projects add-iam-policy-binding [PROJECT_ID] --member "serviceAccount:[NAME]@[PROJECT_ID].iam.gserviceaccount.com" --role "roles/owner"`

Generate the key file and store it in the **service_account** directory of the repository.

`gcloud iam service-accounts keys create service_account/sa.json --iam-account [NAME]@[PROJECT_ID].iam.gserviceaccount.com`
