#!/bin/bash


#ParentDir
PAR_DIR="/work_beegfs/sunbo356/data/Henrik_Metarhizium/"
INPUT_DIR="${PAR_DIR}03_BAM/"



# Path to the Script Dir

SCRIPT_DIR="${PAR_DIR}00_scripts/"



#create output dir

OUTPUT_DIR="${PAR_DIR}04_reformat/"

LOG_DIR="${OUTPUT_DIR}SLURM_logs/"

mkdir -p $OUTPUT_DIR
mkdir -p $LOG_DIR


#getthe number of BAM files within the input folder

num=$(find ${INPUT_DIR}*.bam -type f | wc -l)

# Subtract 1 from the count
((num--))


#initialize arrays

all_file=()
all_sample=()
all_assemb=()

# Loop through each file in the directory
for bam_path in "$INPUT_DIR"/*.bam; do
	file_name=$(basename "$bam_path")
	file_base=${file_name/%.bam}
	sample=${file_name/%_on*}
	echo $file_name
	echo $sample
	echo $file_base
	all_file+=(${file_name})
	all_sample+=(${sample})
       	all_base+=(${file_base})
done


echo ${all_file[@]}
echo ${all_sample[@]}
echo ${all_base[@]}


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


BASE_INDEX="(`for x in  ${all_base[@]}
do
	echo -n '"'
	echo -n $(basename "$x")
	echo -n '"'
done`);"
BASE_INDEX=`sed -E 's@""@" \\\\\\n"@g' <<< ${BASE_INDEX}`

echo ${BASE_INDEX}

SAMPLE_INDEX="(`for x in  ${all_sample[@]}
do
	echo -n '"'
	echo -n $(basename "$x")
	echo -n '"'
done`);"
SAMPLE_INDEX=`sed -E 's@""@" \\\\\\n"@g' <<< ${SAMPLE_INDEX}`

echo ${SAMPLE_INDEX}


### Script variables ###
SLURM_SCRIPT="${SCRIPT_DIR}D_reformat_`date -I`.sh"

NAME='${NAME_INDEX[$i]}'
BASE='${BASE_INDEX[$i]}'
SAMPLE='${SAMPLE_INDEX[$i]}'

SATID1='"$SLURM_ARRAY_TASK_ID"'
SATID2='${SLURM_ARRAY_TASK_ID}'

### Write slurm array script ###
echo """#!/bin/bash
#SBATCH --job-name=reformat2MHA
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --time 12:00:00
#SBATCH -o ${SLURM_DIR}reformat_`date -I`_%A_%a.out
#SBATCH --error=${SLURM_DIR}reformat_`date -I`_%A_%a.err
#SBATCH --array=0-$num
#SBATCH --mem=15G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mhabig@bot.uni-kiel.de


module load gcc12-env
module load miniconda3


#activate conda environemnt

conda activate picard

NAME_INDEX=${NAME_INDEX}
BASE_INDEX=${BASE_INDEX}
SAMPLE_INDEX=${SAMPLE_INDEX}



if [ ! -z ${SATID1} ]
then
i=${SATID2}

picard AddOrReplaceReadGroups  \
-I ${INPUT_DIR}${NAME} \
-O ${OUTPUT_DIR}${BASE}.RG.bam \
-RGID ${SAMPLE} -RGLB lib1 -RGPL ILLUMINA -RGPU unknown -RGSM ${SAMPLE} -SORT_ORDER coordinate \

picard MarkDuplicates \
-I ${OUTPUT_DIR}${BASE}.RG.bam \
-O ${OUTPUT_DIR}${BASE}.RG.DEDUP.bam \
-M ${SLURM_DIR}${BASE}

rm ${OUTPUT_DIR}${BASE}.RG.bam

else
	echo Error: missing array index as SLURM_ARRAY_TASK_ID

fi

conda deactivate

""" > ${SLURM_SCRIPT}

sbatch ${SLURM_SCRIPT}


