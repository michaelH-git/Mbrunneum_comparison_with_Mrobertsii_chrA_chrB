#!/bin/bash

# Directory containing threshold.bed files
input_dir="/work_beegfs/sunbo356/data/Henrik_Metarhizium/05_mosdepth/"

# Output file to store summarized results
output_dir=${input_dir}summary/

mkdir -p $output_dir


# Loop through all threshold.bed files
for file in "$input_dir"/*.thresholds.bed; do
	sample_name=$(basename "$file" _on-R3I4_sorted.RG.DEDUP.thresholds.bed)
    # Read the 4th column (region) and calculate length
	rm ${output_dir}${sample_name}_threshold_summary.txt
    awk 'NR>1 {sums[$4] += $3 - $2; sum_col5[$4] += $5} END {for (r in sums) print r, sum_col5[r]/sums[r]}' "$file" >> ${output_dir}${sample_name}_threshold_summary.txt
done



join /work_beegfs/sunbo356/data/Henrik_Metarhizium/05_mosdepth/summary/kvl1218_threshold_summary.txt \
	/work_beegfs/sunbo356/data/Henrik_Metarhizium/05_mosdepth/summary/kvl1230_threshold_summary.txt \
	| join - /work_beegfs/sunbo356/data/Henrik_Metarhizium/05_mosdepth/summary/kvl1636_threshold_summary.txt \
	| join - /work_beegfs/sunbo356/data/Henrik_Metarhizium/05_mosdepth/summary/kvl1817_threshold_summary.txt \
	| join - /work_beegfs/sunbo356/data/Henrik_Metarhizium/05_mosdepth/summary/kvl1939_threshold_summary.txt \
	| join - /work_beegfs/sunbo356/data/Henrik_Metarhizium/05_mosdepth/summary/kvl2101_threshold_summary.txt \
	> /work_beegfs/sunbo356/data/Henrik_Metarhizium/05_mosdepth/summary/Summary.all.threshold.combined.txt

sed -i '1s/^/region kvl1218 kvl1230 kvl1336 kvl1817 kvl1939 kvl2101\n/' /work_beegfs/sunbo356/data/Henrik_Metarhizium/05_mosdepth/summary/Summary.all.threshold.combined.txt


# Loop through all regions.bed files
for file in "$input_dir"/*.regions.bed; do
	overall_seq_cov=()
	SUM_txt=()
	sample_name=$(basename "$file" _on-R3I4_sorted.RG.DEDUP.regions.bed)
    # Read the 4th column (region) and calculate length
	SUM_txt=${input_dir}${sample_name}_on-R3I4_sorted.RG.DEDUP.mosdepth.summary.txt
	overall_seq_cov=$(awk '/total_region/ { print $4 }' $SUM_txt)
	rm ${output_dir}${sample_name}_region_summary.txt
    awk -v var="$overall_seq_cov" 'NR>1 {sums[$4] += $3 - $2; sum_col5[$4] += ( $3 - $2) * $5} END {for (r in sums) print r, sum_col5[r]/sums[r]/var}' "$file" >> ${output_dir}${sample_name}_region_summary.txt
done



join /work_beegfs/sunbo356/data/Henrik_Metarhizium/05_mosdepth/summary/kvl1218_region_summary.txt \
	/work_beegfs/sunbo356/data/Henrik_Metarhizium/05_mosdepth/summary/kvl1230_region_summary.txt \
	| join - /work_beegfs/sunbo356/data/Henrik_Metarhizium/05_mosdepth/summary/kvl1636_region_summary.txt \
	| join - /work_beegfs/sunbo356/data/Henrik_Metarhizium/05_mosdepth/summary/kvl1817_region_summary.txt \
	| join - /work_beegfs/sunbo356/data/Henrik_Metarhizium/05_mosdepth/summary/kvl1939_region_summary.txt \
	| join - /work_beegfs/sunbo356/data/Henrik_Metarhizium/05_mosdepth/summary/kvl2101_region_summary.txt \
	> /work_beegfs/sunbo356/data/Henrik_Metarhizium/05_mosdepth/summary/Summary.all.region.combined.txt

sed -i '1s/^/region kvl1218 kvl1230 kvl1336 kvl1817 kvl1939 kvl2101\n/' /work_beegfs/sunbo356/data/Henrik_Metarhizium/05_mosdepth/summary/Summary.all.region.combined.txt

join /work_beegfs/sunbo356/data/Henrik_Metarhizium/05_mosdepth/summary/Summary.all.threshold.combined.txt /work_beegfs/sunbo356/data/Henrik_Metarhizium/05_mosdepth/summary/Summary.all.region.combined.txt > /work_beegfs/sunbo356/data/Henrik_Metarhizium/05_mosdepth/summary/Summary.all.combined.txt

#some manipulation of the file

awk -F'_' '{ print $1 "_" $2 "_" $3, $1 "_" $2, $3 }' /work_beegfs/sunbo356/data/Henrik_Metarhizium/05_mosdepth/summary/Summary.all.combined.txt > /work_beegfs/sunbo356/data/Henrik_Metarhizium/05_mosdepth/summary/Summary.all.combined.mod.txt

