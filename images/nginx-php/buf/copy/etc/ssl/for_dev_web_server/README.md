## Настройка SSL в PHP +Apache
https://www.php.net/manual/ru/openssl.installation.php
- Скачать и установить в PHP папку библиотеки   
`libcrypto-1_1-x64.dll` `libssl-1_1-x64.dll` Прописать пути к данным файлам в httpd.conf (Apache)      
```
LoadFile "${PHPDir}/libcrypto-1_1-x64.dll"   
LoadFile "${PHPDir}/libssl-1_1-x64.dll"
```  
- Установить системные переменные   
`OPENSSL_CONF, SSLEAY_CONF` (полный путь к файлу настроек ssl)
OpenSSL будут по ним определять где конфигурационный файл.
- установите open ssl или  git

## Создания сертификата

`openssl genrsa -out rootCA.key 2048` - генерируем приватный ключ центра сертификации  
При ошибке 

`openssl req -x509 -new -key rootCA.key -days 36500 -out rootCA.crt` - создаем  сертификат (публичный ключ) цента сертификации которым будем заверять др сертификаты  
 
 при ошибке 
 ```Can't load C:\Users\AlexeyP/.rnd into RNG
8332:error:2406F079:random number generator:RAND_load_file:Cannot open file:../openssl-1.1.1d/crypto/rand/randfile.c:98:Filename=C:\Users\AlexeyP/.rnd
```
необходимо создать файл .rnd с случайным числом  командой `openssl rand -out .rnd -hex 256` и поместить его в `C:\Users\AlexeyP` 

Сертификат `rootCA.crt` добавляем в браузер в качестве доверенного корневого центра сертификации.  
Все сертификаты подписанные им будут автоматически являться доверенными. С помощью него расшифровываются данные клиентом которые получены с сервера.  
`openssl genrsa -out general.key 2048` - создаем приватный ключ  "основной".  с помощью него дешефруются данные полученые с клиента. 
`openssl req -new -key general.key -out general.csr` - публичный сертификат (ключ) доменна для генерации сертификата в центре сертификации. с помощью него шифруются данные на клиенте.

В файл `general.ext`заносим домены/IP которые хотим использовать для сертификации.
```
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
IP.1=127.0.0.56
IP.2=127.0.0.71
IP.3=127.0.0.72
IP.4=127.0.0.73
DNS.5=localhost73
```
после центр сертификации выписывает сертификат general.crt  для доменов прописанных в general.ext. с помощью general.crt происходит шифровка данных на сервере.
`openssl x509 -req -in general.csr -CA rootCA.crt -CAkey rootCA.key -CAcreateserial -out general.crt -days 36500 -extfile general.ext` 
После необходимо перезагрузить Apache. 

## Настройка виртуального хоста Apache
в файле extra/httpd-vhosts.conf
```
<VirtualHost *:443>
	DocumentRoot "z:/path/sites" 
	ServerName site.name
	ErrorLog path/error/log
	TransferLog path/access/log
	SSLEngine on
	SSLCertificateFile "${DirSettings}/certificates/ssl/general.crt"
	SSLCertificateKeyFile "${DirSettings}/certificates/ssl/general.key"
</VirtualHost>  
	
```
см 
[https://habr.com/ru/post/192446/](https://habr.com/ru/post/192446/)
[https://habr.com/ru/post/346798/](https://habr.com/ru/post/346798/)
[https://stackoverflow.com/questions/43665243/invalid-self-signed-ssl-cert-subject-alternative-name-missing](https://stackoverflow.com/questions/43665243/invalid-self-signed-ssl-cert-subject-alternative-name-missing)
[https://www.leaderssl.ru/news/425-nachinaya-s-chrome-58-samopodpisannye-sertifikaty-bez-subjectaltname-bolshe-ne-yavlyayutsya-doverennymi](https://www.leaderssl.ru/news/425-nachinaya-s-chrome-58-samopodpisannye-sertifikaty-bez-subjectaltname-bolshe-ne-yavlyayutsya-doverennymi)
[http://qaru.site/questions/12817/getting-chrome-to-accept-self-signed-localhost-certificate](http://qaru.site/questions/12817/getting-chrome-to-accept-self-signed-localhost-certificate)



 

