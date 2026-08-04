# customer-app-gitops

Repositorio GitOps para el despliegue de customer-app en OpenShift mediante Argo CD.

## Estructura

```
customer-app-gitops/
├── helm/
│   └── customer-app/         # Helm chart de la aplicación
│       ├── Chart.yaml
│       ├── values.yaml       # image.tag es actualizado por Tekton en cada build
│       └── templates/
│           ├── _helpers.tpl
│           ├── deployment.yaml
│           ├── service.yaml
│           └── route.yaml
└── argocd/
    └── application.yaml      # CR Application de Argo CD
```

- **`helm/`** — Helm chart completo de `customer-app`. Argo CD lo usa como fuente de verdad para renderizar y aplicar los manifiestos en OpenShift.
- **`argocd/`** — CR `Application` de Argo CD que apunta a este repositorio. Se aplica una única vez al cluster para registrar la aplicación.

## Flujo GitOps

```
Developer → git push → [customer-app]
                              ↓
                       Tekton Pipeline
                       (build + push imagen al registro interno)
                              ↓
                    actualiza image.tag en values.yaml
                              ↓
                    git push → [customer-app-gitops]  ← este repo
                              ↓
                    Argo CD detecta el cambio (polling cada 3 min
                    o inmediatamente vía webhook)
                              ↓
                    Argo CD aplica el Helm chart actualizado
                              ↓
                    OpenShift namespace customer-app
```

Argo CD monitorea la rama `main` de este repositorio. Cuando Tekton actualiza el campo `image.tag` en [`helm/customer-app/values.yaml`](helm/customer-app/values.yaml) y hace push, Argo CD detecta la diferencia y redespliega el `Deployment` con la nueva imagen automáticamente (`syncPolicy.automated`).

## Configuración

Antes de aplicar [`argocd/application.yaml`](argocd/application.yaml) al cluster, reemplaza el placeholder `TU_USUARIO` con tu usuario real de GitHub:

```bash
# Reemplazar en el archivo
sed -i 's/TU_USUARIO/<tu-usuario-github>/g' argocd/application.yaml

# Aplicar al cluster
oc apply -f argocd/application.yaml -n argocd
```

La URL final debe apuntar al repositorio público `customer-app-gitops` en tu cuenta de GitHub, por ejemplo:

```
https://github.com/mi-usuario/customer-app-gitops.git
```
