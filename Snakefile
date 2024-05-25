# a single database file for an individual drifter deployment
DB_FILE = 'data/{set}/db/{drift}.sqlite3'

# a single database file for an individual drifter deployment
BIN_DIR = 'data/{set}/bins/{drift}/'

# a single AcousticStudy generated from a drift database
STUDY_FILE = 'data/{set}/study/{drift}.study'


# # a single AcousticStudy generated from a drift database
# GPS_FILE = 'data/gps/{drift}_GPS.csv'

# Build list of drift names

TRAIN_DRIFTS = glob_wildcards('data/train/db/{drift}.sqlite3').drift
PREDICT_DRIFTS = glob_wildcards('data/predict/db/{drift}.sqlite3').drift

# DRIFT_NAMES = glob_wildcards(expand(DB_FILE, set=["train", "predict"]).drift)

# print(DRIFT_NAMES)

# # target rule
# rule all_studies:
#     input:
#         expand(STUDY_FILE, drift=DRIFT_NAMES)

# rule to process a database into an AcousticStudy
rule all_studies:
    input:
        expand(STUDY_FILE, set="train", drift=TRAIN_DRIFTS),
        expand(STUDY_FILE, set="predict", drift=PREDICT_DRIFTS),

rule make_study:
    input:
        DB_FILE,
        BIN_DIR
    output:
        STUDY_FILE
    shell:
        "code/make_study.R {input} {output}"

# rule add_gps:
#     input:
#         study = STUDY_FILE,
#         gps = GPS_FILE
#     output:
#         'data/study/{drift}.study.gps'
#     shell:
#         "code/add_gps.R {input.study} {input.gps} {output}"

# # NBHF species identifiers
# ID = ["ks", "pd"]

# # Dictionary to lookup which studies are labelled by species
# TRAINSET = {
#     "pd" : ["data/study/Bangarang_Dalls.study", "data/study/CalCURSeas_Dalls.study"],
#     "ks" : ["data/study/PG2_02_09_CCES_022_Ksp.study", "data/study/PG2_02_09_CCES_023_Ksp.study"]
# }

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
