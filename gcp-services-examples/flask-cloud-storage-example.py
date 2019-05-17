##########################################################
#                                                        #
# Please view README.md for Cloud Storage prerequisites. #
#                                                        #
# Check requirements.txt for dependencies                #
#                                                        #
##########################################################

import os, urllib.request, json
# Imports the Google Cloud client library
from google.cloud import storage

from flask import Flask

app = Flask(__name__)

# Example - create a bucket from URI
@app.route('/create-storage/<bucket>')
def createStorage(bucket):

    # Instantiates a client
    storage_client = storage.Client()

    # The name for the new bucket
    bucket_name = bucket

    # Creates the new bucket
    bucket = storage_client.create_bucket(bucket_name)

    # [END storage_quickstart]
    return 'Bucket {} created.'.format(bucket.name)

if __name__ == "__main__":
    app.run(debug=True,host='0.0.0.0',port=int(os.environ.get('PORT', 80)))
