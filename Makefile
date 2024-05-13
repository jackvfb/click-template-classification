DB_PD = $(wildcard data/db/*Dalls*.sqlite3)
DB_KS = $(wildcard data/db/*Ksp*.sqlite3)
DB_PP = $(wildcard data/db/*Harbor*.sqlite3)
TRAINSET= data/processed/pd.study data/processed/ks.study data/processed/pp.study 
MEANSPEC=$(patsubst data/processed/%.study, figs/%.png, $(TRAINSET))

.PHONY: vars
vars:
	@echo KS: $(DB_KS)
	@echo PD: $(DB_PD)
	@echo TRAINSET: $(TRAINSET)
	@echo MEANSPEC: $(MEANSPEC)

.PHONY : clean
clean :
	rm -f data/temp/* data/processed/* figs/*

.PHONY: meanspec
meanspec : $(MEANSPEC)

figs/%.png : code/fig-concatspec.sh data/processed/%.study
	$^ $@

.PHONY : trainset
trainset: $(TRAINSET)

data/processed/pd.study : code/makeStudy.R code/bindSpecies.R code/trainset.sh $(PD)
	code/trainset.sh $(DB_PD) pd $@

data/processed/ks.study : code/makeStudy.R code/bindSpecies.R code/trainset.sh $(KS)
	code/trainset.sh $(DB_KS) ks $@

data/processed/pp.study : code/makeStudy.R code/bindSpecies.R code/trainset.sh $(PP)
	code/trainset.sh $(DB_PP) pp $@