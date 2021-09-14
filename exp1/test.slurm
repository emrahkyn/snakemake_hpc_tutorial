#!/bin/bash
#SBATCH -p sardalya
#SBATCH -J EmrahTest
#SBATCH -A emrah
#SBATCH -N 1 # hesabin dagitilacagi node adedi
#SBATCH -n 1 # is icin toplamda kullanilacak cekirdek adeti
#SBATCH --time=2:00:00
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err

export PATH=$HOME/python/bin/:$PATH

echo "SLURM_NODELIST $SLURM_NODELIST"
sleep 10
which python
python hello_world.py > test.out
echo "DONE"

