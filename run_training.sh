

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

# Create directories for the first split (9 train + 1 eval)
mkdir -p "${train_a_dir}-9" "${train_b_dir}-9" "${train_a_dir}-eval-9"

echo "Directories created:"
echo "${train_a_dir}-9"
echo "${train_b_dir}-9"
echo "${train_a_dir}-eval-9"

# Copy the first 9 pairs for training
for i in $(seq 1 9); do
    cp "${train_a_dir}/${i}.jpg" "${train_a_dir}-9"
    cp "${train_b_dir}/${i}.jpg" "${train_b_dir}-9"
done

# Copy the 10th image for evaluation
cp "${train_a_dir}/10.jpg" "${train_a_dir}-eval-9"

export DATA_ROOT="${train_a_dir}-9"
export EDIT_ROOT="${train_b_dir}-9"
export EVAL_ROOT="${train_a_dir}-eval-9"
export OUTPUT_PATH="results/${train_b}"

echo "Exported:"
echo DATA_ROOT
echo $DATA_ROOT
echo EDIT_ROOT
echo $EDIT_ROOT
echo EVAL_ROOT
echo $EVAL_ROOT
echo OUTPUT_PATH
echo $OUTPUT_PATH

# python train_inversion.py --data_root=$DATA_ROOT \
#                           --edit_root=$EDIT_ROOT \
#                           --eval_root=$EVAL_ROOT \
#                           --output_path=$OUTPUT_PATH \
#                           --init_words "word1" "word2"

echo "Training finished, deleting folders"
rm -r $DATA_ROOT $EDIT_ROOT $EVAL_ROOT
# # Create directories for the second split (5 train + 5 eval)
# mkdir -p train-a-5 train-b-5 eval-5

# # Copy the first 5 pairs for training
# for i in $(seq 1 5); do
#     cp "${train_a_dir}/${i}.png" "train-a-5/"
#     cp "${train_b_dir}/${i}.png" "train-b-5/"
# done

# # Copy the next 5 images for evaluation
# for i in $(seq 6 10); do
#     cp "${train_a_dir}/${i}.png" "eval-5/"
# done

# echo "Folders prepared for training and evaluation."



