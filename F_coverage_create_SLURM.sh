#!/bin/bash


#ParentDir
PAR_DIR="/work_beegfs/sunbo356/data/Henrik_Metarhizium/"
INPUT_DIR="${PAR_DIR}04_reformat/"


# Path to the Script Dir

SCRIPT_DIR="${PAR_DIR}00_scripts/"



#Path to the bed_file that has the 50kb window (minus TEs)

bed_file=/work_beegfs/sunbo356/data/Henrik_Metarhizium/00_genomes/Bed_files/R3-I4_TE-annotation_replaced.sorted.merged.sorted.50kbwindows.bed

#create output dir

OUTPUT_DIR="${PAR_DIR}05_mosdepth/"

LOG_DIR="${OUTPUT_DIR}SLURM_logs/"

mkdir -p $OUTPUT_DIR
mkdir -p $LOG_DIR



#create outputs dir

mkdir -p $OUTPUT_DIR
mkdir -p $LOG_DIR


#getthe number of BAM files within the input folder

num=$(find ${INPUT_DIR}*sorted.RG.DEDUP.bam -type f | wc -l)

# Subtract 1 from the count
((num--))


#initialize arrays
all_file=()
all_sample=()
all_base=()


for bam_path in "$INPUT_DIR"/*sorted.RG.DEDUP.bam; do
	echo $bam_path
	file_name=$(basename "$bam_path" .bam)
	file_out=${OUTPUT_DIR}${file_name}
	echo $file_name
	echo $file_out
	all_file+=(${bam_path})
	all_out+=(${file_out})
done

 

echo ${all_file[@]}
echo ${all_out[@]}



#Create input and output arrays
############################################
NAME_INDEX="(`for x in  ${all_file[@]}
do
	echo -n '"'
	echo -n $(basename "$x")
	echo -n '"'
done`);"
NAME_INDEX=`sed -E 's@""@" \\\\\\n"@g' <<< ${NAME_INDEX}`

echo ${NAME_INDEX}



OUT_INDEX="(`for x in  ${all_out[@]}
do
	echo -n '"'
	echo -n $(basename "$x")
	echo -n '"'
done`);"
OUT_INDEX=`sed -E 's@""@" \\\\\\n"@g' <<< ${OUT_INDEX}`

echo ${OUT_INDEX}



### Script variables ###
SLURM_SCRIPT="${SCRIPT_DIR}F_mosdepth_`date -I`.sh"

NAME='${NAME_INDEX[$i]}'
OUT='${OUT_INDEX[$i]}'

SATID1='"$SLURM_ARRAY_TASK_ID"'
SATID2='${SLURM_ARRAY_TASK_ID}'

### Write slurm array script ###
echo """#!/bin/bash
#SBATCH --job-name=depth2MHA
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --time 12:00:00
#SBATCH -o ${LOG_DIR}depth_`date -I`_%A_%a.out
#SBATCH --error=${LOG_DIR}depth_`date -I`_%A_%a.err
#SBATCH --array=0-$num
#SBATCH --mem=15G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mhabig@bot.uni-kiel.de




module load gcc12-env
module load miniconda3




NAME_INDEX=${NAME_INDEX}
OUT_INDEX=${OUT_INDEX}




if [ ! -z ${SATID1} ]
then
i=${SATID2}

conda activate samtools

samtools index ${INPUT_DIR}${NAME}  

conda deactivate


conda activate mosdepth

mosdepth -n -T 2 -Q 5 --by $bed_file ${OUTPUT_DIR}${OUT} ${INPUT_DIR}${NAME}  


else
	echo Error: missing array index as SLURM_ARRAY_TASK_ID

fi

conda deactivate

gunzip ${OUTPUT_DIR}*.gz

""" > ${SLURM_SCRIPT}


sbatch ${SLURM_SCRIPT}

