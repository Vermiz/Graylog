# Message Trace from M365 to Graylog
I created simple script to download Message Trace from Microsoft 365 and upload data to Graylog using nxlog app. <br>
Now, we can store and search message trace logs older than 90 days. 
  
## Instruction  
1. If you using linux you need install powershell. 
2. Copy **MessageTraceM365.ps1** to your server (example: */srv/script/*). 
3. Setup **MessageTraceM365.ps1**
- "USER" like user@example.com
- "CREDENTIAL FILE LOCATION"
4. Configure crontab like: *0 0 * * * root /srv/script/MessageTraceM365.ps1*
5. Create directory *"/srv/log/messagetrace/Graylog/"*
6. Configure nxlog like in file **nxlog.conf**. Just add your graylog server IP address in line 19 (*ip_graylog*)
7. On Graylog you only need setup GELF INPUT like this:<br>
*bind_address:localhost<br>
decompress_size_limit:8388608<br>
max_message_size: 2097152<br>
number_worker_threads: 8<br>
override_source: MessageTrace<br>
port: 12200<br>
recv_buffer_size: 1048576*
