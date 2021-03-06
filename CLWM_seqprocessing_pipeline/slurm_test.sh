#!/bin/bash

#SBATCH -p short
#SBATCH -t 0:30:00
#SBATCH --mem-per-cpu=1400M
#SBATCH -c 1
#SBATCH -e snakemake.err
#SBATCH -o snakemake.out
#SBATCH -J snakemakeKW


snakemake -p \
    -R `cat <(snakemake --lc --rerun-incomplete) \
          <(snakemake --li --rerun-incomplete) \
          <(snakemake --lp --rerun-incomplete) | sort -u` \
    --latency-wait 300 \
    --rerun-incomplete \
    --cluster-config cluster.yaml \
    --use-conda \
    --jobs 999 \
    --restart-times 1 \
    --cluster "sbatch -p {cluster.queue} -n {cluster.n} -t {cluster.time} --mem-per-cpu={cluster.mem} -J {cluster.name} -e {cluster.err} -o {cluster.log}" \
    --cluster-status "bash slurm_status.sh" 
