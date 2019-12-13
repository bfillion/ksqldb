#!/bin/bash

cd /gen-certificats/certificats

# CA (self signed)
openssl req -new -x509 -keyout kafka-ia-ca.key -out kafka-ia-ca.crt -days 999 -subj '/CN=kafka-ia/OU=KAFKA-IA-TEST/O=IA/L=Quebec/C=CA' -passin pass:soleil1234 -passout pass:soleil1234

# truststore
keytool -keystore kafka-ia.truststore.jks -alias CARoot -import -file kafka-ia-ca.crt -storepass soleil1234 -keypass soleil1234 -trustcacerts -noprompt

# broker certificate and keystore
keytool -genkey -noprompt \
   -alias kafka-ia-broker1 \
   -dname "CN=kafka-ia-broker1, OU=KAFKA-IA-TEST, O=IA, L=Quebec, C=CA" \
   -keystore kafka-ia-broker1.keystore.jks \
   -keyalg RSA \
   -storepass soleil1234 \
   -keypass soleil1234

keytool -keystore kafka-ia-broker1.keystore.jks -alias kafka-ia-broker1  -certreq -file kafka-ia-broker1.csr -storepass soleil1234 -keypass soleil1234
openssl x509 -req -CA kafka-ia-ca.crt -CAkey kafka-ia-ca.key -in kafka-ia-broker1.csr -out kafka-ia-broker1-signed.crt -days 9999 -CAcreateserial -passin pass:soleil1234
keytool -keystore kafka-ia-broker1.keystore.jks -alias CARoot -import -file kafka-ia-ca.crt -storepass soleil1234 -keypass soleil1234 -trustcacerts -noprompt
keytool -keystore kafka-ia-broker1.keystore.jks -alias kafka-ia-broker1 -import -file kafka-ia-broker1-signed.crt -storepass soleil1234 -keypass soleil1234 -trustcacerts -noprompt

#client1 certificate and keystore
keytool -genkey -noprompt \
   -alias kafka-ia-client1 \
   -dname "CN=kafka-ia-client1, OU=KAFKA-IA-TEST, O=IA, L=Quebec, C=CA" \
   -keystore kafka-ia-client1.keystore.jks \
   -keyalg RSA \
   -storepass soleil1234 \
   -keypass soleil1234
keytool -keystore kafka-ia-client1.keystore.jks -alias kafka-ia-client1  -certreq -file kafka-ia-client1.csr -storepass soleil1234 -keypass soleil1234
openssl x509 -req -CA kafka-ia-ca.crt -CAkey kafka-ia-ca.key -in kafka-ia-client1.csr -out kafka-ia-client1-signed.crt -days 9999 -CAserial kafka-ia-ca.srl -passin pass:soleil1234
keytool -keystore kafka-ia-client1.keystore.jks -alias CARoot -import -file kafka-ia-ca.crt -storepass soleil1234 -keypass soleil1234 -trustcacerts -noprompt
keytool -keystore kafka-ia-client1.keystore.jks -alias kafka-ia-client1 -import -file kafka-ia-client1-signed.crt -storepass soleil1234 -keypass soleil1234 -trustcacerts -noprompt

#client2 certificate and keystore
keytool -genkey -noprompt \
   -alias kafka-ia-client2 \
   -dname "CN=kafka-ia-client2, OU=KAFKA-IA-TEST, O=IA, L=Quebec, C=CA" \
   -keystore kafka-ia-client2.keystore.jks \
   -keyalg RSA \
   -storepass soleil1234 \
   -keypass soleil1234
keytool -keystore kafka-ia-client2.keystore.jks -alias kafka-ia-client2  -certreq -file kafka-ia-client2.csr -storepass soleil1234 -keypass soleil1234
openssl x509 -req -CA kafka-ia-ca.crt -CAkey kafka-ia-ca.key -in kafka-ia-client2.csr -out kafka-ia-client2-signed.crt -days 9999 -CAserial kafka-ia-ca.srl -passin pass:soleil1234
keytool -keystore kafka-ia-client2.keystore.jks -alias CARoot -import -file kafka-ia-ca.crt -storepass soleil1234 -keypass soleil1234 -trustcacerts -noprompt
keytool -keystore kafka-ia-client2.keystore.jks -alias kafka-ia-client2 -import -file kafka-ia-client2-signed.crt -storepass soleil1234 -keypass soleil1234 -trustcacerts -noprompt

echo soleil1234 > kafka-ia.truststore.cred
echo soleil1234 > kafka-ia-broker1.keystore.cred
echo soleil1234 > kafka-ia.ssl.cred
