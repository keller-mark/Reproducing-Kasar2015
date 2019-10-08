from os.path import join

DATA_DIR = 'data'
RAW_DIR = join(DATA_DIR, 'raw')
PROCESSED_DIR = join(DATA_DIR, 'processed')

SA_GPU_PY = join('SignatureAnalyzer-GPU', 'SignatureAnalyzer-GPU.py')

rule all:
    input:
        join(PROCESSED_DIR, "nmd1000_results.txt"),
        join(PROCESSED_DIR, "nosplit_results.txt")

rule transpose:
    input:
        join(RAW_DIR, "counts.{dataset}.SBS-96.tsv")
    output:
        join(PROCESSED_DIR, "counts.{dataset}.SBS-96.T.tsv")
    script:
        "transpose.py"


rule signatures:
    input:
        join(PROCESSED_DIR, "counts.DFCI-30-Kasar2015.{dataset}.WGS.SBS-96.T.tsv")
    output:
        join(PROCESSED_DIR, '{dataset}_results.txt')
    shell:
        """
        python {SA_GPU_PY} \
            --data {input} \
            --output_dir {PROCESSED_DIR} \
            --output_prefix {wildcards.dataset} \
            --max_iter 1000000 \
            --prior_on_W L1 \
            --prior_on_H L1 \
            --objective poisson \
            --a 10 \
            --K0 96 \
            --parameters_file {DATA_DIR}/parameters.tsv \
            --labeled
        """