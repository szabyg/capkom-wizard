appFiles  = [
  'lib/ttswidget/ttswidget.coffee'
  'lib/explain/explain.coffee'
  'lib/sizedetect/sizedetect.coffee'
  'lib/wordmatch/wordmatch.coffee'
  'lib/capkomsymbolwidget/capkomsymbolwidget.coffee'

  'src/fontsizewidget.coffee'
  'src/symbolset.coffee'
  'src/wizard.coffee'
  'src/symbolsets.coffee'
  'src/stages.coffee'
  'src/profile.coffee'
  'src/navigation.coffee'
  'src/thememap.coffee'
]
target = "lib/capkomwizard.js"

widgets = [
  'lib/capkomsymbolwidget/capkomsymbolwidget.coffee'
  'lib/explain/explain.coffee'
  'lib/sizedetect/sizedetect.coffee'
  'lib/ttswidget/ttswidget.coffee'
  'lib/wordmatch/wordmatch.coffee'
]

fs         = require 'fs'
{exec}     = require 'child_process'
util       = require 'util'

justchanged = null

task 'watch', 'Watch prod source files and build changes', ->
    invoke 'build'
    invoke 'widgetwatch'
    util.log "Watching for changes in #{appFiles.join ', '}"

    for file in appFiles then do (file) ->
        fs.watchFile file, (curr, prev) ->
            if +curr.mtime isnt +prev.mtime
                util.log "Saw change in #{file}"
                justchanged = file
                invoke 'build'

task 'build', 'Build single application file from source files', ->
    # invoke 'coffeeFiles'
    appContents = new Array remaining = appFiles.length
    for file, index in appFiles then do (file, index) ->
        fs.readFile file, 'utf8', (err, fileContents) ->
            throw err if err
            appContents[index] = fileContents
            process() if --remaining is 0
    process = ->
        fs.writeFile 'lib/tmp.coffee', appContents.join('\n\n'), 'utf8', (err) ->
            throw err if err
            cmd = 'coffee -c -o lib lib/tmp.coffee'
            util.log "executing #{cmd}"
            exec cmd, (err, stdout, stderr) ->
                if err
                    fs.unlink 'lib/tmp.coffee', (err) ->
                    justchanged = appFiles.join " " unless justchanged
                    util.log "Error compiling coffee file. Last changed: #{justchanged}"
                    exec "coffee --compile #{justchanged}", (err, stdout, stderr) ->
                        util.error stderr
                        fs.unlink file.replace /.coffee$/, ".js" for file in appFiles
                        exec
                else
                    util.log "compile ok"
                    exec "mv lib/tmp.js #{target}", (err, stdout, stderr) ->
                        fs.unlink 'lib/tmp.coffee', (err) ->
                            if err
                                util.log 'Couldn\'t delete the lib/tmp.coffee file/'
                            util.log 'Done building coffee file.'
                        invoke 'doc'
task 'widgetwatch', 'Watch and compile widgets', ->
  console.info "coffee -wc #{widgets.join ' '}"
  spawn = require('child_process').spawn
  params = widgets.slice 0
  params.unshift '-wc'
  p = spawn "coffee", params
  p.stdout.on 'data', (data) ->
    console.log "" + data
  p.stderr.on 'data', (data) ->
    console.log "" + data


task 'doc', 'Build documentation', ->
    exec "docco-husky #{appFiles.join ' '}", (err, stdout, stderr) ->
        util.error strerr if stderr
        console.log stdout if stdout
grrrr = (message = '') -> 
    util.error message
