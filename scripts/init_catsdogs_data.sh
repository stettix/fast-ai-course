#!/usr/bin/env bash
# This script takes data from the Cats vs Dogs Kaggle competition and
# puts it in a directory structure suitable for the Lesson 1 notebook,
# e.g. moving each class of image into its own directory, creating a sample set,
# validation sets etc.

# Create directory structure

mkdir models

mkdir -p train/cat
mkdir train/dog
mkdir -p sample/train/cat
mkdir sample/train/dog

mkdir test1/unknown
mkdir sample/test1/unknown

mkdir -p valid/cat
mkdir valid/dog
mkdir -p sample/valid/cat
mkdir -p sample/valid/dog

# Copy and move files as required
# Assumes input files are in 'train/(cat|dog).*.jpg', and 'test' subdirs of current dir.

# Move 1k files into the validation set
# Assumes training files haven't got bias in their ordering!
ls train | tail -n 1000 | xargs -I '{}' mv train/'{}' valid/

# Copy files into the sample datasets
find train -name 'dog*' | head -n 50  | xargs -I '{}' cp '{}' sample/train/
find train -name 'cat*' | head -n 50  | xargs -I '{}' cp '{}' sample/train/
find vaild -name 'dog*' | head -n 25  | xargs -I '{}' cp '{}' sample/valid/
find valid -name 'cat*' | head -n 25  | xargs -I '{}' cp '{}' sample/valid/
find test1 -name 'dog*' | head -n 50  | xargs -I '{}' cp '{}' sample/test/
find test1 -name 'cat*' | head -n 50  | xargs -I '{}' cp '{}' sample/test/
