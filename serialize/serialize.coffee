
flatten = (obj) ->
  if _.isObject obj
    for p1, v1 of obj
      if _.isObject v1
        vf = flatten v1
        for p2, v2 of vf
          obj["#{p1}_#{p2}"] = v2
        delete obj[p1]
  obj

# Restructures the size entries in a way so that instead of symbolsizedetectDetails.[size] = {...}
# symbolsizedetectDetails.size[1..4] = {size: [size], ...} is defined. So the size itself is never a key, always a value.
cleanuprow = (row) ->
  s = row.symbolsizedetectDetails
  sizes = _(s).keys()
  sizes = _(sizes).sortBy (size) ->
    -1 * Number size
  for size, i in sizes
    s["size#{i}"] = s[size]
    s["size#{i}"].size = Number size
    delete s[size]
  s.sizes = sizes.length

$.getJSON "sample.json", (res) ->
  res = res.rows
  res = _.map res, (r) ->
    row = r.value
    delete row._rev
    cleanuprow row
    flatten row
    row
  console.info "flattened objects", res
  # collect property names
  propertynames = []
  for row in res
    for p, v of row
      unless _(propertynames).contains p
        propertynames.push p
  console.info "Property names", propertynames

  # Create CSV
  # Add property names
  csv = '"' + propertynames.join('","') + '"\n'
  # Add rows
  for row in res
    values = []
    for p in propertynames
      values.push row[p] or ''
    csv += '"' + values.join('","') + '"\n'

  console.info csv