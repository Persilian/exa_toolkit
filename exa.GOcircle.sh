#!/bin/bash


#=====================================exa.GOcircle.sh==========================================#
#=================Format GOseq output files to fit the GOplot R package inputs=================#
#USE: source exa.GOcircle.sh {GOresults} {DEGresults}
##Where searchterm1 has to be the GO-enrichment results and searchterm2 has to be the corresponding DEG results file
#Requires GOseq output, often from the TRINITY-pipeline
#GO-enrichment results, e.g. 2ndSE_DEG2.isoform.counts.matrix.control_vs_herbivory.edgeR.DE_results.P1e-3_C1.DE.subset.GOseq.enriched
#DEG analysis results, e.g. 2ndSE_DEG2.isoform.counts.matrix.control_vs_herbivory.edgeR.DE_results.P1e-3_C1.DE.subset
#Marc Beringer 2020f

###parameters
GOresults=$1
DEGresults=$2
###

#The GOplot R-package requires a GO-term file with columns "Category - ID - Term - Genes - adj_pval"
#Therefore we extract columns category, term, ontology, over_represented_FDR, gene_ids
#columns 1,6,7,8,10

cut -f1,6,7,8,10 ${GOresults} | tail -n +2 > temp1.txt

#create a renamed header

echo -e "ID\tTerm\tCategory\tadj_pval\tGenes" > header1.temp

#concatenate the header and the GO-term file
#also replace tab with ";" as a field separator for convenient use of this file in R

cat header1.temp temp1.txt | sed -E "s/\t/;/g" > ${GOresults}_CIRCLE-TERM.txt


#We also require a file with log-FC and their adjusted P-values with columns "ID - logFC - P.Value - adj.P.Val"
#Therefore we extract columns 1,4,6,7

cut -f1,4,6,7 ${DEGresults} | tail -n +2 > temp2.txt

#create a renamed header

echo -e "ID\tlogFC\tP.Value\tadj.P.Val" > header2.temp

#concatenate the header and the GO-term file

cat header2.temp temp2.txt > ${DEGresults}_CIRCLE-EXPRESSION.txt


#cleanup temporary files
rm temp1.txt
rm temp2.txt
rm header1.temp
rm header2.temp