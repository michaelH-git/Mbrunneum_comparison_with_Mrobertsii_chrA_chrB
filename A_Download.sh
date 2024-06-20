#!/bin/bash
 

cd /work_beegfs/sunbo356/data/Henrik_Metarhizium/

mkdir -p /work_beegfs/sunbo356/data/Henrik_Metarhizium/00_genomes

wget https://sid.erda.dk/share_redirect/CzSbXlzdy7/Metarhizium_brunneum_kvl1218_jef290_arsef.gff3
wget https://sid.erda.dk/share_redirect/CLz8JciSOO/Metarhizium_brunneum_kvl1636_jef290_arsef.gff3
wget https://sid.erda.dk/share_redirect/fxtEVEkrMw/Metarhizium_brunneum_kvl1817_jef290_arsef_modif_names.gff3
wget https://sid.erda.dk/share_redirect/dGcMYPPNFs/Metarhizium_brunneum_kvl1939_jef290_arsef.gff3
wget https://sid.erda.dk/share_redirect/fsYyUKNX5W/Metarhizium_brunneum_kvl2101_jef290_arsef_modif_names.gff3
wget https://sid.erda.dk/share_redirect/CzSbXlzdy7/kvl1218_genome_funClean_sort.nextpolish.fa
wget https://sid.erda.dk/share_redirect/CLz8JciSOO/kvl1636_genome_funClean_sort.nextpolish.fa
wget https://sid.erda.dk/share_redirect/fxtEVEkrMw/1817_new_assembly_23scaffolds_lsorted_names.fasta
wget https://sid.erda.dk/share_redirect/dGcMYPPNFs/kvl1939_genome_funClean_sort.nextpolish.fa
wget https://sid.erda.dk/share_redirect/fsYyUKNX5W/2101_new_assembly_14scaffolds_lsorted_names.fasta


mkdir -p /work_beegfs/sunbo356/data/Henrik_Metarhizium/01_rawreads


wget https://sid.erda.dk/share_redirect/CzSbXlzdy7/kvl1218_R1.fastq
wget https://sid.erda.dk/share_redirect/CzSbXlzdy7/kvl1218_R2.fastq.gz

wget https://sid.erda.dk/share_redirect/CLz8JciSOO/kvl1636_R1.fastq.gz
wget https://sid.erda.dk/share_redirect/CLz8JciSOO/kvl1636_R2.fastq.gz


wget https://sid.erda.dk/share_redirect/fxtEVEkrMw/kvl1817_R1.fastq.gz
wget https://sid.erda.dk/share_redirect/fxtEVEkrMw/kvl1817_R2.fastq.gz

wget https://sid.erda.dk/share_redirect/dGcMYPPNFs/kvl1939_R1.fastq
wget https://sid.erda.dk/share_redirect/dGcMYPPNFs/kvl1939_R2.fastq

wget https://sid.erda.dk/share_redirect/fsYyUKNX5W/kvl2101_R1.fastq.gz
wget https://sid.erda.dk/share_redirect/fsYyUKNX5W/kvl2101_R2.fastq.gz



