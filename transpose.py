import pandas as pd

df = pd.read_csv(snakemake.input[0], sep='\t', index_col=0)
df = df.transpose()
df.to_csv(snakemake.output[0], sep='\t', index=True)