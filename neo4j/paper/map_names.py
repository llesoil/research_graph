import json
import codecs
import pandas as pd
import numpy as np

res = pd.read_table("../data/mapping_names.csv", delimiter=',')
hal_names = np.array(res['hal_name'],str)
new_names = np.array(res['name'],str)
res

name = '../data/export.json'
output_name = '../data/paper.json'

with codecs.open(name, 'r', 'utf-8-sig') as json_file:
    authors = json.load(json_file)
    
for author in authors['response']['docs']:
    auth_names = author['authFullName_s']
    for i in range(len(auth_names)):
        if str(auth_names[i]) in hal_names:
            auth_names[i] = new_names[np.where(str(auth_names[i])==hal_names)][0]

with codecs.open(output_name,'w') as json_file:
    json.dump(authors, json_file, ensure_ascii=False, indent=4)
