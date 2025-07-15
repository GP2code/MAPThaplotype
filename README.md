---
title: README

---

# Exploring MAPT-containing H1 and H2 haplotypes  in Parkinson's Disease across diverse populations

`GP2 ❤️ Open Science 😍`
[![DOI](https://zenodo.org/badge/15933056.svg)](10.5281/zenodo.15933056) ##Add zenodo DOI
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**Last Updated:** July 2025

## Summary
This repository contains the code and data analysis pipelines used for the research project titled "Exploring MAPT-containing H1 and H2 haplotypes  in Parkinson's Disease across diverse populations". This study examined two main haplotypes at the 17q21.31 locus, which contains the _MAPT_ gene, and 
their association to risk of Parkinson’s disease (PD) across diverse ancestry groups. 

## Citation
If you use this repository or find it helpful for your research, please cite the corresponding manuscript:

> Title
Authors



>> Manuscript DOI: coming soon
>> 
>> GitHub DOI: 10.5281/zenodo.15933056

### Data Statement 
* Data used in the preparation of this analysis were obtained from the Global Parkinson’s Genetics Program (GP2; https://gp2.org). Specifically, we used Tier 2 data from GP2 releases 6 [DOI: https://doi.org/10.5281/zenodo.10962119] and 7 [DOI: https://doi.org/10.5281/zenodo.10962119]. Tier 1 data can be accessed by completing a form on the Accelerating Medicines Partnership in Parkinson’s Disease (AMP®-PD) website (https://amp-pd.org/register-for-amp-pd). Tier 2 data access requires approval and a Data Use Agreement signed by your institution.
* Genotyping imputation, quality control, ancestry prediction, and processing were performed using GenoTools (v1.0.0), publicly available on GitHub



# Repository Orientation 
- The `analyses/` directory includes all analyses discussed in the manuscript

```
analyses/
├── 00_MAPThaplotypes_rs1052553_release7.ipynb
├── 01_MAPTproject_AAO_regression.ipynb
├── 02_MAPT_Haplotype_freq_plots.R
├── 03_MAPT_Forest-plots.ipynb
├── 04_MAPTproject_Subhaplotypes_analysis.ipynb
├── 05_MAPT_Subhaplo_Plots.R
├── 06_MAPT_GenoML_Analysis.ipynb
├── 07_MAPT_Locus_Zoom_Plots.R

```

---
### Analysis Notebooks
* Languages: Python, bash, and R


| Notebooks / Scripts                            | Description                                                                                                      |
|------------------------------------------------|------------------------------------------------------------------------------------------------------------------|
| 00_MAPThaplotypes_rs1052553_release7.ipynb     | Analyses looking at the frequency of haplotypes in PD cases and controls in MAPT using the tagging SNP rs1052553 |
| 01_MAPTproject_AAO_regression.ipynb            | Adjusted regression for H1/H2 haplotypes in Age at Onset for PD                                                 |
| 02_MAPT_Haplotype_freq_plots.R                 | Bar plots of MAPT H1/H2 haplotype frequencies across multiple populations in PD cases and controls               |
| 03_MAPT_Forest-plots.ipynb                     | Visualization of results from association (adjusted and unadjusted) analysis using forestplots                   |
| 04_MAPTproject_Subhaplotypes_analysis.ipynb    | Analyses looking at the frequency of subhaplotypes in PD cases and controls in MAPT using six tagging SNPs       |
| 05_MAPT_Subhaplo_Plots.R                       | Bar plots of MAPT H1/H2 subhaplotype frequencies across multiple populations in PD cases and controls            |
| 06_MAPT_GenoML_Analysis.ipynb                  | GenoML to rank subhaplotypes by predictive value                                                                 |
| 07_MAPT_Locus_Zoom_Plots.R                     | Locus zoom regional association plots for the MAPT locus                                                         |


---

## Software

| Software                            | Version(s)        | Resource URL                          | RRID             | Notes                                                                                 |
|-------------------------------------|-------------------|----------------------------------------|------------------|---------------------------------------------------------------------------------------|
| Python Programming Language         | 3.10.12           | [python.org](http://www.python.org/)   | RRID:SCR_008394  | pandas; numpy; seaborn; matplotlib;  Used for general data wrangling and analyses |
| R Project for Statistical Computing | 4.3.0             | [r-project.org](http://www.r-project.org/) | RRID:SCR_001905  | tidyverse; dplyr; tidyr; ggplot; data.table; topr; Used for general data wrangling/plotting/analyses |
| PLINK                               | 1.9 and 2.0       | [nitrc.org](http://www.nitrc.org/projects/plink) | RRID:SCR_001757  | Used for genetic analyses  |
|GenoML|2|[genoml.com](https://genoml.com/)|NA | Used for machine learning analysis 
