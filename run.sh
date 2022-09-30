

input_file_name="input_data/FreqByAllergy.csv"
output_stem="antibiotics_by_allergy_status"
if false; then
python3 parse_input_data.py $input_file_name $output_stem
fi

input_file_name="input_data/FreqByMRSA.csv"
output_stem="antibiotics_by_msra"
if false; then
python3 parse_input_data.py $input_file_name $output_stem
fi


if false; then
module load r/3.6.3
fi

Rscript visualize.R 

