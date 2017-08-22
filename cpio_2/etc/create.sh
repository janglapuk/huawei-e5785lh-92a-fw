#!/bin/sh

# Empty and create db file
rm -f index.txt
#rm -f serial.txt
#touch index.txt
#touch serial.txt
## generate a  empty file
:>index.txt
#echo '01' > serial.txt
rm -fr root/
rm -fr server/

mkdir -p root
mkdir -p server


# Create self signed CA root certificate
openssl req -x509 -batch -config openssl-ca.cnf -days 3650 -newkey rsa:2048 -sha256 -nodes -out root/root.pem -outform PEM

openssl genrsa -out server/tmpserverkey.pem 2048
openssl rsa -in server/tmpserverkey.pem -des3 -out server/serverkey.pem -passout file:key.temp
# Create server certificate request
openssl req -batch -config openssl-server.cnf -new -key server/serverkey.pem -passin file:key.temp -out server/servercert.csr -outform PEM
#openssl req  -batch -config openssl-server.cnf -newkey rsa:2048 -sha256 -nodes -out server/servercert.csr -outform PEM

# Sign the server certificate
openssl ca -batch -config openssl-ca.cnf -policy signing_policy -extensions signing_req -out server/servercert.pem -infiles server/servercert.csr

