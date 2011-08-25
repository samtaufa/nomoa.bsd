# derived from the horde/scripts/database/mysql_create.sql
#
# Update File for your USERNAME, dbNAME, myPassword.
# Command-line use: Direct this file to mysql at STDIN:
#
#         mysql --user username --password --host host < mysql.user.db.sql
#
#  . username will need to have privileges to create a database and change mysql
#  . root access is the simplest if you run your own server, otherwise you can modify
#  . this script as you need and ask the ISP/Site Manager to configure your database
#  . for you.
#============================================================================
# Values you WANT TO CHANGE
#
# USERNAME  -to- the username you wish to use        (occurs TWICE)
# dbNAME  -to- the database name you wish to use.  (occurs TWICE)
# NOpassword -to- the Password you wish to encrypt    (occurs ONCE)
#============================================================================
CONNECT mysql;

INSERT INTO user ( host, user, password )
   VALUES (
      'localhost',
      'USERNAME',
      password('NOpassword')
   );

INSERT INTO db (
      host, db, user,
         Select_priv, Insert_priv, Update_priv, Delete_priv,
         Create_priv, Drop_priv, Index_priv, Alter_priv, 
         Execute_priv, Event_priv )
      VALUES (
      'localhost',
      'dbNAME',
      'USERNAME',
      'Y', 'Y', 'Y', 'Y',
      'Y', 'Y', 'Y', 'Y',
      'Y', 'Y'
        );

CREATE DATABASE dbNAME;

FLUSH PRIVILEGES;

# done!

