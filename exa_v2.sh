#!/bin/bash


#====================================== exa_v2.sh ==============================================#
#===Extract transcript annotation entries from any trinotate.xls annotation report===#
#Also produces a list of the extracted transcript names
#USE: source exa.sh {searchterm} {trinotate.xls}
#Requires a trinotate annotation report
#Marc Beringer 2020a_v2

###parameters
searchterm=$1
trinotate=$2
###

#shorten ${searchterm} for convenience
short=$(echo "${searchterm}" | sed "s/.txt//")

#extract the header
head -n1 ${trinotate} | cut -f1,4-6,15,16 --complement > header.temp

#extract transcripts related to search term
#the search term can be a regular file or a string, files are by default converted by dos2unix
if [ -f "${searchterm}" ]; then
        dos2unix -q ${searchterm}
        grep -f ${searchterm} ${trinotate} | cut -f1,4-6,15,16 --complement > annotations.temp
else
        grep "${searchterm}" ${trinotate} | cut -f1,4-6,15,16 --complement > annotations.temp
fi

#concatenate the result for convenience
cat header.temp annotations.temp > ${short}_annotations.txt

#produce a list of the extracted transcripts
tail -n +2 ${short}_annotations.txt | cut -f1 > ${short}_transcripts.txt

#state number of annotation entries extracted
wc -l ${short}_transcripts.txt > NbEntries.temp
NbEntries=$(cat NbEntries.temp | cut -d " " -f1)

#If there are zero search results, remove produced empty files
if [ ${NbEntries} -lt 1 ]; then
         rm ${short}_annotations.txt
         rm ${short}_transcripts.txt
         echo "No annotation entries were found"
else
         echo "Number of annotation entries found: ${NbEntries}"
fi
         
#cleanup temporary files
rm header.temp
rm annotations.temp
rm NbEntries.temp
