#!/bin/bash

conda deactivate
\rm -Rf build
\rm -Rf opt/bin
\rm -Rf opt/mamba
\rm -f log.*
git checkout opt/mamba