#!/bin/bash

#ParentDir
PAR_DIR="/work_beegfs/sunbo356/data/Henrik_Metarhizium/"
INPUT_DIR="${PAR_DIR}01_rawreads/"



# Path to the Script Dir

SCRIPT_DIR="${PAR_DIR}00_scripts/"

#create output dir

OUTPUT_DIR="${PAR_DIR}02_trimmed/"

LOG_DIR="${OUTPUT_DIR}SLURM_logs/"

#getthe number of R1 reads within the input folder

num=$(find ${INPUT_DIR}*R1.fastq.gz -type f | wc -l)

# Subtract 1 from the count
((num--))

echo $num

#create outputs dir

mkdir -p $OUTPUT_DIR
mkdir -p $LOG_DIR


#initialize arrays

all_R1=()
all_R2=()
all_out=()
all_sum=()



# Loop through each file in the directory
for file_path in "$INPUT_DIR"/*_R1.fastq.gz; do
    # Check if the current path is a file
    if [ -f "$file_path" ]; then
        # Extract the filename without the path
        file_name=$(basename "$file_path")
	all_R1+=(${file_name})
	all_R2+=(${file_name/_R1.fastq.gz/_R2.fastq.gz})
	all_out+=(${file_name/_R1.fastq.gz/_})
	all_sum+=(${file_name/_R1.fastq.gz/_sum})
    fi
done


echo ${all_R1[@]}
echo ${all_R2[@]}
echo ${all_out[@]}
echo ${all_sum[@]}


#Create input and output arrays
############################################
R1_INDEX="(`for x in  ${all_R1[@]}
do
	echo -n '"'
	echo -n $(basename "$x")
	echo -n '"'
done`);"
R1_INDEX=`sed -E 's@""@" \\\\\\n"@g' <<< ${R1_INDEX}`

echo ${R1_INDEX}


R2_INDEX="(`for x in  ${all_R2[@]}
do
	echo -n '"'
	echo -n $(basename "$x")
	echo -n '"'
done`);"
R2_INDEX=`sed -E 's@""@" \\\\\\n"@g' <<< ${R2_INDEX}`

echo ${R2_INDEX}

OUT_INDEX="(`for x in  ${all_out[@]}
do
	echo -n '"'
	echo -n $(basename "$x")
	echo -n '"'
done`);"
OUT_INDEX=`sed -E 's@""@" \\\\\\n"@g' <<< ${OUT_INDEX}`

echo ${OUT_INDEX}


SUM_INDEX="(`for x in  ${all_sum[@]}
do
	echo -n '"'
	echo -n $(basename "$x")
	echo -n '"'
done`);"
SUM_INDEX=`sed -E 's@""@" \\\\\\n"@g' <<< ${SUM_INDEX}`

echo ${SUM_INDEX}


OUT_INDEX="(`for x in  ${all_out[@]}
do
	echo -n '"'
	echo -n $(basename "$x")
	echo -n '"'
done`);"
OUT_INDEX=`sed -E 's@""@" \\\\\\n"@g' <<< ${OUT_INDEX}`

echo ${OUT_INDEX}

### Script variables ###
SLURM_SCRIPT="${SCRIPT_DIR}C_trim_local`date -I`.sh"

R1='${R1_INDEX[$i]}'
R2='${R2_INDEX[$i]}'
OUT='${OUT_INDEX[$i]}'
SUM='${SUM_INDEX[$i]}'

SATID1='"$SLURM_ARRAY_TASK_ID"'
SATID2='${SLURM_ARRAY_TASK_ID}'

### Write slurm array script ###
echo """#!/bin/bash
#SBATCH --job-name=trimMHA
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --time 12:00:00
#SBATCH -o ${SLURM_DIR}trim_`date -I`_%A_%a.out
#SBATCH --error=${SLURM_DIR}trim_`date -I`_%A_%a.err
#SBATCH --array=0-$num
#SBATCH --mem=15G


module load gcc12-env
module load miniconda3


#activate conda environemnt

conda activate trimmomatic

R1_INDEX=${R1_INDEX}
R2_INDEX=${R2_INDEX}
OUT_INDEX=${OUT_INDEX}
SUM_INDEX=${SUM_INDEX}



if [ ! -z ${SATID1} ]
then
i=${SATID2}

trimmomatic PE -threads 4 \
	-summary ${LOG_DIR}${SUM} \
	${INPUT_DIR}${R1} \
	${INPUT_DIR}${R2} \
	-baseout ${OUTPUT_DIR}${OUT} \
	ILLUMINACLIP:/zfshome/sunbo356/TruSeq3-PE-2.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

else
	echo Error: missing array index as SLURM_ARRAY_TASK_ID

fi

conda deactivate


""" > ${SLURM_SCRIPT}

sbatch ${SLURM_SCRIPT}

