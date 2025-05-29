# monitor_test
## Шаги установки
### 1. Сохраните скрипт в /usr/local/bin/monitor.sh

### 2. Сделайте скрипт исполняемым:

    chmod +x /usr/local/bin/monitor_test.sh

### 3. Создайте файл и установите права:

    touch /var/log/monitoring.log
    chmod 644 /var/log/monitoring.log

### 4. Сохраните systemd юнит в /etc/systemd/system/monitor.service

### 5. Включите и запустите сервис:
    systemctl daemon-reload
    systemctl enable monitor.service
    systemctl start monitor.service
