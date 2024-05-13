PD = $(wildcard data/db/*Dalls*.sqlite3)
KS = $(wildcard data/db/*Ksp*.sqlite3)
PP = $(wildcard data/db/*Harbor*.sqlite3)

.PHONY: vars
vars:
	@echo KS: $(KS)
	@echo PD: $(PD)

.PHONY : clean
clean :
	rm -f data/temp/* data/processed/*

.PHONY : trainset
trainset: data/processed/pd.study data/processed/ks.study data/processed/pp.study

data/processed/pd.study : code/makeStudy.R code/bindSpecies.R code/trainset.sh $(PD)
	code/trainset.sh $(PD) pd $@

data/processed/ks.study : code/makeStudy.R code/bindSpecies.R code/trainset.sh $(KS)
	code/trainset.sh $(KS) ks $@

data/processed/pp.study : code/makeStudy.R code/bindSpecies.R code/trainset.sh $(PP)
	code/trainset.sh $(PP) pp $@