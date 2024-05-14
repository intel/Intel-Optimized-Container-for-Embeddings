## Build
```bash
MODEL_NAME="YOUR MODEL NAME"
PROJECT_ID="YOUR GCP PROJECT ID"

CUSTOM_PREDICTOR_IMAGE_URI="gcr.io/${PROJECT_ID}/serve_${MODEL_NAME}"

# remove the proxy args if you aren't running within intel network
DOCKER_BUILDKIT=1 docker build --build-arg http_proxy=$http_proxy --build-arg https_proxy=$https_proxy  --build-arg no_proxy=$no_proxy --build-arg MODEL_NAME=$MODEL_NAME --tag=$CUSTOM_PREDICTOR_IMAGE_URI -f Dockerfile .

```

## Run
Run with built-in torchserve config:
```bash
docker run --cap-add SYS_NICE -t -d --rm -p 7080:7080 --name=local_model $CUSTOM_PREDICTOR_IMAGE_URI

```

Run with custom config:
```bash
docker run --cap-add SYS_NICE -t -d --rm -p 7080:7080 -v ./config.properties:/home/ubuntu/config.properties --name=local_model $CUSTOM_PREDICTOR_IMAGE_URI
```

## Test
```bash
curl -s -X POST \
  -H "Content-Type: application/json" \
  -d @./instances.json \
  http://localhost:7080/predictions/$MODEL_NAME/
```

## Push to GCP
```bash
docker push $CUSTOM_PREDICTOR_IMAGE_URI
```

## Deploy to VertexAI
```python
python upload_and_deploy.py {MODEL_NAME}
```

## Test Endpoint
```python
python test_endpoint.py {ENDPOINT_NAME}
```

