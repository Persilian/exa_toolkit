#!/bin/bash


#======================================== exa_v2.EGAD.sh ====================================================#
#===Extract transcript GO-term annotation entries from any trinotate.xls annotation report===#
#Extract transcripts and their associated GO-terms
#USE: source exa.EGAD.sh {searchterm} {trinotate}
#Requires list of transcripts
#Requires exa.sh
#Marc Beringer 2020d_v2

###parameter
searchterm=$1
trinotate=$2
###

#Get the annotations for your transcripts of interest
source exa_v2.sh ${searchterm} ${trinotate}

#remove file extension from searchterm
short=$(echo ${searchterm} | sed "s/.txt//")

#extract column transcript_id and GO-term
#split the many GO-terms per transcript into one GO-term per line
#cut off the literal description of the GO-term
#output formatted file
cut -f1,9 ${short}_annotations.txt | awk -F "\t" '{ num = split($NF, array, "`"); for (i=1; i<=num; i++) { print $1 OFS array[i] } }' OFS="\t" | cut -d "^" -f2,3 --complement > GOterms.temp

#remove duplicate entries
#duplicate entries originate in the SEatlas2_2_trinotate.xls and are due to a bug of the trinotate pipeline
#there will still be duplicates of entries that have both "no annotation (.)" and an annotation
cat GOterms.temp | sort | uniq > ${short}_GOterms.txt

#extract column transcript_id and Kegg like above
cut -f1,8 ${short}_annotations.txt | awk -F "\t" '{ num = split($NF, array, "`"); for (i=1; i<=num; i++) { print $1 OFS array[i] } }' OFS="\t" | cut -d "^" -f2,3 --complement > KEGG.temp

#remove duplicate entries like above
cat KEGG.temp | sort | uniq > ${short}_KEGG.txt

#remove the _transcripts.txt that exa.sh produces
rm ${short}_transcripts.txt
rm ${short}_annotations.txt
rm GOterms.temp
rm KEGG.temp
