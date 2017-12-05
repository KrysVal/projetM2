from Bio import SeqIO, SeqRecord
import argparse


def duplicate_remover(file):
    d = {}
    duplicate = []
    for record in SeqIO.parse(file, "fasta"):
        if record.seq in d.keys():
            print("duplicate found : \n" + record.id)
            duplicate.append(record.id)
        d[record.seq] = record.description
    return d, duplicate


def new_file_writer(file, d):
    with open(file, 'w') as f:
        for key in d.keys():
            data = SeqRecord.SeqRecord(key, id=d[key])
            SeqIO.write(data, f, "fasta")


def duplicate_file_writer(file,duplicate_list):
    with open(file,'w') as f:
        for double in duplicate_list:
            f.write(double + "\n")

if __name__ == '__main__':
    # Get argument and parse them
    parser = argparse.ArgumentParser()
    # file path :
    parser.add_argument("-f", "--filename", required=True)
    args = parser.parse_args()

    filename = args.filename

    d, duplicate = duplicate_remover(filename)
    o_filename = filename[:-3] + "2" + filename[-3:]
    d_filename = filename[:-3] + "_duplicate.txt"
    new_file_writer(o_filename, d)
    duplicate_file_writer(d_filename, duplicate)

