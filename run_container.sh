MODEL_NAME="small-model"
PROJECT_ID="articulate-rain-321323"
CUSTOM_PREDICTOR_IMAGE_URI="gcr.io/${PROJECT_ID}/serve_${MODEL_NAME}"

docker run --cap-add SYS_NICE -t -d --rm -p 7080:7080 -v ./config.properties:/home/ubuntu/config.properties --name=local_model $CUSTOM_PREDICTOR_IMAGE_URI
