# a single database file for an individual drifter deployment
DB_FILE = 'data/db/{drift}.sqlite3'

# a single AcousticStudy generated from a drift database
STUDY_FILE = 'data/study/{drift}.study'

# a single AcousticStudy generated from a drift database
GPS_FILE = 'data/gps/{drift}_GPS.csv'

# Build list of drift names
DRIFT_NAMES = glob_wildcards(DB_FILE).drift

# target rule
rule all_studies:
    input:
        expand(STUDY_FILE, drift=DRIFT_NAMES)

# rule to process a database into an AcousticStudy
rule make_study:
    input:
        DB_FILE
    output:
        STUDY_FILE
    shell:
        "code/make_study.R {input} {output}"

rule add_gps:
    input:
        study = STUDY_FILE,
        gps = GPS_FILE
    output:
        'data/study/{drift}.study.gps'
    shell:
        "code/add_gps.R {input.study} {input.gps} {output}"

# NBHF species identifiers
ID = ["ks", "pd"]

# Dictionary to lookup which studies are labelled by species
TRAINSET = {
    "pd" : ["data/study/Bangarang_Dalls.study", "data/study/CalCURSeas_Dalls.study"],
    "ks" : ["data/study/PG2_02_09_CCES_022_Ksp.study", "data/study/PG2_02_09_CCES_023_Ksp.study"]
}

# Single concatenated spectrogram figure
SP_SPECTR = 'fig/{id}_spectr.png'

# Concatenated spectrograms for all species
ALL_SPECTR = expand(SP_SPECTR, id=ID)

rule make_sp_spectr:
    input:
        lookup(dpath = '{id}', within = TRAINSET)
    output:
        "fig/{id}_spectr.png"
    shell:
        "code/make_spectr.R {input} {output}"

# An AcousticStudy for an individual species
# rule test:
#     input: myfunc
#     output: 

# SP_DIR = 'data/db/{id}/'


# ALL_SP_DIR = expand(SP_DIR, id = SP_DIR_ID)
# ALL_SP_STUDY = expand(SP_STUDY, id = SP_STUDY_ID)

# rule mv_sp_to_dir:
#     input:
#         pd = glob.glob('data/study/*Dalls*')

# An image of a concatenated spectrogram for an individual species
# SP_SPECTR_FILE = 'fig/{sp}_spec.png'
# ALL_SPECTR = expand(SP_SPECTR_FILE, sp=SPECIES)

# New rule to move appropriate studies into species dirs



# Rules to make training studies
# rule ks:
#     input:
#         glob.glob('data/study/*Ksp*')
#     params:
#         "ks"
#     output:
#         'data/train/ks.study'
#     shell:
#         "code/make_sp_study.R {params} {input} {output}"

# rule pd:
#     input:
#         glob.glob('data/study/*Dalls*')
#     params:
#         "pd"
#     output:
#         'data/train/pd.study'
#     shell:
#         "code/make_sp_study.R {params} {input} {output}"

# rule make_spec:
#     input:
#         SP_STUDY_FILE
#     output:
#         SP_SPECTR_FILE
#     shell:
#         "code/make_spectr.R {input} {output}"

# # Make all concatenated spectra
# rule all_spectr:
#     input: ALL_SPECTR

# rule banter:
#     input: TRAINSET
#     output: "data/model/nbhf_banter.rds"
    