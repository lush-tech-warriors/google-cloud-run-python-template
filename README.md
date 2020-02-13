<p align="center">
  <a href="" rel="noopener">
 <img width=200px height=200px src="https://i.imgur.com/j6CDEN6.png" alt="LUSH logo"></a>
</p>

<h3 align="center">Google Cloud Run Python Template</h3>

<div align="center">

[![Python 3.7](https://img.shields.io/badge/python-3.7-blue.svg)](https://www.python.org/downloads/release/python-370/) [![Google Cloud Run Python Template Issues](https://img.shields.io/github/issues/LUSHDigital/Google-Cloud-Run-Python-Template.svg)](https://github.com/LUSHDigital/Google-Cloud-Run-Python-Template/issues) [![Requirements Status](https://requires.io/github/LUSHDigital/Google-Cloud-Run-Python-Template/requirements.svg?branch=master)](https://requires.io/github/LUSHDigital/Google-Cloud-Run-Python-Template/requirements/?branch=master)

</div>

---

## 📝 Table of Contents
- [About](#about)
- [Quickstart](#quickstart)
- [Local Development &amp; Live Debugging](#local_development)
- [Deploying](#deploying)
  - [Continuous Deployment from Github via Terraform](#continuous-deployment-from-github-via-terrafrom)
  - [One off Deployment](#one-off-deployment)
  - [Continuous Deployment from Github via gCloud](#continuous-deployment-from-github-via-gcloud)
- [Extending & Developing](#extending_and_developing)
- [Optional Extras](#optional-extras)
    - [Connecting to GCP services](#connecting-to-gcp-services)
    - [Hug not Flask](hug-not-flask)
- [TODO](#TODO)
- [Contributing](../CONTRIBUTING.md)
- [Authors](#authors)

## 📖 About <a name = "about"></a>
A template for developing and deploying a [Cloud Run](https://cloud.google.com/run/) Python app, with a ready to use local development environment, automated builds and lots of optional extras.

## 👟 Quickstart <a name = "quickstart"></a>

__💥Just get me a Cloud Run Python App!💥__

The quickest way to get started is it fork this repo and deploy by following the "[Continuous Deployment from Github via Cloud Build](#continuous-deployment-from-github-via-cloud-build)" instructions.

Then make your code changes in [/app](app), commit and push to GitHub, this will trigger an automatic build and deployment, you'll see your app building at [console.cloud.google.com/cloud-build/triggers](https://console.cloud.google.com/cloud-build/triggers), once built you'll find your app at [console.cloud.google.com/run](https://console.cloud.google.com/run).

## 💻 Local Development & Live Debugging <a name = "local_development"></a>

> Requirements: [Docker](https://docs.docker.com/install/).


The app can be built with `docker-compose build` and then run with `docker-compose run`. After which you'll be able to view the app at [localhost:80](http://localhost:80/).

The application lives in [/app](app), a "Hello World" Flask app has been supplied by default but you can of course change this to whatever you prefer.

There is also a [Hug](https://www.hug.rest/) template available, see [Hug not Flask](hug-not-flask).

Any changes to the code will be reflected after a page refresh.


## 🚀 Deploying to Cloud Run<a name = "deploying"></a>

- [Deployment Option A - Continuous Deployment from Github via Cloud Build](#continuous-deployment-from-github-via-cloud-build)
- [Deployment Option B - Continuous Deployment from Github via Terraform](#continuous-deployment-from-github-via-terrafrom)
- [Deployment Option C - One off Deployment](#one-off-deployment)

### Deployment Option A - Continuous Deployment from Github via Cloud Build <a name = "continuous-deployment-from-github-via-gcloud"></a>

> Requirements: [gcloud](https://cloud.google.com/sdk/install).

#### 1. Grant the "Cloud Run Admin" and "Service Account User" roles to the Cloud Build service account

We'll need to need to know the name of your Cloud Build service account, it will have the suffix *@cloudbuild.gserviceaccount.com*.

You can find it using the following:

`gcloud projects get-iam-policy [PROJECT-ID] | grep @cloudbuild.gserviceaccount.com`
Replacing [PROJECT-ID] with your GCP project ID.

Once we know the Cloud Build service account we can grant the *run.admin* role to allow Cloud Build to manipulate Cloud Run resources, and the *iam.serviceAccountUser* role to allow Cloud Build to act as other service accounts, which include your Cloud Run services, by using the following:

 `gcloud projects add-iam-policy-binding [PROJECT_ID] --member='serviceAccount:[SERVICE-ACCOUNT]' --role='roles/run.admin'`

 `gcloud projects add-iam-policy-binding [PROJECT_ID] --member='serviceAccount:[SERVICE-ACCOUNT]' --role='roles/iam.serviceAccountUser'`

Again, in both, replacing [PROJECT-ID] with your GCP project ID, and [SERVICE-ACCOUNT] with the account discovered in the previous step.

#### 2. Connect repository & Create a Build Trigger

*The gcloud build trigger command is currently in alpha and has limited functionality, connecting a GitHub source is not get supported through gcloud and so has to be done via the UI, enabling the trigger is currently easier through the UI*

1. Visit the [Cloud Build Repository Connect page](https://console.cloud.google.com/cloud-build/triggers/connect)

2. Select the `GitHub (Cloud Build GitHub App)` and follow the steps though to the final page.

3. On the final page, select `Create Trigger`. You should be taken back to the main Build triggers page.

**You're finished! From this point on, anytime you push to your repository, you automatically trigger a build and a deployment to your Cloud Run service.**

### Deployment Option B -  Continuous Deployment from Github via Terrafrom <a name = "continuous-deployment-from-github-via-terrafrom"></a>

*The gcloud build trigger command is currently in alpha and has limited functionality, connecting a GitHub source is not get supported through gcloud and so has to be done via the UI, and therefore not supported by Terraform, enabling the trigger is currently easier through the UI but I have created a Terraform config both incase you need to keep infrastructure as code and in the hopes that this can be expanded upon in the future.*

> Requirements: [Terraform](https://www.terraform.io/).

1. run `terraform init` to make sure you have everything you need, Terraform will prompt for permission to pull any missing requirements.

2. Update [variables.tf](variables.tf) with your information.

3. run `terraform apply `, Terraform will supply you with warning and link if your GitHub repo is not linked to Google Cloud, if all is well it will then show you what it intends to build, type `yes` to deploy.

Your service will be built and deployed every time you `git push` to the master branch. Once you have pushed a commit, you'll see your app building at [console.cloud.google.com/cloud-build/triggers](https://console.cloud.google.com/cloud-build/triggers), and once it's built you'll find your app at [console.cloud.google.com/run](https://console.cloud.google.com/run).

### Deployment Option C -  One-off Deployment <a name = "one-off-deployment"></a>

> Requirements: [gcloud](https://cloud.google.com/sdk/install).

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

## ☑ TODO <a name = "TODO"></a>

- [x] Add Terraform.
- [ ] This TODO list.

## ✍️ Authors <a name = "authors"></a>
- [@Simon-Ince](https://github.com/Simon-Ince)

## 🔧 Optional Extras

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

### Hug not Flask

If you'd rather use [Hug](https://www.hug.rest/) instead of Flask you can delete the `app` direcory and rename [hug-app](hug-app) to `app`, you'll also need to edit [Dockerfile](Dockerfile) and remove the final `CMD` line, then uncomment the `CMD` line Hug.
