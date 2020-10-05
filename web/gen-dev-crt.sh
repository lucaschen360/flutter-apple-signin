PASSWORD=dev
if [ $# -ge 1 ]
  then
    PASSWORD=$1
fi

openssl req -x509 -out dev.crt -keyout dev.key -days 825 \
  -newkey rsa:2048 -nodes -sha256 \
  -subj '/CN=*.servicestack.com' -extensions EXT -config <( \
   printf "[dn]\nCN=*.servicestack.com\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:*.servicestack.com\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")

openssl pkcs12 -export -out dev.pfx -inkey dev.key -in dev.crt -password pass:$PASSWORD
