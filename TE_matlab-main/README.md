# TE_matlab

The additional analyses pertaining to the thesis files, excluding those related to Elisa Tentori, will not be disclosed or published. These supplementary analyses have been duly incorporated into the study.

Package for Transfer Entropy Calculation and analysis

Author: Elisa Tentori <tentorielisa@gmail.com> (University of Padua)

Date: January 25, 2023

All Rights Reserved (c)
_________________________________________________________________________


- Codes are adapted to handle data from the Collaborative Research in Computational Neuroscience (CRCNS) data sharing initiative at http://doi.org/10.6080/K0PC308P.

- Some functions are updates of analogues belonging of freely available TE toolbox developed by John Beggs’ group (posted at: http://code.google.com/p/transfer-entropy-toolbox/; Ito et al., 2011). These function are targeted as "ITO_TE".


_________________________________________________________________________


1. Preparation

   Compile the mex file (C program) with gcc or lcc (Matlab default C compiler).



2. Another Spiking Data Format (ASDF)

   Another Spike Data Format is basically cell array of spike timing of each neuron.
   In order to calculate TE correctly, I recommend to use only integer for the timing.
   To ensure that, you can do
   >> asdf = ChangeBinning(asdf, 1);

   Last two cells contains special information of the data.

   asdf{end-1}: Binning size in unit of ms (milisecond). (e.g. 1.2 -> 1.2ms/bin, 10 -> 10ms/bin etc...)
   asdf{end}: Array of number of neurons, number of total bins of the data
     (e.g. [10 300000] -> 10 neurons, 300000 time bins)



3. Functions per context (Please refer to header-help of each function for details)

   * TE Calculation
     - ASDFTE.m: (requires transentmex) delayed higher order TE calculator for ASDF.
     - ASDFTE_perm.m: (requires transentmex) delayed higher order TE calculator for ASDF and ASDF2.

   * Changing Data Format
     - SparseToASDF.m: Convert matrix form of raster to ASDF.

   * ASDF utilities
     - ASDFSubsample.m: Subsample specified neurons from ASDF.
     - ASDFChooseTime.m: Crop a time segment from larger ASDF.
     - ASDFGetfrate.m: Get firing rate (per bin) of all the neurons.
     - ASDFChangeBinning.m: Change binning size of ASDF.

   * Supporting functions (not to be excuted directly)
     - transent.c: Mex file for rapid calculation of TE.
     - transent_perm.c: Mex file for rapid calculation of TE between jittered senders and original receivers.


   File README_FUNCTIONS_MANUAL.txt contains a manual with functions description.

_________________________________________________________________________


Complete Index of Functions:

- ElecDistance.m
- Calculate_TE.m
- SparseToASDF.m      (from ITO_TE)
- ASDFTE.m	       (from ITO_TE)
- transent.c          (from ITO_TE)
- TE_distribution.m
- NullModel.m
- ASDFTE_perm.m       (adapted from ITO_TE)
- transent_perm.c     (adapted from ITO_TE)
- SignificanceTest.m
- TE_r.m
- rates.m

- ASDFSubsample.m:
- ASDFChooseTime.m
- ASDFGetfrate.m
- ASDFChangeBinning.m


Other Scripts:

- demo.m   presents simple use of some functions of the package
