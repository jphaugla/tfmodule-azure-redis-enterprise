export NODE_IP='4.157.240.150'
# get connect
curl -X GET http://$NODE_IP:8083
# get ksql
curl -X GET http://$NODE_IP:8088
echo -e "\nKafka Topics:"
curl -X GET http://$NODE_IP:8082/topics 

echo -e "\nKafka Connectors:"
curl -X GET http://$NODE_IP:8083/connectors/

