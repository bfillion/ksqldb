CREATE STREAM reponse (idCorrelation VARCHAR, reponse VARCHAR, fonction VARCHAR)
    WITH (kafka_topic = 'reponse',
          partitions = 5,
          key = 'idCorrelation',
          value_format = 'avro');
