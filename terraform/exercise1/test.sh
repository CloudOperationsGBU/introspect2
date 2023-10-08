#! /bin/bash

curl -i -X POST \
    -H "Content-Type: application/json" \
    -d '{ "key1": "1", "key2": "2" }' \
    https://ebio685v2b.execute-api.us-east-2.amazonaws.com/dev