## This script takes pre-existing GenBank formatted genomes and locates the protein motif 'PEWY' 
## Written by Audrey K. Ward, 8 June 2018, in conjunction with the Auburn University Bioinformatics Bootcamp 

#!/bin/bash #shebang line

for GBFILE in *.gb #initialize loop
do
 ID=`echo $GBFILE | awk -F"." '{print$1}'` #create unique ID for each organism being processed 
 extractfeat -type CDS -join -sequence $GBFILE -outseq ${ID}_codon_features.fasta #Use emboss -> extractfeat to create a .fasta file from the GenBank .gb files
 sed -i -e "s/ .*/_${ID}_CDS/g" ${ID}_codon_features.fasta #Change fasta headers to include name of file used using sed find and replace
 transeq -sequence ${ID}_codon_features.fasta -outseq ${ID}_aa_codon_features.fasta -table 5 # Translate nt sequences to aa sequences using emboss -> transeq using the .fasta file from the above as input
 cusp -sequence ${ID}_codon_features.fasta -outfile ${ID}_codon_usage_table.txt # Create a codon usage table using the nt sequence fasta file and the emboss -> cusp command
 patmatdb -sequence ${ID}_aa_codon_features.fasta -motif PEWY -outfile ${ID}_protMotif.patmatdb # Use emboss->  patmatdb command to locate the 'PEWY' motif within the aa features .fasta file and print to screen
 echo $GBFILE "has been processed!" #print confirmation of file processing
done #terminate loop




