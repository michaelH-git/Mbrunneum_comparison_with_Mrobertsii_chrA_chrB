#!/bin/bash



#ParentDir
PAR_DIR="/work_beegfs/sunbo356/data/Henrik_Metarhizium/"
INPUT_DIR="${PAR_DIR}02_trimmed/"
REF_DIR="${PAR_DIR}00_genome/"

# Path to the Script Dir

SCRIPT_DIR="${PAR_DIR}00_scripts/"


#Path to assembly R3I4 bowtie2.index

REF=/work_beegfs/sunbo356/data/Henrik_Metarhizium/00_genomes/R3I4 


#create output dir

OUTPUT_DIR="${PAR_DIR}03_BAM/"

LOG_DIR="${OUTPUT_DIR}SLURM_logs/"

#getthe number of _1P reads within the input folder

num=$(find ${INPUT_DIR}*_1P -type f | wc -l)

# Subtract 1 from the count
((num--))

echo $num


#create outputs dir

mkdir -p $OUTPUT_DIR
mkdir -p $LOG_DIR


#initialize arrays

all_samples=()


# Loop through each file in the directory
for file_path in "$INPUT_DIR"/*__1P; do
    # Check if the current path is a file
    if [ -f "$file_path" ]; then
        # Extract the filename without the path
        file_name=$(basename "$file_path")
		sample_name=(${file_name/__1P})
		all_samples+=(${sample_name})
    fi
done


echo ${all_samples[@]}


#Create input and output arrays
############################################
SAMPLE_INDEX="(`for x in  ${all_samples[@]}
do
	echo -n '"'
	echo -n $(basename "$x")
	echo -n '"'
done`);"
SAMPLE_INDEX=`sed -E 's@""@" \\\\\\n"@g' <<< ${SAMPLE_INDEX}`

echo ${SAMPLE_INDEX}

### Script variables ###
SLURM_SCRIPT="${SCRIPT_DIR}D_bowtie2_`date -I`.sh"

SAMPLE='${SAMPLE_INDEX[$i]}'

SATID1='"$SLURM_ARRAY_TASK_ID"'
SATID2='${SLURM_ARRAY_TASK_ID}'

### Write slurm array script ###
echo """#!/bin/bash
#SBATCH --job-name=bowtie2MHA
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --time 12:00:00
#SBATCH -o ${LOG_DIR}bowtie2_`date -I`_%A_%a.out
#SBATCH --error=${LOG_DIR}bowtie2_`date -I`_%A_%a.err
#SBATCH --array=0-$num
#SBATCH --mem=15G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mhabig@bot.uni-kiel.de



module load gcc12-env
module load miniconda3


#activate conda environemnt

conda activate bowtie2

SAMPLE_INDEX=${SAMPLE_INDEX}




if [ ! -z ${SATID1} ]
then
i=${SATID2}

bowtie2 \
-p 4 --sensitive \
-x ${REF} \
-1 ${INPUT_DIR}${SAMPLE}__1P \
-2 ${INPUT_DIR}${SAMPLE}__2P \
-U ${INPUT_DIR}${SAMPLE}__1U,${INPUT_DIR}${SAMPLE}__2U \
| samtools view -@4 -h -bS \
| samtools sort -@4 \
-o ${OUTPUT_DIR}${SAMPLE}_on-R3I4_sorted.bam


else
	echo Error: missing array index as SLURM_ARRAY_TASK_ID

fi

conda deactivate

""" > ${SLURM_SCRIPT}

sbatch ${SLURM_SCRIPT}
