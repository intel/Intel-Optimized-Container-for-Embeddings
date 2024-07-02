# build off of ipex image
FROM intel-extension-for-pytorch:main AS base

ARG MODEL_NAME
ENV MODEL_NAME_=${MODEL_NAME}

# copy model files
COPY ./model_handler.py /home/ubuntu/
COPY ./model_files /home/ubuntu/model_files
COPY ./archive_model.sh /home/ubuntu/
COPY ./entrypoint.sh /home/ubuntu/
RUN mkdir model_store

USER root
WORKDIR /home/ubuntu

# create ts config file
RUN printf "\nservice_envelope=json" >> /home/ubuntu/config.properties
RUN printf "\ninference_address=http://0.0.0.0:7080" >> /home/ubuntu/config.properties
RUN printf "\nmanagement_address=http://0.0.0.0:7081" >> /home/ubuntu/config.properties
RUN printf "\nmodel_store=/home/ubuntu/model_store" >> /home/ubuntu/config.properties
RUN printf "\nload_models=${MODEL_NAME}.mar" >> /home/ubuntu/config.properties
RUN printf "\ndefault_workers_per_model=1" >> /home/ubuntu/config.properties
RUN printf "\nipex_enable=true" >> /home/ubuntu/config.properties
RUN printf "\ncpu_launcher_enable=true" >> /home/ubuntu/config.properties
RUN printf '\ncpu_launcher_args=--skip-cross-node-cores' >> /home/ubuntu/config.properties


# install torchserve and its dependencies into conda environment from ipex image
RUN apt-get update && \
    git clone https://github.com/pytorch/serve.git && \
    cd serve && \
    git reset --hard b4bbc29 && \
    cd /home/ubuntu && \
    . ./miniconda3/bin/activate && \
    conda activate py310 && \
    DEBIAN_FRONTEND=noninteractive python serve/ts_scripts/install_dependencies.py && \
    conda install torchserve==0.11.0 torch-model-archiver==0.11.0 torch-workflow-archiver==0.2.13 -c pytorch && \
    conda install transformers==4.38.1 && \
    conda deactivate && \
    rm -rf serve

USER ubuntu

# expose ports
EXPOSE 7080
EXPOSE 7081

# archive model
RUN . ./miniconda3/bin/activate && \
    conda activate py310 && \
    ./archive_model.sh /home/ubuntu/model_files \
    ${MODEL_NAME_} \
    1.0 \
    /home/ubuntu/model_handler.py \
    /home/ubuntu/model_store



# run Torchserve HTTP serve to respond to prediction requests
ENTRYPOINT ./entrypoint.sh

