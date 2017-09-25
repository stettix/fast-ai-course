#!/usr/bin/env bash
# This script takes data from the Cats vs Dogs Kaggle competition and
# puts it in a directory structure suitable for the Lesson 1 notebook,
# e.g. moving each class of image into its own directory, creating a sample set,
# validation sets etc.

ROOT=${1? "Missing root directory parameter"}

set -x
set -e

# Create directory structure

mkdir -p models
# Download the VGG weights (vgg16.h5) to this directory separately

mkdir -p train/cat
mkdir -p train/dog
mkdir -p sample/train/cat
mkdir -p sample/train/dog

mkdir -p test1/unknown
mkdir -p sample/test1/unknown

mkdir -p valid/cat
mkdir -p valid/dog
mkdir -p sample/valid/cat
mkdir -p sample/valid/dog

# Copy and move files as required
# Assumes input files are in 'train/(cat|dog).*.jpg', and 'test' subdirs of current dir.

# The main train and test datasets
# We need to split the train set into directories by class
find $ROOT/train -name 'dog*.jpg' | xargs -I '{}' cp '{}' train/dog
find $ROOT/train -name 'cat*.jpg' | xargs -I '{}' cp '{}' train/cat
find $ROOT/test -name '*.jpg' | xargs -I '{}' cp '{}' test1/

# Move 1k files into the validation set
ls train/dog | tail -n 500 | xargs -I '{}' mv $ROOT/train/'{}' valid/dog
ls train/cat | tail -n 500 | xargs -I '{}' mv $ROOT/train/'{}' valid/cat

# Copy files into the sample datasets
find train/dog -name 'dog*.jpg' | head -n 50 | xargs -I '{}' cp '{}' sample/train/dog
find train/cat -name 'cat*.jpg' | head -n 50 | xargs -I '{}' cp '{}' sample/train/cat
find valid -name 'dog*.jpg' | head -n 25 | xargs -I '{}' cp '{}' sample/valid/dog
find valid -name 'cat*.jpg' | head -n 25 | xargs -I '{}' cp '{}' sample/valid/cat
find test1 -type f | head -n 50 | xargs -I '{}' cp '{}' sample/test1/unknown
