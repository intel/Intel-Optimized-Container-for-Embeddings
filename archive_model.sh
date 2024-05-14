#!/bin/bash

model_dir=$1
model_name=$2
model_version=$3
handler=$4
output_dir=$5

# get all extra files associated with a model trained with the sentence transformers framework
extra_files="$model_dir/model.safetensors,"
for file in "$model_dir"/*.json
do
    extra_files="${extra_files}${file},"
done

for file in "$model_dir"/*.txt
do
    extra_files="${extra_files}${file},"
done

for file in "$model_dir"*/*.json
do
    extra_files="${extra_files}${file},"
done

echo "$extra_files"


cmd="torch-model-archiver --model-name ${model_name} --version ${model_version} --serialized-file ${model_dir}/pytorch_model.bin --extra-files ${extra_files} --handler ${handler} --export-path ${output_dir}"
# cmd="torch-model-archiver --model-name ${model_name} --version ${model_version} --handler ${handler} --export-path ${output_dir}"

echo $cmd
eval $cmd
