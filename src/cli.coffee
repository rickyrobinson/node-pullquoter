# We use optimist for parsing the CLI arguments
fs = require('fs')
pullquoter = require('./pullquoter')

argvParser = require('optimist')
.usage(
  'pullquoter [OPTIONS] [FILE_NAME]'
).options(
  number:
    alias: 'n'
    describe: 'How many quotes to pull (Default = 1)'
  scoreOrder:
    alias: 's'
    describe: 'Shows the quotes in score order (The default is the order they appear in the text)'
    boolean: true
  version:
    alias: 'v'
    describe: 'Show version information'
    boolean: true
  help:
    alias: 'h'
    describe: 'Show this. See: https://github.com/ageitgey/node-pullquoter'
    boolean: true
)

argv = argvParser.argv

if argv.version
  version = require('../package.json').version
  process.stdout.write "#{version}\n"
  process.exit 0

if argv.help
  argvParser.showHelp()
  process.exit 0

file = argv._.shift()
numberOfQuotes = argv.number || 1
scoreOrder = argv.scoreOrder
text = ""

if file
  text = fs.readFileSync(file).toString()
  process.stdout.write(pullquoter(text, numberOfQuotes, not scoreOrder).join("\n"))
  process.stdout.write("\n")
else
  process.stdin.setEncoding('utf8')

  process.stdin.on 'readable', () ->
    chunk = process.stdin.read()
    if (chunk != null)
      text += chunk

  process.stdin.on 'end', () ->
    process.stdout.write(pullquoter(text, numberOfQuotes, not scoreOrder).join("\n"))
    process.stdout.write("\n")
