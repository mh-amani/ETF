#!/bin/bash

export PYTHONPATH="."

lc_ids="fully_expanded subject_collapsed"
data_dir="data/final"
output_data_dir="data/final_pre_computed"

dataset_name="sdg_text_davinci_003"
for split in val test test_small
do
  python scripts/pre_computing.py --data_dir $data_dir --dataset_name $dataset_name --split $split --lc_ids $lc_ids --apply_ordering_heuristic --output_data_dir $output_data_dir --include_target_dict --save_zipped
done

dataset_name="sdg_code_davinci_002"
for split in train val test test_small
do
  python scripts/pre_computing.py --data_dir $data_dir --dataset_name $dataset_name --split $split --lc_ids $lc_ids --apply_ordering_heuristic --output_data_dir $output_data_dir --include_target_dict --save_zipped
done

#data_dir="data/final"
#output_data_dir="data/final_pre_computed"
dataset_name="rebel"
for split in train val test test_small
do
  # --apply_ordering_heuristic is not used here because the triplets in REBEl should already be ordered
  python scripts/pre_computing.py --data_dir $data_dir --dataset_name $dataset_name --split $split --lc_ids $lc_ids --output_data_dir $output_data_dir --include_target_dict --save_zipped
done
