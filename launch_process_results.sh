#!/bin/bash

# to run without logging set to null
logger=null
silent=False
override=True

#PRINT=true
PRINT=false

#config_name="micro_macro"
config_name="complete_rebel"

for wrp in epfl-dlab/SynthIE/17a7v0s6 epfl-dlab/SynthIE/2h4ibqlg epfl-dlab/SynthIE/3bpuesm4 #epfl-dlab/SynthIE/2mlj6x38
do
  if [ $PRINT == true ]
  then
    echo python run_process_predictions.py +experiment/process_predictions=$config_name wandb_run_path="$wrp" silent=$silent override=$override
  else
    python run_process_predictions.py +experiment/process_predictions=$config_name wandb_run_path="$wrp" silent=$silent override=$override
  fi
done
