# MYSQL Master and Slave Database Server Setup and Replication




* Create Docker Network using the following Command
```
docker network create groupnet
```

* Pull mysql docker image
```
docker pull mysql
```

* Create master database server using the following command.
  * Things to note in the following command  :-
    * We are using **groupnet** network group for our docker container.
    * Creating a shared folder **mysql-server-master-share** between docker image and host OS
    * Server ID = 1

```
docker run -p 3306:3306 -p 33060:33060 --name mysql-server-master --net=groupnet  --hostname=mysql-server-master -v $PWD/mysql-server-master-share:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=Password -d mysql --bind-address=172.18.0.2 --server-id=1
```


* Create slave database server using the following command.
  * Things to note in the following command  :-
    * Creating a shared folder **mysql-server-slave-share** between docker image and host OS
    * Server ID = 2
    * Mapping port to **3307**, **33061** to avoid port conflicts with master server in host system

```
docker run -p 3307:3306 -p 33061:33060 --name mysql-server-slave --net=groupnet  --hostname=mysql-server-slave -v $PWD/mysql-server-slave-share:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=Password -d mysql --bind-address=172.18.0.3 --server-id=2
```

* Follow the video for setting up the master, slave replication
```
https://www.youtube.com/watch?v=HPJYY6FlUGU
```


* Run the following SQL commands in Master Database Server ( You can use SQLWorkbench to connect to database and execute the following commands)
```
CREATE USER 'replica'@'172.18.0.2' IDENTIFIED BY 'abc@123';
```
```
GRANT REPLICATION SLAVE ON *.* TO 'replica'@'172.18.0.2';
```
```
GRANT USAGE ON *.* TO 'replica'@'172.18.0.2';
```
```
CREATE USER 'replica'@'172.18.0.3' IDENTIFIED BY 'abc@123';
```
```
GRANT REPLICATION SLAVE ON *.* TO 'replica'@'172.18.0.3';
```
```
GRANT USAGE ON *.* TO 'replica'@'172.18.0.3';
```
Save the output of the following command  - bin file name(ex: binlog.000003) and read index(ex:- 1084)
```
SHOW MASTER STATUS
```
```
flush privileges;
```


* Execute the following from command prompt of host system
```
docker exec mysql-server-master sh -c 'exec mysqldump --all-databases --master-data -uroot -p"Password"' > /Users/pkommera/mysql-server-slave-share/db_dump.sql
```
* Open terminal for slave using Docker app
```
docker exec -it mysql-server-slave bash -l
```
```
cd /var/lib/mysql
```
```
mysql -u root -p </var/lib/mysql/db_dump.sql
```


* Login to Slave Database and run the following commands ( You can use SQLWorkbench to connect to database)
```
stop slave;
```
```
CHANGE MASTER TO
       MASTER_HOST='172.18.0.2'
      ,MASTER_USER='replica'
      ,MASTER_PASSWORD='abc@123'
      ,MASTER_LOG_FILE='binlog.000003'
      ,MASTER_LOG_POS=1084;
```
```
CHANGE MASTER TO GET_MASTER_PUBLIC_KEY=1;
```
```
start slave;
```
* If the replication is successful, you would see successful synchronization status in the record
```
SHOW slave status;
```

### References

https://www.youtube.com/watch?v=HPJYY6FlUGU

### License

UNLICENSED
