#!/bin/bash


#=====================================exa.MATRIX.sh==========================================#
#=================Extract submatrices from the WGCNA network5 adjacency matrix===============#
#USE: source exa.MATRIX.sh {searchterm}
#Requires a symmetric matrix, where the searchterm is a list or single elements of the matrix
#here net5_adjacency_matrix.txt
#Marc Beringer 2020e

###parameters
searchterm=$1
###

#shorten ${searchterm} for convenience
short=$(echo "${searchterm}" | sed "s/.txt//")

#extract transcripts related to search term
#the search term can be a regular file or a string, files are by default converted by dos2unix
if [ -f "${searchterm}" ]; then
        dos2unix -q ${searchterm}
        grep -f ${searchterm} net5_adjacency_matrix.txt > submatrix1.temp
else
        grep "${searchterm}" net5_adjacency_matrix.txt > submatrix1.temp
fi

#transpose the concatenated submatrix1.temp
awk '
{
    for (i=1; i<=NF; i++)  {
        a[NR,i] = $i
    }
}
NF>p { p = NF }
END {
    for(j=1; j<=p; j++) {
        str=a[1,j]
        for(i=2; i<=NR; i++){
            str=str" "a[i,j];
        }
        print str
    }
}' submatrix1.temp > submatrix1.transposed.temp

#extract the transcripts in ${searchterm} from submatrix1.transposed.temp
if [ -f "${searchterm}" ]; then
        dos2unix -q ${searchterm}
        grep -f ${searchterm} submatrix1.transposed.temp > submatrix2.temp
else
        grep "${searchterm}" submatrix1.transposed.temp > submatrix2.temp
fi

#remove the first cell of the matrix containing "transcripts"
sed -z "s/transcripts//" submatrix2.temp > ${short}_adjacency.txt

#state size of the generated submatrix
wc -l ${short}_adjacency.txt > NbEntries.temp
NbEntries=$(cat NbEntries.temp | cut -d " " -f1)

echo "Extracted sub-matrix has dimensions: ${NbEntries}*${NbEntries}"


#cleanup temporary files
rm submatrix*.temp
rm NbEntries.temp