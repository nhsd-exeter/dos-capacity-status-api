#!/bin/bash

make -s python-code-format python-code-check \
  FILES=application/api \
  EXCLUDE=application/api/service/documentation.py
