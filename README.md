# Pipeline with Snakemake

The popular bioinformatics tool helped me create a pipeline for my passive acoustic monitoring data.

## Background

My master's thesis was a computational research project using a large dataset of echolocation clicks detected during thousands of hours worth of recording sounds in the marine environment.

The difficulties of dealing with large batches of files which needed to undergo multiple stages of processing was something I struggled with over the course of my project and made me instantly recognize that a tool like Snakemake would bring some great benefits to the project.

### Pipeline requirements

The pipeline I wanted to construct had to take the raw data databases from thir perform the following tasks had to take PAMguard databases and associated binary files and process the echolocation click detections in each database into a tidy data that contained all the clicks along with the associated click features, extracted using PAMpal package in R.

There were some extra tidbits:

1)  For databases with available geolocations, I had to perform an extra processing step to link the GPS positions with the acoustic detections.

2)  For databases forming the training set (see below) an extra processing step had to be performed to associated the proper species ID with each detection in the database.

This led me to create a branched structure in my pipeline

3)  As an experimental "extension" step to this pipeline I also made a rule for some data visualizations using some of the earlier targets.

## Issues

One thing I discovered doing this is that `renv` and `mamba` don't seem to play so nice together for managing the project environment.

In the future, if I want to use Snakemake to execute my pipeline, I'd opt to use mamba to manage my environment, in which case the R libraries available would have to be those available through mamba.

If I wanted to keep the project strictly R, then I would opt to use `targets` or another R package that fulfills the same role as Snakemake.