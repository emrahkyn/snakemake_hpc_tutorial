#!/bin/bash
#SBATCH -p sardalya
#SBATCH -A emrah
#SBATCH -J EmrahTest
#SBATCH -N 1 # hesabin dagitilacagi node adedi
#SBATCH -n 4 # is icin toplamda kullanilacak cekirdek adeti
#SBATCH --time=2:00:00
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err

#general
query_id=P01008
blastdb=/truba/home/emrah/shared/blastdb/all_eu.fasta

#task1
task1_input_blastdb=$blastdb
task1_params_query_id=$query_id
task1_output_fastafile=output/$query_id.fasta
task1_log=logs/task1.err
task1_script=scripts/make_query_fasta.py

#task2
task2_input_blastdb=$blastdb
task2_input_query_fasta=$task1_output_fastafile
task2_output_outfile=output/${query_id}_blasthits.out
task2_log=logs/task2.err
task2_params_outfmt=0
task2_params_max_target_seqs=1000
task2_params_num_iterations=2

#task3
task3_input_blastp_out=$task2_output_outfile
task3_output_blast_fasta=output/$query_id_blasthits.fasta
task3_script=scripts/parse_blastp.py
task3_log=logs/task3.err
task3_input_blastdb=$blastdb
task3_input_query_fasta=output/$query_id.fasta
task3_params_blast_hit_number=1000
task3_params_max_e_value=0.00001
task3_params_min_identity=30

echo "SLURM_NODELIST $SLURM_NODELIST"
echo -n "Run started: "
date

echo "Task1: Query Fasta"
export PATH=$HOME/python/bin/:$PATH
python $task1_script $task1_params_query_id  $task1_input_blastdb $task1_output_fastafile 2> $task1_log

echo "Task2: Blast"
export PATH=/truba/home/emrah/WORKFOLDER/TEST/TUTORIAL_0921/exp2/sw/blast/ncbi-blast-2.2.31+-src/c++/ReleaseMT/bin:$PATH
psiblast -query $task2_input_query_fasta -db $task2_input_blastdb -outfmt $task2_params_outfmt -out $task2_output_outfile -max_target_seqs $task2_params_max_target_seqs -num_iterations $task2_params_num_iterations  2> $task2_log

echo "Task3: Get Blasthits"
python3 $task3_script $task3_input_blastp_out $task3_params_blast_hit_number $task3_params_max_e_value $task3_params_min_identity $task3_input_blastdb $task3_input_query_fasta 2> $task3_log

echo -n "Run finished: "
date
echo "DONE"

