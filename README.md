## Build
```bash
MODEL_NAME="YOUR MODEL NAME"
PROJECT_ID="YOUR GCP PROJECT ID"

CUSTOM_PREDICTOR_IMAGE_URI="gcr.io/${PROJECT_ID}/serve_${MODEL_NAME}"

DOCKER_BUILDKIT=1 docker build --build-arg http_proxy=$http_proxy --build-arg https_proxy=$https_proxy  --build-arg no_proxy=$no_proxy --build-arg MODEL_NAME=$MODEL_NAME --tag=$CUSTOM_PREDICTOR_IMAGE_URI -f Dockerfile .

```

## Run
```bash
# run docker container to start local TorchServe deployment
docker run -t -d --rm -p 7080:7080 --name=local_model $CUSTOM_PREDICTOR_IMAGE_URI
# delay to allow the model to be loaded in torchserve (takes a few seconds)
sleep 20
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


