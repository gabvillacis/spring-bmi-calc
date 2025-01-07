## **Deployment: Configuración de la aplicación**
### Propósito
El manifiesto de tipo `Deployment` especifica cómo se debe desplegar y gestionar la aplicación en el clúster de Kubernetes. Permite realizar actualizaciones controladas y asegura que siempre se ejecuten un número deseado de réplicas de la aplicación.

### Configuración
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: spring-bmi-calc
```
- **apiVersion**: Especifica la versión de la API que se utiliza para el recurso. En este caso, `apps/v1`.
- **kind**: Define el tipo de recurso, que en este caso es un `Deployment`.
- **metadata.name**: Es el nombre del despliegue (`spring-bmi-calc`).

---

### Configuración de réplicas y estrategia
```yaml
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
      maxSurge: 1
```
- **replicas**: Define el número de pods (réplicas) que se deben ejecutar simultáneamente. Aquí se especifican 3 réplicas.
- **strategy**: Configura la estrategia de actualización:
  - **type: RollingUpdate**: Se realiza una actualización gradual de los pods.
  - **rollingUpdate.maxUnavailable**: Máximo número de pods que pueden estar no disponibles durante la actualización (en este caso, 1).
  - **rollingUpdate.maxSurge**: Máximo número de pods adicionales que se pueden crear temporalmente durante la actualización (en este caso, 1).

---

### Selección y definición del pod
```yaml
  selector:
    matchLabels:
      app: spring-bmi-calc
```
- **selector**: Especifica cómo encontrar los pods administrados por este `Deployment` usando etiquetas. Aquí se utiliza la etiqueta `app: spring-bmi-calc`.

```yaml
  template:
    metadata:
      labels:
        app: spring-bmi-calc
```
- **template.metadata.labels**: Define la etiqueta del pod para que coincida con el selector (`app: spring-bmi-calc`).

---

### Configuración del contenedor
```yaml
    spec:
      containers:
      - name: spring-bmi-calc
        image: gabvillacis93/spring-bmi-calc:latest
        imagePullPolicy: Always
        ports:
        - containerPort: 8000
```
- **containers**: Lista de contenedores que se ejecutarán en cada pod.
  - **name**: Nombre del contenedor (`spring-bmi-calc`).
  - **image**: Imagen Docker utilizada para ejecutar el contenedor. Aquí se utiliza `gabvillacis93/spring-bmi-calc:latest`, que siempre extraerá la última versión de la imagen.
  - **imagePullPolicy**: Especifica que la imagen siempre debe ser extraída del registro (`Always`).
  - **ports.containerPort**: Define el puerto que expondrá el contenedor dentro del pod. En este caso, el puerto `8000`.

---

### Recursos asignados al contenedor
```yaml
        resources:
          requests: 
            memory: "256Mi"
            cpu: "500m"
          limits:
            memory: "512Mi"
            cpu: "1"
```
- **requests**: Indica la cantidad mínima de recursos que el contenedor necesita:
  - **memory**: 256 MiB de memoria solicitada.
  - **cpu**: 500m (0.5 CPU virtuales) solicitados.
- **limits**: Define los límites máximos que el contenedor puede usar:
  - **memory**: Hasta 512 MiB de memoria.
  - **cpu**: Hasta 1 CPU virtual.

---

## **Service: Exponer la aplicación**
### Propósito
El manifiesto de tipo `Service` define cómo acceder a los pods del `Deployment`. En este caso, se utiliza un `LoadBalancer` para exponer la aplicación externamente.

### Configuración
```yaml
apiVersion: v1
kind: Service
metadata:
  name: spring-bmi-calc-service
```
- **apiVersion**: Versión de la API para el recurso. En este caso, `v1`.
- **kind**: Define el tipo de recurso, que en este caso es un `Service`.
- **metadata.name**: Nombre del servicio (`spring-bmi-calc-service`).

---

### Selector y puertos
```yaml
spec:
  selector:
    app: spring-bmi-calc
  ports:
    - protocol: TCP
      port: 8000
      targetPort: 8000
```
- **selector**: Asocia el servicio con los pods que tienen la etiqueta `app: spring-bmi-calc`.
- **ports**:
  - **protocol**: El protocolo de red utilizado, aquí es `TCP`.
  - **port**: Puerto en el que el servicio estará disponible externamente (puerto `8000`).
  - **targetPort**: Puerto del contenedor al que se redirigirá el tráfico (puerto `8000`).

---

### Tipo de servicio
```yaml
  type: LoadBalancer
```
- **type**: Define cómo se expone el servicio. `LoadBalancer` crea automáticamente un balanceador de carga en el proveedor de nube (por ejemplo, AWS, GCP) para exponer la aplicación a Internet.

---

## Resumen
1. **Deployment**:
   - Despliega 3 réplicas de la aplicación `spring-bmi-calc`.
   - Utiliza una estrategia de actualización `RollingUpdate` para garantizar una transición suave entre versiones.
   - Asigna recursos de memoria y CPU al contenedor para garantizar estabilidad y control.

2. **Service**:
   - Expone la aplicación a través de un balanceador de carga.
   - Redirige el tráfico externo al puerto `8000` del contenedor.

Este archivo garantiza que la aplicación `spring-bmi-calc` se despliegue y se exponga correctamente, asegurando alta disponibilidad y una estrategia de actualización controlada.