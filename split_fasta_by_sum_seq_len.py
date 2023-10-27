import argparse
from Bio import SeqIO

parser = argparse.ArgumentParser(
    description='Split fasta file to chunks by max sum length of sequences.')

parser.add_argument('-f', '--fasta_file', type=str,
                    help='Fasta file input.', required=True)
parser.add_argument('-l', '--max_sum_seq_len', type=int,
                    help='Maximum of sum sequence length to split input file to chunks', required=True)

args = parser.parse_args()


def split_by_max_sum_seq_len(in_fasta_file_name, max_sum_seq_len):
    chunk_id = 0
    cur_sum_of_len = 0
    out_file = open(f"{in_fasta_file_name}_{chunk_id}.fasta", "w")
    for record in SeqIO.parse(in_fasta_file_name, "fasta"):
        cur_sum_of_len += len(record)
        if cur_sum_of_len >= max_sum_seq_len:
            chunk_id += 1
            cur_sum_of_len = len(record)
            out_file.close()
            out_file = open(f"{in_fasta_file_name}_{chunk_id}.fasta", "w")
        SeqIO.write(record, out_file, format="fasta")
    out_file.close()


split_by_max_sum_seq_len(args.fasta_file, args.max_sum_seq_len)