
import os
import pandas as pd

data = pd.read_stata("data/consip.dta")

dictionary = {'cartiera modo': "cartiera mondi", 
              'centrufficio loreto': "centrufficio loreto spa",
              'colmas': "colmas dimension",
              "della chiara": "della chiara snc",
              'ergo': "ergo plus",
              "fujitsu - siemens":"fujitsu" ,
              'gb': "gb srl",
              'hp compaq': "hp",
              'ibm acs': "ibm",
              'ibm compatibile': "ibm",
              'ibm-polyedra': "ibm",
              'ibm compatibile': "ibm",
              'iss 185+isd4080': "iss", 
              'isss165+isd4060': "iss",
              "junior antoni's office": "junior anthony's office",
              'lt form2': "lt form",
              'malerba': "manerba spa",
              "manerba": "manerba spa",
              'mr': "mrv",
              'r 170eo': "r160eo",
              'soporcel': "soporcell"}

list_brands = [dictionary.get(brand, brand) for brand in data["brand_s"]]
data["brand_s"] = list_brands

data.to_stata("data/consip_brands.dta")