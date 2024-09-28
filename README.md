# Pipeline with Snakemake

The popular bioinformatics tool helped me create a pipeline for my passive acoustic monitoring data.

## Background

My master's thesis was a computational research project using a large dataset of echolocation clicks detected during thousands of hours worth of recording sounds in the marine environment.

The difficulties of dealing with large batches of files which needed to undergo multiple stages of processing was something I struggled with over the course of my project. Snakemake had the potential to radically streamline and improve this undertaking.

## Objectives

The pipeline I wanted to construct had started with raw data databases and associated binary files and ended with tidy data for each database containing a suite of acoustic features extracted from each and every click contained therein.

There were some extra tidbits:

1)  For databases with available geolocations, I had to perform an extra processing step to link the GPS positions with the acoustic detections.

2)  For databases forming the training set an extra processing step had to be performed to label each detection in the database with the proper species ID with.

This led me to create a branched structure in my pipeline

3)  As an experimental "extension" step to this pipeline I also made a rule for some data visualizations using some of the earlier targets.

## Issues

One thing I discovered doing this is that `renv` and `mamba` don't seem to play so nice together for managing the project environment.

In the future, if I want to use Snakemake to execute my pipeline, I'd opt to use mamba to manage my environment, in which case the R libraries available would have to be those available through mamba.

If I wanted to keep the project strictly R, then I would opt to use `targets` or another R package that fulfills the same role as Snakemake.
