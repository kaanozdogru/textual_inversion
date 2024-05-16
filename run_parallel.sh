#!/bin/bash

# List all directories in fewshot_data and store them in an array
# readarray -t all_classes < <(find /proj/vondrick2/ko2541/fewshot_data/fewshot_data -mindepth 1 -maxdepth 1 -type d -exec basename {} \;)
# Predefined list of classes
all_classes=('siamese_cat' 'peregine_falcon' 'cauliflower' 'espresso' 'radio')

# Calculate number of classes per GPU
num_gpus=8
num_classes=${#all_classes[@]}
classes_per_gpu=$(( (num_classes + num_gpus - 1) / num_gpus ))

# Create a directory for logs if it doesn't exist
mkdir -p logs

# Split the array into chunks and run each chunk on a separate GPU
for (( i=0; i<num_classes; i+=classes_per_gpu )); do
    # Calculate GPU index
    gpu_index=$((i / classes_per_gpu))

    # Extract chunk of classes for current GPU
    chunk=("${all_classes[@]:i:classes_per_gpu}")
    
    # Join the chunk into a comma-separated string
    chunk_str=$(IFS=,; echo "${chunk[*]}")
    echo "GPU INDEX: $gpu_index:"
    echo $chunk_str
    # Run train.sh with the current chunk of classes, and log output
    CUDA_VISIBLE_DEVICES=$gpu_index ./run_training.sh "$chunk_str" > "logs/gpu_${gpu_index}.log" 2>&1 &
done

# Wait for all GPUs to finish
wait
