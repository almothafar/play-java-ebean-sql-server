
### This is example project to reproduce issue: [https://github.com/ebean-orm/ebean/issues/1780](https://github.com/ebean-orm/ebean/issues/1780)

To start only DB: 
```console
docker-compose up --build msdb 
```

Then connect to DB using Azure [DataGrip](https://www.jetbrains.com/datagrip/) or any client you like, credentials can be found inside `docker-compose.yml` file, and create a new Database:

```sql
create database TestDB
go

```

Then start play project, you can look below:

-----

## Play

Play documentation is here:

[https://playframework.com/documentation/latest/Home](https://playframework.com/documentation/latest/Home)

## EBean

EBean is a Java ORM library that uses SQL:

[https://www.playframework.com/documentation/latest/JavaEbean](https://www.playframework.com/documentation/latest/JavaEbean)

and the documentation can be found here:

[https://ebean-orm.github.io/](https://ebean-orm.github.io/)

