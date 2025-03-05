# Actividad Terraform - Azure – Lens

## Plataformas II
**Juan Yustes A00380718**

---

### Instalación y configuración

1. **Instalación de Azure y Terraform en WSL:**
   - Instalamos Azure CLI y Terraform dentro del entorno de Windows Subsystem for Linux (WSL).

2. **Autenticación en Azure:**
   - Iniciamos sesión con las credenciales estudiantiles.

3. **Configuración de la cuenta predeterminada:**
   - Establecemos la cuenta asociada de Azure como predeterminada.

4. **Creación del entorno Terraform:**
   - Creamos una carpeta para el proyecto Terraform.

---

### Configuración del archivo main.tf

- Dentro de la carpeta Terraform, creamos el archivo `main.tf`, el cual contiene la configuración necesaria para desplegar la infraestructura en Azure.
- Se define un clúster llamado **"yustes-aks1"** y un recurso **"lab_plataformas_rg"**.

```hcl
# Ejemplo básico de main.tf
resource "azurerm_resource_group" "lab_plataformas_rg" {
  name     = "lab_plataformas_rg"
  location = "East US"
}

resource "azurerm_kubernetes_cluster" "yustes-aks1" {
  name                = "yustes-aks1"
  location            = azurerm_resource_group.lab_plataformas_rg.location
  resource_group_name = azurerm_resource_group.lab_plataformas_rg.name
  dns_prefix          = "yustesaks"
}
```

- Damos formato con el comando:

```bash
terraform fmt
```

- Inicializamos Terraform:

```bash
terraform init
```

- Verificamos el plan:

```bash
terraform plan
```

- Si hay errores, como la falta de suscripción, los corregimos antes de continuar.

- Aplicamos los cambios:

```bash
terraform apply
```

---

### Validación del clúster

1. **Conexión al clúster:**
   - Una vez creado el recurso en Azure, accedemos al clúster para validarlo.

2. **Conexión desde WSL:**

```bash
az aks get-credentials --resource-group lab_plataformas_rg --name yustes-aks1
```

3. **Cambio de contexto en kubectl:**

```bash
kubectl config use-context yustes-aks1
```

---

### Despliegue de pods y servicios

- Creamos los archivos YAML para desplegar el pod y el servicio.

**pod.yaml:**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
spec:
  containers:
  - name: nginx
    image: nginx:latest
```

**service.yaml:**

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
```

- Aplicamos los cambios:

```bash
kubectl apply -f pod.yaml
kubectl apply -f service.yaml
```

- Verificamos la IP expuesta del servicio:

```bash
kubectl get services
```

---

### Configuración de Lens

1. **Exponer el acceso al clúster desde Windows:**
   - Como estábamos conectados desde WSL, habilitamos el acceso desde Windows.

2. **Instalación de Lens:**
   - Descargamos e instalamos Lens en Windows.

3. **Agregar configuración kubeconfig:**
   - Dentro de Lens, seleccionamos "**Add kubeconfig by pasting**" y pegamos la configuración.

4. **Validar conexión:**
   - Lens se conecta automáticamente al clúster y nos permite monitorearlo.

