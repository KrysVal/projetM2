from Bio.Blast import NCBIXML

result_handle = open("resultat_complet/blast_prot_xml/cds_vs_proteinsref.xml")
blast_records = NCBIXML.parse(result_handle)
out_report = open("report_blast_quality.txt","w")
out_nn_align = open ("CDS_nn_align.txt","w")

list_align = []
count_nn_align=0
count_align=0

first_record = next(blast_records)
count_queries=1
number_db = first_record.database_sequences 
if len(first_record.alignments)==0 : 
	out_nn_align.write(first_record.query+"\n")
	count_nn_align+=1	
else : 
	count_align+=1	

for record in blast_records :
	count_queries+=1
	if len(record.alignments)==0 : 
		out_nn_align.write(record.query+"\n")
		count_nn_align+=1
	else : 
		count_align+=1
		for align in record.alignments : 
			if align.title not in list_align : 
				list_align.append(align.title)

number_covered_ref = len(list_align)
sensitivity = number_covered_ref/number_db
specificity = count_align/count_queries
out_report.write("Number of annotated CDS :"+str(count_queries)+"\n"+"Number of reference's proteins : "+str(number_db)+"\nNumber of CDS with no correspondance : "+str(count_nn_align)+"\nNumber of CDS with correspondance :"+str(count_align)+"\nNumber of proteins in the reference covered by annotated CDS : "+str(len(list_align))+"\nSensitivity : "+str(sensitivity)+"\nSpecificity : "+str(specificity)+"\n\nSensitivity is defined as number of proteins in reference covered by annotation among all reference's proteins. Specifity is defined as number of annotated CDS with correspondance in reference proteins among all annotated CDS ")

out_report.close()
out_nn_align.close()			


