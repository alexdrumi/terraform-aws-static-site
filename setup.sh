#!/bin/bash

export $(grep -v '^#' .env | xargs)
echo $TF_VAR_key_name
