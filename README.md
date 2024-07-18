# Intel Optimized Container for Embeddings
The Intel Optimized Container for Embeddings is a lightweight text embeddig model that can be used for a variety of NLP tasks. The model is distilled from [UAE-Large-v1](https://huggingface.co/WhereIsAI/UAE-Large-V1) using the the sentence-transformers and Intel&reg; Extension for Pytorch (IPEX) frameworks. It is a 23M parameter model with an input sequence length of 512 and output embedding size of 512. It achieves average accuracies of 46% and 82% on the MTEB Retrieval and STS tasks respectively.

## Cloning
The model files are stored using git LFS. Make sure to install [git LFS](https://github.com/git-lfs/git-lfs/blob/main/INSTALLING.md) before cloning this repo.


## Build
You can build the model serving container using the following script. This may take a while as it builds the IPEX base image from source.
```bash
./build.sh
```
NOTE: If you are behind a proxy, you will need to add it to the docker build commands \
i.e. ```--build-arg http_proxy=$http_proxy```
## Run
This model is optimized for Intel&reg; Xeon&reg; Archicture using Intel&reg; Extension for Pytorch (IPEX) and enables the use of the latest Intel&reg; Advanced Matrix Extensions (AMX) for accelerated BF16 inference.

Run with built-in torchserve config:
```bash
docker run --network=host --cap-add SYS_NICE -t -d --rm -p 7080:7080 --name=local_model intel-text-embedding:latest

```

Run with custom config:
```bash
docker run --network=host --cap-add SYS_NICE -t -d --rm -p 7080:7080 -v ./config.properties:/home/ubuntu/config.properties --name=local_model intel-text-embedding:latest
```

## Local Test
```bash
curl -s -X POST \
  -H "Content-Type: application/json" \
  -d @./instances.json \
  http://localhost:7080/predictions/intel_embedding_model/
```

### Training Datasets

| Dataset       | Description           | License  |
| ------------- |:-------------:| -----:|
| beir/dbpedia-entity      | DBpedia-Entity is a standard test collection for entity search over the DBpedia knowledge base.  | CC-BY-SA 3.0 |
| beir/nq      | To help spur development in open-domain question answering, the Natural Questions (NQ) corpus has been created, along with a challenge website based on this data.       |   CC-BY-SA 3.0 |
| beir/scidocs | SciDocs is a new evaluation benchmark consisting of seven document-level tasks ranging from citation prediction, to document classification and recommendation.       |    CC-BY-SA-4.0  |
| beir/trec-covid | TREC-COVID followed the TREC model for building IR test collections through community evaluations of search systems.       |  CC-BY-SA-4.0  |
| beir/touche2020 | Given a question on a controversial topic, retrieve relevant arguments from a focused crawl of online debate portals.      |    CC-BY-4.0  |
| WikiAnswers | The WikiAnswers corpus contains clusters of questions tagged by WikiAnswers users as paraphrases.       |    MIT |
| Cohere/wikipedia-22-12-en-embeddings Dataset  | The Cohere/Wikipedia dataset is a processed version of the wikipedia-22-12 dataset. It is English only, and the articles are broken up into paragraphs.       |    Apache 2.0  |
| MLNI  | GLUE, the General Language Understanding Evaluation benchmark (https://gluebenchmark.com/) is a collection of resources for training, evaluating, and analyzing natural language understanding systems.       |    MIT |
