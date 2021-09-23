[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

![](https://img.shields.io/endpoint?url=https://coverage-json.herokuapp.com/coverage/aladac/coverage-json.json)

# coverage-json

**DISCLAIMER:** This is a very WIP POC written white intoxicated. Might make it better might forget about it. Use at your discretion.

# Primer
Lightweight app to handle coverage display using https://shields.io endpoint to generate coverage badge

# Usage
- Deploy the app to heroku
- Set the `SECRET_KEY`
- `aaa` and `bbb` are keys (can be user/repo but can be anyt URL valid string)
- Call using any HTTP client like this from wherever (GH Actions, any CI)

```shell
$ curl -X POST --data @coverage.json https://your-app-name.herokuapp.com/coverage/aaa/bbb?key=YOUR_SECRET_KEY  -H "Content-type: application/json"
```

# JSON
The `coverage.json` is expected to be in format as generate by the https://github.com/vicentllongo/simplecov-json gem.
Only one value is gotten from the `coverage.json` which is the total coverage

# Badge
Go to https://shields.io/endpoint and create you badge. The URL should look like this:

```
https://img.shields.io/endpoint?url=https://coverage-json.herokuapp.com/coverage/aladac/coverage-json.json
```
