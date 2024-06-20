#!/bin/bash
 
 cd /work_beegfs/sunbo356/data/Henrik_Metarhizium/00_genomes/
 

ln -s /work_beegfs/sunbo356/data/Henrik_Metarhizium/00_genomes/Original_downloads/1817_new_assembly_23scaffolds_lsorted_names.fasta kvl1817.fa
ln -s /work_beegfs/sunbo356/data/Henrik_Metarhizium/00_genomes/Original_downloads/2101_new_assembly_14scaffolds_lsorted_names.fasta kvl2101.fa
ln -s /work_beegfs/sunbo356/data/Henrik_Metarhizium/00_genomes/Original_downloads/kvl1218_genome_funClean_sort.nextpolish.fa kvl1218.fa
ln -s /work_beegfs/sunbo356/data/Henrik_Metarhizium/00_genomes/Original_downloads/kvl1636_genome_funClean_sort.nextpolish.fa kv1636.fa
ln -s /work_beegfs/sunbo356/data/Henrik_Metarhizium/00_genomes/Original_downloads/kvl1939_genome_funClean_sort.nextpolish.fa kvl1939.fa
ln -s /work_beegfs/sunbo356/data/Henrik_Metarhizium/OLD/00_genome/kvl1230.fa kvl1230.fa

mkdir -p /work_beegfs/sunbo356/data/Henrik_Metarhizium/00_genomes/annotations/

cd /work_beegfs/sunbo356/data/Henrik_Metarhizium/00_genomes/annotations/

ln -s /work_beegfs/sunbo356/data/Henrik_Metarhizium/OLD/00_genome/Metarhizium_brunneum_kvl1230_jef290_arsef.gff3 kvl1230.genes.gff3
ln -s /work_beegfs/sunbo356/data/Henrik_Metarhizium/00_genomes/Original_downloads/annotations/Metarhizium_brunneum_kvl1218_jef290_arsef.gff3  kvl1218.genes.gff3
ln -s /work_beegfs/sunbo356/data/Henrik_Metarhizium/00_genomes/Original_downloads/annotations/Metarhizium_brunneum_kvl1636_jef290_arsef.gff3 kvl1636.genes.gff3
ln -s /work_beegfs/sunbo356/data/Henrik_Metarhizium/00_genomes/Original_downloads/annotations/Metarhizium_brunneum_kvl1817_jef290_arsef_modif_names.gff3 kvl1817.genes.gff3
ln -s /work_beegfs/sunbo356/data/Henrik_Metarhizium/00_genomes/Original_downloads/annotations/Metarhizium_brunneum_kvl1939_jef290_arsef.gff3 kvl1939.genes.gff3
ln -s /work_beegfs/sunbo356/data/Henrik_Metarhizium/00_genomes/Original_downloads/annotations/Metarhizium_brunneum_kvl2101_jef290_arsef_modif_names.gff3 kvl2101.genes.gff3





 