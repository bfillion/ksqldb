CREATE STREAM reponse (idCorrelation VARCHAR, reponse VARCHAR, fonction VARCHAR)
    WITH (kafka_topic = 'reponse',
          partitions = 5,
          key = 'idCorrelation',
          value_format = 'avro');

CREATE SINK CONNECTOR elasticsearch_sink WITH (
  'connector.class'     = 'io.confluent.connect.elasticsearch.ElasticsearchSinkConnector',
  'key.converter'       = 'org.apache.kafka.connect.storage.StringConverter',
  'topics'              = 'reponse',
  'key.ignore'          = 'true',
  'schema.ignore'       = 'false',
  'type.name'           = 'reponses',
  'connection.url'      = 'http://elastic:9200',
  'connection.username' = 'elastic',
  'connection.password' = 'secret');



