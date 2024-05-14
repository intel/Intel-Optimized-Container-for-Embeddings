#!/bin/bash
set -e

eval ". ./miniconda3/bin/activate"

eval "conda activate py310"

serve_cmd="torchserve --start --ts-config=/home/ubuntu/config.properties --models ${MODEL_NAME_}=${MODEL_NAME_}.mar --model-store /home/ubuntu/model_store"

eval $serve_cmd
# prevent docker exit
tail -f /dev/null