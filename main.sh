#! /bin/bash
#Please run first intermediate files, then tables and finally figures. While the order below is not strictly necessary, some figures are generated from table outputs
#alias stata-mp="c:/'Program Files'/Stata18/StataMP-64.exe" - to run on a Windows machine
#Intermediate files

#stata-mp -e code/install-packages.do

stata-mp -e code/intermediate/create-data.do #creates main data for analysis
stata-mp -e code/intermediate/good-char.do #stores locals for regressions
stata-mp -e code/intermediate/lasso-select.do #runs lasso regression to select controls
stata-mp -e code/intermediate/previous-consip-purchase.do #generates data for previous Consip purchase
stata-mp -e code/intermediate/scatterplots-event-studies.do #helps plotting the scatterplot

#Tables
stata-mp -e code/tables/sum_stats.do #Table 1
stata-mp -e code/tables/main-specification.do #Table 2
stata-mp -e code/tables/heterogeneities-active.do  #Table 3
stata-mp -e code/tables/previous-consip-experience.do #Table 4
stata-mp -e code/tables/direct_indirect.do #Table 5

##Tables Appendix
stata-mp -e code/tables/days-active-deal.do #Appendix Table A1 
stata-mp -e code/tables/t-test.do #Appendix Table A2
stata-mp -e code/tables/previous-consip-experience-robustness.do #Appendix Table D1
stata-mp -e code/tables/appendix-het-good.do #Appendix Table E1
stata-mp -e code/tables/appendix-het-pb-class.do #Appendix Table E2
stata-mp -e code/tables/appendix-het-quantity.do #Appendix Table E3
stata-mp -e code/tables/fe-quartiles.do #Appendix Table E4
stata-mp -e code/tables/appendix-event-study.do  #Appendix Table F1
stata-mp -e code/tables/did-complex-simple.do #Appendix Table F2


python code/tables/clean-tables.py #clean tables about previous Consip experience

#Figures
stata-mp -e code/figures/goods_deals.do #Figure 1
#stata-mp -e code/figures/event_studies.do #Figure 2
stata-mp -e code/figures/competence.do #Figure 3
stata-mp -e code/figures/previous-consip-coefficient-estimates.do #Figure 4

##Figures Appendix
stata-mp -e code/figures/appendix_figure_residualized_prices.do #Figure A1
stata-mp -e code/figures/descriptives_cutoffs.do #Figures B1 & B2
stata-mp -e code/figures/robustness-drop-one.do #Figures D1
stata-mp -e code/figures/cofficient-estimates-DH.do #Figure D2
stata-mp -e code/figures/appendix-event-study.do #Figure F1
stata-mp -e code/figures/appendix-event-study-end-deal.do #Figure F2

