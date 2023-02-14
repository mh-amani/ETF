#!/bin/bash

#PRINT=true
PRINT=false

run_name_prefix="inf_"
logger="wandb_team"

#inference_trainer_config="_ms_single"
inference_trainer_config="_ms_ddp"
#inference_trainer_config="_gcp_large_ddp"

# Free generation -> ++model.constraint_module=null

# Test small (Rebel) -> datamodule.dataset_parameters.test.dataset.load_dataset_params.split=test_small
# Test small (SDG) -> datamodule.dataset_parameters.test.dataset.load_dataset_params.split=test_small_ordered

#for lp in 0.8 0.6
#do
#  for datamodule in rebel_pc_small # sdg_text_davinci_003_pc_small sdg_code_davinci_002_pc_small
#  do
#    for model in fe_fully_synthetic_gcp_large_last fe_fully_synthetic_gcp_large
#    do
#      if [ $PRINT == true ]
#      then
#        echo python run_inference.py +experiment/inference=[$model,$inference_trainer_config] datamodule=$datamodule model.hparams_overrides.inference.hf_generation_params.length_penalty=$lp logger=$logger run_name_prefix=$run_name_prefix
#      else
#        python run_inference.py +experiment/inference=[$model,$inference_trainer_config] datamodule=$datamodule model.hparams_overrides.inference.hf_generation_params.length_penalty=$lp logger=$logger run_name_prefix=$run_name_prefix datamodule.debug=True datamodule.debug_k=2000 ++model.constraint_module=null
#      fi
#    done
#  done
#done
#
#for lp in 0.8 0.6
#do
#  for datamodule in rebel_pc_small # sdg_text_davinci_003_pc_small sdg_code_davinci_002_pc_small
#  do
#    for model in fe_fully_synthetic_gcp_large_last fe_fully_synthetic_gcp_large
#    do
#      if [ $PRINT == true ]
#      then
#        echo python run_inference.py +experiment/inference=[$model,$inference_trainer_config] datamodule=$datamodule model.hparams_overrides.inference.hf_generation_params.length_penalty=$lp logger=$logger run_name_prefix=$run_name_prefix
#      else
#        python run_inference.py +experiment/inference=[$model,$inference_trainer_config] datamodule=$datamodule model.hparams_overrides.inference.hf_generation_params.length_penalty=$lp logger=$logger run_name_prefix=$run_name_prefix datamodule.debug=True datamodule.debug_k=2000
#      fi
#    done
#  done
#done

#for lp in 0.8
#do
#  for datamodule in sdg_text_davinci_003_pc_small sdg_code_davinci_002_pc_small
#  do
#    for model in fe_fully_synthetic_gcp_large_last
#    do
#      if [ $PRINT == true ]
#      then
#        echo python run_inference.py +experiment/inference=[$model,$inference_trainer_config] datamodule=$datamodule model.hparams_overrides.inference.hf_generation_params.length_penalty=$lp logger=$logger run_name_prefix=$run_name_prefix
#      else
#        python run_inference.py +experiment/inference=[$model,$inference_trainer_config] datamodule=$datamodule model.hparams_overrides.inference.hf_generation_params.length_penalty=$lp logger=$logger run_name_prefix=$run_name_prefix datamodule.debug=True datamodule.debug_k=2000
#      fi
#    done
#  done
#done

run_name_prefix="inf_full_"
for lp in 0.8 0.6
do
  for datamodule in sdg_text_davinci_003_pc rebel_pc sdg_code_davinci_002_pc
  do
    for model in fe_rebel_ms_base fe_fully_synthetic_ms_base
    do
      if [ $PRINT == true ]
      then
        echo python run_inference.py +experiment/inference=[$model,$inference_trainer_config] datamodule=$datamodule model.hparams_overrides.inference.hf_generation_params.length_penalty=$lp logger=$logger run_name_prefix=$run_name_prefix
      else
        python run_inference.py +experiment/inference=[$model,$inference_trainer_config] datamodule=$datamodule model.hparams_overrides.inference.hf_generation_params.length_penalty=$lp logger=$logger run_name_prefix=$run_name_prefix
      fi
    done
  done
done
