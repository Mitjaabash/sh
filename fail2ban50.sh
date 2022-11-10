
#!/bin/bash
ips=`netstat -ntu | grep -vE "(Address|servers|127.0.0.1)" \
| awk '{print $5}' | cut -d ':' -f 1 | sort -n | uniq -c \
| sort -n | awk '{if ($1 > 50 ) print $2}'`
if [[ -z $ips ]]; then
  exit 0
else
  for i in $ips
 do fail2ban-client -vvv set nginx-limit-conn banip $i
  done
fi
