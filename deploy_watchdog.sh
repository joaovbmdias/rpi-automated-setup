#!/bin/bash

# Create Watchdog Process that will keep RPi alive 24/7 even in casa of catastrophic failure
# except power outage (no Power no Pi)

echo Creating watchdog executable file

cat > /etc/.watchdog.sh << EOF
#!/bin/bash
echo " Starting user level protection"
while :
   do
      sudo sh -c "echo '.' >> /dev/watchdog"
      sleep 14
   done
EOF

chmod +x /etc/.watchdog.sh
echo SUCCESS!

echo Add watchdog to cron
cat > create_cron.txt << EOF
@reboot /etc/.watchdog.sh
EOF

crontab -l | cat - create_cron.txt >crontab.txt && crontab crontab.txt

rm create_cron.txt
rm crontab.txt
echo SUCCESS!