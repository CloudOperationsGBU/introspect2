#! /bin/bash

# POST PUT_ITEM
# curl -i -X POST \
#     -H "Content-Type: application/json" \
#     -d '{"TableName":"batch8_chinmayabiswal_table_2b","Item":{"UserId":{"S":"deya"},"FirstName":{"S":"Abhishek"},"LastName":{"S":"Dey"}}}' \
#     https://8y46qbpdn8.execute-api.us-east-2.amazonaws.com/dev

# # DELETE DELETE_ITEM
curl -i -X DELETE \
    -H "Content-Type: application/json" \
    -d '{"TableName":"batch8_chinmayabiswal_table_2b","Key":{"UserId":{"S":"deya"}}}' \
    https://8y46qbpdn8.execute-api.us-east-2.amazonaws.com/dev

# # GET SCAN
# curl -i -X GET \
#     -H "Content-Type: application/json" \
#     -d '{ "key1": "1", "key2": "2" }' \
#     https://8y46qbpdn8.execute-api.us-east-2.amazonaws.com/dev?TableName=batch8_chinmayabiswal_table_2b

# # PUT UPDATE_ITEM
# curl -i -X PUT \
#     -H "Content-Type: application/json" \
#     -d '{"TableName":"batch8_chinmayabiswal_table_2b","Key":{"UserId":{"S":"deya"}},"AttributeUpdates":{"FirstName":{"Action":"PUT","Value":{"S":"Arnesh"}},"LastName":{"Action":"PUT","Value":{"S":"Dsouza"}}}}' \
#     https://8y46qbpdn8.execute-api.us-east-2.amazonaws.com/dev