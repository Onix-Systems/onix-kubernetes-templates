# Persistent Volume


Persistent Volume - служба отвечающая за сонтирование и сохранение статических данных приложения
```
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
...
        volumeMounts:
        - name: __CI_PROJECT_NAME__
          mountPath: /var/lib/postgresql/data
      volumes:
      - name: __CI_PROJECT_NAME__
        persistentVolumeClaim:
          claimName: __NAMESPACE_NAME__-db-data-claim
...

---
kind: PersistentVolume
apiVersion: v1
metadata:
  name: __NAMESPACE_NAME__-dbdata
  labels:
    type: local
spec:
  storageClassName: local-storage
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/home/ubuntu/kuber_project_data/__NAMESPACE_NAME__"
---

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: __NAMESPACE_NAME__-db-data-claim
  namespace: __NAMESPACE_NAME__
spec:
  volumeName: __NAMESPACE_NAME__-dbdata
  storageClassName: local-storage
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
```

### Детально:

```
        volumeMounts:
        - name: __CI_PROJECT_NAME__
          mountPath: /var/lib/postgresql/data
      volumes:
      - name: __CI_PROJECT_NAME__
        persistentVolumeClaim:
          claimName: __NAMESPACE_NAME__-db-data-claim
```
Часть конфигурации отвечающая за подключение деплоймента к Persistent Volume

```
kind: PersistentVolume
apiVersion: v1
metadata:
  name: __NAMESPACE_NAME__-dbdata
  labels:
    type: local
spec:
  storageClassName: local-storage
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/home/ubuntu/kuber_project_data/__NAMESPACE_NAME__"
```
Часть конфигурации PersistentVolume отвечающая за монтирование директории на сервере

```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: __NAMESPACE_NAME__-db-data-claim
  namespace: __NAMESPACE_NAME__
spec:
  volumeName: __NAMESPACE_NAME__-dbdata
  storageClassName: local-storage
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
```
PersistentVolumeClaim отвечает за соединение части конфигурации деплоймента с PersistentVolume
