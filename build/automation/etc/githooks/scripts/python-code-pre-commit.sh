#!/bin/bash

cd $(git rev-parse --show-toplevel)/application
make -s code-format code-check
