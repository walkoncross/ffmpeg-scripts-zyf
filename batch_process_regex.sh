#!/bin/bash

ls $1 | xargs -I '{}' $2 '{}' $3
