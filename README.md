# MongodbDockerBackup
a simple bash script to backup specified or all databases from a mongodbserver 

use 
```bash 
BACKUP_ALL=true 
DATABASES_TO_EXCLUDE=("admin" "config" "local"); 
DATABASES_TO_BACKUP=(); 
``` 
to back up all databases, excluding admin, config and local 

use 
```bash 
BACKUP_ALL=false 
DATABASES_TO_EXCLUDE=("admin" "config" "local"); 
DATABASES_TO_BACKUP=("mydatabase"); 
```
to backup only the specified "mydatabase"
