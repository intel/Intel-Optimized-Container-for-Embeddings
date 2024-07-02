# build ipex base container
git clone https://github.com/intel/intel-extension-for-pytorch.git
cd intel-extension-for-pytorch
git reset --hard f20a79e
git submodule sync
git submodule update --init --recursive
DOCKER_BUILDKIT=1 docker build --network=host -f docker/Dockerfile.compile -t intel-extension-for-pytorch:main .

# build model container
cd ..
DOCKER_BUILDKIT=1 docker build --network=host --build-arg MODEL_NAME="intel_embedding_model" -f Dockerfile -t "intel-text-embedding:latest" .

# clean up
rm -rf intel-extension-for-pytorch