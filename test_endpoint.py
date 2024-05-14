import base64
from google.cloud import aiplatform
import sys

endpoint_name = sys.argv[1]

instance = [{
    "data": "Jaw dropping visual effects and action! One of the best I have seen to date."
}]

endpoint = aiplatform.Endpoint(endpoint_name)
prediction = endpoint.predict(instances=instance)
print(f"Prediction response: \n\t{prediction}")