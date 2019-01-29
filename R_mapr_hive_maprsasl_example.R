

library("rJava")
library("RJDBC")

addLib = list.files(path=c("/opt/mapr/hive/hive-2.3/jdbc/hive-jdbc-2.3.3-mapr-1808-standalone.jar","/opt/mapr/lib","/opt/mapr/hadoop/hadoop-2.7.0/share/hadoop/common/hadoop-common-2.7.0-mapr-1808.jar"),pattern="jar", full.names=T);

cp = c(addLib)
.jinit(classpath=cp)
drv <- JDBC("org.apache.hive.jdbc.HiveDriver","/opt/mapr/hive/hive-2.3/jdbc/hive-jdbc-2.3.3-mapr-1808-standalone.jar",identifier.quote="`") 
conn <- dbConnect(drv, "jdbc:hive2://localhost:10000/default;auth=maprsasl") 
db <- dbGetQuery(conn, "show tables") 
print(db) 



