#!/bin/bash
data=`date +%Y-%m-%d`
backup_dir=~/backup
vm=`virsh list | grep . | awk '{print $2}'| sed 1,2d | tr -s '\n' ' '`
for activevm in $vm
do
mkdir -p $backup_dir/$activevm
# Бэкапим конфигурацию XML для виртуальной машины
virsh dumpxml $activevm > $backup_dir/$activevm/$activevm-$data.xml
# Адрес дисков виртуальных машин
disk_path=`virsh domblklist $activevm | grep vd | awk '{print $2}'`
# Останавливаем рабочую машин
virsh shutdown $activevm
sleep 2
for path in $disk_path
do
# Убираем имя файла из пути
filename=`basename $path`
# Создаем бэкап диска
gzip -c $path > $backup_dir/$activevm/$filename-$data.gz
sleep 2
virsh start $activevm
sleep 2
done
done
/usr/bin/find /backup/ -type f -mtime +7 -exec rm -rf {} \;
