import glob

# a single drift database file
DB_FILE = 'data/db/{drift}.sqlite3'

# a single AcousticStudy generated from a drift database
STUDY_FILE = 'data/study/{drift}.study'

# Build list of drift names
DRIFT_NAMES = glob_wildcards(DB_FILE).drift

# A list of all AcoustiStudy names
ALL_STUDIES = expand(STUDY_FILE, drift=DRIFT_NAMES)


rule studies:
    input: ALL_STUDIES

rule make_study:
    input:
        DB_FILE
    output:
        STUDY_FILE
    shell:
        "code/make_study.R {input} {output}"


# NBHF species identifiers
SPECIES = ["pd", "ks"]

# An AcousticStudy for an individual species
SP_STUDY_FILE = 'data/train/{sp}.study'

# An image of a concatenated spectrogram for an individual species
SP_SPECTR_FILE = 'fig/{sp}_spec.png'

TRAINSET = expand(SP_STUDY_FILE, sp=SPECIES)

ALL_SPECTR = expand(SP_SPECTR_FILE, sp=SPECIES)

# Rules to make training studies
rule ks:
    input:
        glob.glob('data/study/*Ksp*')
    params:
        "ks"
    output:
        'data/train/ks.study'
    shell:
        "code/make_sp_study.R {params} {input} {output}"

rule pd:
    input:
        glob.glob('data/study/*Dalls*')
    params:
        "pd"
    output:
        'data/train/pd.study'
    shell:
        "code/make_sp_study.R {params} {input} {output}"

rule make_spec:
    input:
        SP_STUDY_FILE
    output:
        SP_SPECTR_FILE
    shell:
        "code/make_spectr.R {input} {output}"

# Make all concatenated spectra
rule all_spectr:
    input: ALL_SPECTR

rule banter:
    input: TRAINSET
    output: "data/model/nbhf_banter.rds"