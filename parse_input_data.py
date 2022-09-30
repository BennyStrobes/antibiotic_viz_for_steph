import numpy as np
import sys
import pdb


input_file = sys.argv[1]
output_stem = sys.argv[2]

or_output_file = output_stem + '_data_or.txt'

f = open(input_file)
t2 = open(or_output_file,'w')
t2.write('antibiotic_name\taa\tbb\tcc\tdd\n')
for line in f:
	line = line.rstrip()
	if line.startswith(',(N'):
		data = line.split(',')
		dd = data[1].split('N=')[1].split(')')[0]
		bb = data[2].split('N=')[1].split(')')[0]
		continue
	if line.startswith('\ufeff'):
		continue
	if line.startswith(','):
		continue
	data = line.split(',')
	antibiotic = data[0]
	total_number = data[1].split(' (')[0]
	allergy_total_number = data[2].split(' (')[0]
	t2.write(antibiotic + '\t' + allergy_total_number + '\t' + bb + '\t' + total_number + '\t' + dd + '\n')
f.close()
t2.close()