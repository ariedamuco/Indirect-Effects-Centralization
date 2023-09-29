import os
os.chdir("output/tables")
files = ['previous_consip_purchase.tex', 'previous_consip_purchase_robustness.tex']

for file in files:
    text = open(file,"r").read()
    replaced = text.replace("beta{", "\\beta_{")
    f = open(file, "w")
    f.write(replaced)
    f.close()