import sys

input_file=sys.argv[1] #input file
output_file=sys.argv[2] #output file

#read input file and count lines
count = len(open(input_file).readlines())

#write line number into output file
with open(output_file, 'w') as f:
    f.write('# of Lines: '+str(count)+"\n")
f.close()
