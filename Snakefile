# Raw data files
DB_FILE = 'data/{set}/db/{drift}.sqlite3'
BIN_DIR = 'data/{set}/bins/{drift}/'
GPS_FILE = 'data/gps/{drift}_GPS.csv'

# Processed data files
STUDY_TEMP_FILE = 'data/{set}/{drift}.tmp'
STUDY_FILE = 'data/{set}/study/{drift}.study'
DAT_FILE = 'data/{set}/dat/{drift}.dat'

# Drift names by dataset
TRAIN_DRIFTS = glob_wildcards('data/train/db/{drift}.sqlite3').drift
PREDICT_DRIFTS = glob_wildcards('data/predict/db/{drift}.sqlite3').drift

rule all_dats:
    input:
        expand(DAT_FILE, set="train", drift=TRAIN_DRIFTS),
        expand(DAT_FILE, set="predict", drift=PREDICT_DRIFTS)

rule get_dat:
    input:
        STUDY_FILE
    output:
        DAT_FILE
    shell:
        "code/write_dat.R {input} {output}"

# input function needed for the branch() element in the rule 'make_study' below
def gps_file_exists(wildcards):
    return exists("data/gps/{wildcards.drift}_GPS.csv".format(wildcards=wildcards))

# this rule applies branched postprocessing to generate the final study according to the assumption that:
#    - training recordings have no gps file, and conform to the system for naming
#    - survey recordings have a GPS file.
rule make_study:
    input:
        branch(
            gps_file_exists,
            then=["code/add_gps.R", GPS_FILE],
            otherwise=["code/set_sp.R"]
        ),
        STUDY_TEMP_FILE
    output:
        STUDY_FILE
    shell:
        "{input} {output}"        

# preprocessing step to turn db file into an AcousticStudy
rule process_drift_db:
    input:
        DB_FILE,
        BIN_DIR
    output:
        temp(STUDY_TEMP_FILE)
    shell:
        "code/process_db.R {input} {output}"

# # Single concatenated spectrogram figure
# SP_SPECTR = 'fig/{id}_spectr.png'

# # Concatenated spectrograms for all species
# ALL_SPECTR = expand(SP_SPECTR, id=ID)

# rule make_sp_spectr:
#     input:
#         lookup(dpath = '{id}', within = TRAINSET)
#     output:
#         "fig/{id}_spectr.png"
#     shell:
#         "code/make_spectr.R {input} {output}"
