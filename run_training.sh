

# https://github.com/mchiquier/textual_inversion

# cd textual_inversion

# # install required stuff:
# pip install -r requirements.txt

# # get intructpix2pix
# mkdir -p models/ldm/stable-diffusion-v1/
# wget -O models/ldm/stable-diffusion-v1/instruct-pix2pix-00-22000.ckpt http://instruct-pix2pix.eecs.berkeley.edu/instruct-pix2pix-00-22000.ckpt

#!/bin/bash

# Define source directories
train_a="train-a"
train_b="train-b"
train_a_dir="data/${train_a}"
train_b_dir="data/${train_b}"

# Define the split sizes
declare -a split_sizes=(9 5 2 1)

# Loop through each split size
for split_size in "${split_sizes[@]}"; do
    echo "Processing split size: $split_size"
    
    # Create directories for training and eval based on the split size
    mkdir -p "${train_a_dir}-${split_size}" "${train_b_dir}-${split_size}" "${train_a_dir}-eval-${split_size}"
    
    echo "Directories created for split size $split_size:"
    echo "${train_a_dir}-${split_size}"
    echo "${train_b_dir}-${split_size}"
    echo "${train_a_dir}-eval-${split_size}"
    
    # Copy the specified number of pairs for training
    for i in $(seq 1 $split_size); do
        cp "${train_a_dir}/${i}.jpg" "${train_a_dir}-${split_size}"
        cp "${train_b_dir}/${i}.jpg" "${train_b_dir}-${split_size}"
    done

    # Copy the remaining images for evaluation
    for i in $(seq $((split_size + 1)) 10); do
        cp "${train_a_dir}/${i}.jpg" "${train_a_dir}-eval-${split_size}"
    done

    export DATA_ROOT="${train_a_dir}-${split_size}"
    export EDIT_ROOT="${train_b_dir}-${split_size}"
    export EVAL_ROOT="${train_a_dir}-eval-${split_size}"
    export OUTPUT_PATH="results/${train_b}-${split_size}"

    echo "Environment variables set for split size $split_size:"
    echo "DATA_ROOT=$DATA_ROOT"
    echo "EDIT_ROOT=$EDIT_ROOT"
    echo "EVAL_ROOT=$EVAL_ROOT"
    echo "OUTPUT_PATH=$OUTPUT_PATH"

    # Uncomment to run your Python training command
    # python train_inversion.py --data_root=$DATA_ROOT \
    #                           --edit_root=$EDIT_ROOT \
    #                           --eval_root=$EVAL_ROOT \
    #                           --output_path=$OUTPUT_PATH \
    #                           --init_words "word1" "word2"
    
    # Optional: Cleanup - delete created directories after training is finished
    echo "Training finished for split size $split_size, deleting folders"
    rm -r "${train_a_dir}-${split_size}" "${train_b_dir}-${split_size}" "${train_a_dir}-eval-${split_size}"
done
