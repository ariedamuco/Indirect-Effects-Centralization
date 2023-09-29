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
├── ado # Ado files for replication
├── code # Main code directory
│   ├── install-packages.do #install necessary Stata packages in the local folder
│   ├── figures # Code for figures
│   ├── intermediate # Intermediate processing scripts
│   └── tables # Scripts for generating tables
├── data # Main data directory
├── main.sh # Main text file
└── output # Output directory (two subdirectories included, namely /figures and /tables)
```

Data files needed to generate all the replication is included in the data folder 


| Data file | Source | Provided |
|-----------|--------|---------|
| `consip_data_AER.dta` | BPV |  Yes |
| `consip.dta.dta` | Own/Derived | Yes |
| `previous_consip.dta` | Own/Derived | Yes |


# Computational requirements

### Software requirements

- Stata (code was last run with version 16)
  - `estout` (as of  26apr2022)
  - `reghdfe` (as of 08aug2023)
   - `pdslasso` (as of 04sept2018)
   - `outreg` (as of 18sep2015)
   - `outtable`  (as of 03aug2014)
  - `listtab`  (as of 04 November 2012)
   - `ftools`  (as of 08aug2023)

and  `did_multiplegt`, `lassopack`,  `egenmore` ,  `moremata`,  `blindschemes`, `scheme-burd`.

 
  - the program "`install-packages.do`" combines setup as in https://gist.github.com/larsvilhuber/8ead0ba85119e4085e71ab3062760190
  and configuration as in 
  https://gist.github.com/larsvilhuber/c3dddbcf73e7534a22e3583b3422d7c5
  will install all dependencies locally, and should be run once.

- Python 3.10.9

#### Summary

- The code is relatively fast to run and you should be able to run everything within one hour. 

- Figures are saved in .pdf in
line with the AEA, guidelines, however, the colors might change if the code is run from bash rather than Stata terminal

- Table 4, Figure 4, and Table D1 (which provides robustness for Table 4) depend on the setting of the seed, and the code may yield different results depending on the operating system. This issue arises because we are dealing with multiple transactions on the same date for the same identifier. Since Stata selects randomly which dates go first every time the code is run, we set a seed and use a uniformly distributed variable to break the ties regarding which date gets ordered first.

#### Details

The code was last run on a **8-core Chip Apple M1 with MacOS version 12.5**. 

### The main.sh contains the file order and commands to run from the command line.

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
| Table F1         | appendix-event-study.do     |
| Table F2         | did-complex-simple.do    |
|-------------------|--------------------------|
| Figure 1           | goods_deals.do   |
| Figure 2           | event_study.do|
| Figure 3        | competence.do|
| Figure 4        | previous-consip-coefficient-estimates.do        |
|-------------------|--------------------------|
| Figure A1          | appendix_figure_residualized_prices.do   |
| Figures B1 & B2          | descriptives_cutoffs.do|
| Figures D1       | robustness-drop-one.do|
| Figure D2       |cofficient-estimates-DH.do       |
| Figure F1       | appendix-event-study.do        |
| Figure F2       | appendix-event-study-end-deal.do        |
|-------------------|--------------------------|

# Description of programs/code

- Programs in `code/intermediate` will prepare the data and files needed to run the tables and figures above
- Programs in `code/tables` will generate all tables included the paper and appendix
- Programs `code/figures` will generate all figures included the paper and appendix
- The code in `main.sh` will run all necessary files for this replication package

```

References

Bandiera, Oriana, Andrea Prat, and Tommaso Valletti. “Active and Passive Waste in Government Spending: Evidence from a Policy Experiment.” American Economic Review 99, no. 4 (2009a): 1278–1308. https://doi.org/10.1257/aer.99.4.1278.

Bandiera, Oriana, Prat, Andrea, and Valletti, Tommaso. Replication data for: Active and Passive Waste in Government Spending: Evidence from a Policy Experiment. Nashville, TN: American Economic Association [publisher], 2009b. Ann Arbor, MI: Inter-university Consortium for Political and Social Research [distributor], 2019-10-12. https://doi.org/10.3886/E113315V1
