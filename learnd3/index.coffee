fs = require 'fs'
d3 = require 'd3'

keyFile = fs.readFileSync 'key.csv'
keyData = d3.csv.parse keyFile.toString()

###
key = {}
keys = []
for k in keyData
  keys.push k.question
  key[k.question] = k
###

data = []

processDatum = (datum) ->
  d = {}
  # loop over all the questions and curate answers
  for k in keyData
    value = datum[k.question]
    if k.type == "array"
      values = value.split ","
      values = values.map (v) ->
        return v.trim()
      d[k.key] = values
    else
      d[k.key] = value
  data.push d

meetupFile = fs.readFileSync 'meetup.csv'
meetupData = d3.csv.parse meetupFile.toString()

twitterFile = fs.readFileSync 'twitter.csv'
twitterData = d3.csv.parse twitterFile.toString()

for datum in meetupData
  processDatum(datum)

for datum in twitterData
  processDatum(datum)

console.log "# data", data.length
fs.writeFileSync "results.json", JSON.stringify data, null, 2


