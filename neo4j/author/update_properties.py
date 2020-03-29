import json
import codecs
import pandas as pd
import numpy as np

res = pd.read_table("properties.csv", delimiter=',')
diverse_names = np.array(res['name'],str)

name = 'records.json'
output_name = 'author.json'

with codecs.open(name, 'r', 'utf-8-sig') as json_file:
    authors = json.load(json_file)

for author in authors:
    names = author['n']['properties']
    nactu = str(names['id'])
    if nactu in diverse_names:
        ind = np.where(nactu==diverse_names)[0]
        names['diverse'] = 1
        names['size'] = int(res['size'][ind])
    else:
        names['diverse'] = 0
        names['size'] = 0
    author['n']['properties'] = names

with codecs.open(output_name,'w') as json_file:
    json.dump(authors, json_file, ensure_ascii=False, indent=4)
