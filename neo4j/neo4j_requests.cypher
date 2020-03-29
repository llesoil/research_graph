//call api -> export as export.json
// url: https://api.archives-ouvertes.fr/search/?q=structId_i:(2539%20||%20491189)&wt=json&fl=title_s&fl=authFullName_s&fl=journalTitle_s&conferenceTitle_s&fl=producedDate_s&fl=en_keyword_s&fl=doiId_s&rows=9999


//python file map_names.py

// create paper db
WITH "file:/paper.json" AS url
CALL apoc.load.json(url) YIELD value
UNWIND value.response.docs AS item

CREATE (paper:Paper {id: item.id})
SET paper.title = item.title_s,
    paper.author = item.authFullName_s,
    paper.date = item.producedDate_s,
    paper.kwords = item.en_keyword_s;

//match (p:Paper)
//foreach (k in p.author | merge (a:Author {id : k}));
//then export the author database in the records.json file
//finally, add properties to researchers with the python file update_properties.py 
// delete the author database to apply the updates
// merge (a:Author) delete a;


// create author db
WITH "file:/author.json" AS url
CALL apoc.load.json(url) YIELD value
UNWIND value.n AS item

CREATE (author:Author {id: item.properties.id})
SET author.diverse = item.properties.diverse,
    author.size = item.properties.size;

// create keyword db
match (p:Paper)
foreach (k in p.kwords | merge (keyword:Kwords {id : k}))

// create wrote link (author-> paper)

MATCH (p:Paper), (a:Author)
WHERE a.id in p.author
CREATE (a)-[w:Wrote]->(p)
RETURN w

// create study link (author-> keyword) -> takes a while to compute...

MATCH (k:Kwords), (p:Paper), (a:Author)
WHERE a.id in p.author and k.id in p.kwords
CREATE (a)-[s:Study]->(k)
RETURN s

//request papers written

MATCH p=(a:Author)-[r:Wrote]->() where a.diverse >0 RETURN p LIMIT 2500


//request kwords studied

MATCH p=(a:Author)-[r:Study]->() where a.diverse >0 RETURN p LIMIT 2500












