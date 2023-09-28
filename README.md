# Replication Package for: Indirect Savings from Public Procurement
Centralization

The data and code in this repository reproduce tables and figures for Indirect Savings from Public Procurement
Centralization by Clarissa Lotti, Arieda Muço, Giancarlo Spagnolo, and Tommaso Valletti.

### The author(s) of the manuscript have legitimate access to and permission to use the data used in this manuscript.

### Summary of availability
All data **are** publicly available.

The original data needed to run this code are from Bandiera, Oriana, Andrea Prat, and Tommaso Valletti (BPV) and can be accessed at
https://doi.org/10.1257/aer.99.4.1278. (See  `LICENSE.txt`)


The repository contains the following structure: 

```
├── LICENSE.txt # License file
├── code # Main code directory
│   ├── figures # Code for figures
│   ├── intermediate # Intermediate processing scripts
│   └── tables # Scripts for generating tables
├── data # Main data directory
├── main.txt # Main text file
└── output # Output directory (two subdirectories included, namely /figures and /tables)
```

Data files needed to generate all the replication is included in the data folder 


| Data file | Source | Provided |
|-----------|--------|----------|---------|
| `consip_data_AER.dta` | BPV |  Yes |
| `consip.dta.dta` | Own/Derived | Yes |
| `previous_consip.dta` | Own/Derived | Yes |


### The main.txt contains the file order and commands to run from the command line.

The provided code reproduces:
- All numbers provided in text in the paper
- All tables and figures in the paper
- Selected tables and figures in the paper, as explained and justified below.


| Figure/Table #    | Program                  |
|-------------------|--------------------------|
| Table 1           | sum_stats.do    |
| Table 2           | main-specification.do|
| Table 3           | heterogeneities-active.do|
| Table 4          | previous-consip-experience.do         |
| Table 5         | direct_indirect.do     |
|-------------------|--------------------------|
| Table A1           | days-active-deal.do   |
| Table A2           | t-test.do|
| Table D1         | previous-consip-experience-robustness.do|
| Table E1         | appendix-het-good.do         |
| Table E2         | appendix-het-pb-class.do     |
| Table E3          | appendix-het-quantity.do    |
| Table E4         | fe-quartiles.do        |
| Table F1         | appendix-event_studies.do     |
| Table F2         | did-complex-simple.do    |
|-------------------|--------------------------|
| Figure 1           | goods_deals.do   |
| Figure 2           | event_studies.do|
| Figure 3        | competence.do|
| Figure 4        | previous-consip-coefficient-estimates.do        |
|-------------------|--------------------------|
| Figure A1          | appendix_figure_residualized_prices.do   |
| Figures B1 & B2          | descriptives_cutoffs.do|
| Figures D1       | robustness-drop-one.do|
| Figure D2       |cofficient-estimates-DH.do       |
| Figure F1       | appendix-event-study.do        |
|-------------------|--------------------------|

# Description of programs/code


- Programs in `code/intermediate` will prepare the data and files needed to run the tables and figures above
- Programs in `code/tables` will generate all tables included the paper and appendix
- Programs `code/figures` will generate all figures included the paper and appendix
- The code in `main.txt` will run them all and delete log files generated. If you want to store the log files delete the last line included in the file


```
Stata commands needed to run the files:

reghdfe version 5.7.3 13nov2019  
esttab  version 2.0.9  06feb2016  Ben Jann 
estout  version 3.21  19aug2016  Ben Jann 
version 2.3.5  05feb2016  Ben Jann 
frmttable version 1.31  12jul2015 by John Luke Gallup 
pdslasso package 1.1 15jan2019 


Also make sure to install the following: 

ssc install moremata  # Prerequisite to implement De Chaisemartin and d’Haultfoeuille (2020) 
ssc install did_multiplegt  # Implements De Chaisemartin and d’Haultfoeuille (2020) 
ssc install blindschemes #For plots 
set scheme burd #For plots 

References

Bandiera, Oriana, Andrea Prat, and Tommaso Valletti. “Active and Passive Waste in Government Spending: Evidence from a Policy Experiment.” American Economic Review 99, no. 4 (2009a): 1278–1308. https://doi.org/10.1257/aer.99.4.1278.

Bandiera, Oriana, Prat, Andrea, and Valletti, Tommaso. Replication data for: Active and Passive Waste in Government Spending: Evidence from a Policy Experiment. Nashville, TN: American Economic Association [publisher], 2009b. Ann Arbor, MI: Inter-university Consortium for Political and Social Research [distributor], 2019-10-12. https://doi.org/10.3886/E113315V1
