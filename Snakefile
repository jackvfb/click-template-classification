# Raw data files
DB_FILE = 'data/{set}/db/{drift}.sqlite3'
BIN_DIR = 'data/{set}/bins/{drift}/'
GPS_FILE = 'data/gps/{drift}_GPS.csv'
SP_LOOKUP = 'data/train/sp_lookup.table'

# Processed data files
STUDY_TEMP_FILE = 'data/{set}/{drift}.tmp'
STUDY_FILE = 'data/{set}/study/{drift}.study'
# STUDY_DAT = 'data/{set}/dat/{drift}.dat'
# STUDY_DAT_BANT = 'data/{set}/dat/{drift}.dat'

# Drift names
TRAIN_DRIFTS = glob_wildcards('data/train/db/{drift}.sqlite3').drift
PREDICT_DRIFTS = glob_wildcards('data/predict/db/{drift}.sqlite3').drift

# rule to process a database into an AcousticStudy
rule all_studies:
    input:
        expand(STUDY_FILE, set="train", drift=TRAIN_DRIFTS),
        expand(STUDY_FILE, set="predict", drift=PREDICT_DRIFTS),

# rule bants:
#     input:
#         "data/bant/train.dat",
#         "data/bant/predict.dat"

# rule exp_bant:
#     input:
#         STUDY_FILE_W_MOD
#     output:
#         BANT_DAT
#     shell:
#         "code/exp_bant.R {input} {ouput}"

rule make_study:
    input:
        branch(
            exists(GPS_FILE),
            then=["code/add_gps.R", GPS_FILE],
            otherwise=["code/set_sp.R"]
        ),
        STUDY_TEMP_FILE
    output:
        STUDY_FILE
    shell:
        "{input} {output}"        

rule process_drift_db:
    input:
        DB_FILE,
        BIN_DIR
    output:
        temp(STUDY_TEMP_FILE)
    shell:
        "code/process_db.R {input} {output}"

# branch here, assumes that training data does NOT have GPS data, and survey data DOES


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
