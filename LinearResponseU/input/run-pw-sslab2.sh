#!/bin/bash
#
#SBATCH --job-name=MoS2_1.6eV
#SBATCH --output=tdpw.out
#SBATCH -N 1
#SBATCH --ntasks-per-node=56
#SBATCH --time=0-00:30:00
#SBATCH -p regular

#-------------------Source ----------------------------------------------------------------
source /share/apps/intel-oneAPI-2021/compiler/2022.0.2/env/vars.sh intel64
source /share/apps/intel-oneAPI-2021/mkl/2022.0.2/env/vars.sh intel64
source /share/apps/intel-oneAPI-2021/mpi/2021.5.1/env/vars.sh intel64

EXEC=/share/home/cndaqiang/soft/oneapi21/q-e-qe-6.6/bin/pw.x
mpirun  $EXEC -npool 4  -i input.in  >  result

