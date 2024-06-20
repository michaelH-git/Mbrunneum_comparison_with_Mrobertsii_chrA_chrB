#!/bin/bash
#SBATCH --job-name=trimMHA
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --time 12:00:00
#SBATCH -o trim_2024-05-02_%A_%a.out
#SBATCH --error=trim_2024-05-02_%A_%a.err
#SBATCH --array=0-5
#SBATCH --mem=15G


module load gcc12-env
module load miniconda3



#activate conda environemnt

conda activate minimap2

#definition of input and utput folder
STAMM_DIR=/work_beegfs/sunbo356/data/Henrik_Metarhizium/
IN_DIR=${STAMM_DIR}00_genomes/
OUT_DIR=${STAMM_DIR}07_PAF/
REF=${IN_DIR}R3I4.fasta

mkdir -p $OUT_DIR


NAME_INDEX=("kvl1218" \
"kvl1230" \
"kvl1636" \
"kvl1817" \
"kvl1939" \
"kvl2101");

"" > ${OUT_DIR}/R_dotplotly.txt

if [ ! -z "$SLURM_ARRAY_TASK_ID" ]
then
i=${SLURM_ARRAY_TASK_ID}

minimap2 -x asm5 $REF ${IN_DIR}${NAME_INDEX[$i]}.fa > ${OUT_DIR}${NAME_INDEX[$i]}_on-R3I4.paf

echo Rscript --vanilla pafCoordsDotPlotly.R  -i ${NAME_INDEX[$i]}_on-R3I4.paf -q 10000 -m 10000 -p 15 -s -o ${NAME_INDEX[$i]}_on-R3I4 -k 16 >> ${OUT_DIR}/R_dotplotly.txt


else
	echo Error: missing array index as SLURM_ARRAY_TASK_ID

fi

conda deactivate



