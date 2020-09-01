#!/bin/bash

#=============================exa.DEG.sh=============================#
#===Search for specific transcripts in the 2ndSE >2-fold DEG dataset===#
#Also extracts the DEG along with their expression data
#USE: source exa.DEG.sh {searchterm}
#REQUIRES: a matrix with differentially expressed genes, here 2ndSE_2-fold_DEG_results_combined.data
#Marc Beringer 2020b

###parameters
searchterm=$1
###

#shorten ${searchterm} for convenience
short=$(echo "${searchterm}" | sed "s/_transcripts.txt//")

#extract the header
head -n1 2ndSE_2-fold_DEG_results_combined.data | cut -f5,6 --complement > header.temp

#extract transcripts related to search term
#the search term can be a regular file or a string, files are by default converted by dos2unix
if [ -f "${searchterm}" ]; then
        dos2unix -q ${searchterm}
        grep -f ${searchterm} 2ndSE_2-fold_DEG_results_combined.data | cut -f5,6 --complement > deg.temp
else
        grep "${searchterm}" 2ndSE_2-fold_DEG_results_combined.data | cut -f5,6 --complement > deg.temp
fi

#concatenate the result
cat header.temp deg.temp > ${short}_2-fold_DEG_matrix.txt

#produce a list of the extracted transcripts
tail -n +2 ${short}_2-fold_DEG_matrix.txt | cut -f1 > ${short}_2-fold_DEG_transcripts.txt

#state number of annotation entries extracted
wc -l ${short}_2-fold_DEG_transcripts.txt > NbEntries.temp
NbEntries=$(cat NbEntries.temp | cut -d " " -f1)

#If there are zero search results, remove produced empty files
if [ ${NbEntries} -lt 2 ]; then
         rm ${short}_2-fold_DEG_matrix.txt
         rm ${short}_2-fold_DEG_transcripts.txt
         echo "No differentially expressed genes were among the searched transcripts"
else
         echo "Number of differentially expressed transcripts found: ${NbEntries}"
fi

#cleanup temporary files
rm header.temp
rm deg.temp
rm NbEntries.temp