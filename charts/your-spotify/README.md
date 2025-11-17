# your-spotify

![Version: 1.4.4](https://img.shields.io/badge/Version-1.4.4-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.19.1](https://img.shields.io/badge/AppVersion-1.19.1-informational?style=flat-square)

A self-hosted application that tracks what you listen and offers you a dashboard to explore statistics about your Spotify usage

**Homepage:** <https://github.com/xargsuk/your_spotify>

## Source Code

* <https://github.com/xargsuk/your_spotify>
* <https://github.com/Yooooomi/your_spotify>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| client.affinity | object | `{}` |  |
| client.args | list | `[]` |  |
| client.command | list | `[]` |  |
| client.image.pullPolicy | string | `"IfNotPresent"` |  |
| client.image.repository | string | `"ghcr.io/xargsuk/your_spotify_client"` |  |
| client.ingress.annotations | object | `{}` |  |
| client.ingress.className | string | `""` |  |
| client.ingress.enabled | bool | `false` |  |
| client.ingress.hosts[0].host | string | `"your-spotify.local"` |  |
| client.ingress.hosts[0].paths[0].path | string | `"/"` |  |
| client.ingress.hosts[0].paths[0].pathType | string | `"Prefix"` |  |
| client.ingress.tls | list | `[]` |  |
| client.livenessProbe.failureThreshold | int | `3` |  |
| client.livenessProbe.httpGet.path | string | `"/"` |  |
| client.livenessProbe.httpGet.port | string | `"http"` |  |
| client.livenessProbe.initialDelaySeconds | int | `30` |  |
| client.livenessProbe.periodSeconds | int | `30` |  |
| client.livenessProbe.timeoutSeconds | int | `10` |  |
| client.nodeSelector | object | `{}` |  |
| client.readinessProbe.failureThreshold | int | `3` |  |
| client.readinessProbe.httpGet.path | string | `"/"` |  |
| client.readinessProbe.httpGet.port | string | `"http"` |  |
| client.readinessProbe.initialDelaySeconds | int | `10` |  |
| client.readinessProbe.periodSeconds | int | `10` |  |
| client.readinessProbe.timeoutSeconds | int | `5` |  |
| client.replicaCount | int | `1` |  |
| client.resources.limits.cpu | string | `"500m"` |  |
| client.resources.limits.memory | string | `"512Mi"` |  |
| client.resources.requests.cpu | string | `"100m"` |  |
| client.resources.requests.memory | string | `"256Mi"` |  |
| client.service.port | int | `3000` |  |
| client.service.type | string | `"ClusterIP"` |  |
| client.tolerations | list | `[]` |  |
| config.activeTracking.activePollIntervalMs | int | `5000` |  |
| config.activeTracking.enabled | bool | `true` |  |
| config.activeTracking.idlePollIntervalMs | int | `60000` |  |
| config.activeTracking.minListenDurationMs | int | `5000` |  |
| config.activeTracking.sleepPollIntervalMs | int | `60000` |  |
| config.aggregates.enabled | bool | `false` |  |
| config.aggregates.schedulerEnabled | bool | `true` |  |
| config.apiEndpoint | string | `"http://localhost:8080"` |  |
| config.clientEndpoint | string | `"http://localhost:3000"` |  |
| config.cookieValidityMs | string | `"1h"` |  |
| config.cors | string | `""` |  |
| config.frameAncestors | string | `""` |  |
| config.logLevel | string | `"info"` |  |
| config.maxImportCacheSize | string | `""` |  |
| config.mongoEndpoint | string | `"mongodb://{{ include \"your-spotify.fullname\" . }}-mongodb:27017/your_spotify"` |  |
| config.mongoNoAdminRights | bool | `false` |  |
| config.prometheus.enabled | bool | `false` |  |
| config.prometheus.password | string | `""` |  |
| config.prometheus.username | string | `""` |  |
| config.timezone | string | `"Europe/Paris"` |  |
| fullnameOverride | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| mongodb.affinity | object | `{}` |  |
| mongodb.auth.enabled | bool | `false` |  |
| mongodb.auth.rootPassword | string | `""` |  |
| mongodb.auth.rootUsername | string | `""` |  |
| mongodb.enabled | bool | `true` |  |
| mongodb.image.pullPolicy | string | `"IfNotPresent"` |  |
| mongodb.image.repository | string | `"mongo"` |  |
| mongodb.image.tag | string | `"6"` |  |
| mongodb.nodeSelector | object | `{}` |  |
| mongodb.persistence.accessMode | string | `"ReadWriteOnce"` |  |
| mongodb.persistence.enabled | bool | `true` |  |
| mongodb.persistence.size | string | `"10Gi"` |  |
| mongodb.persistence.storageClass | string | `""` |  |
| mongodb.resources.limits.cpu | string | `"1000m"` |  |
| mongodb.resources.limits.memory | string | `"1Gi"` |  |
| mongodb.resources.requests.cpu | string | `"250m"` |  |
| mongodb.resources.requests.memory | string | `"512Mi"` |  |
| mongodb.service.port | int | `27017` |  |
| mongodb.service.type | string | `"ClusterIP"` |  |
| mongodb.tolerations | list | `[]` |  |
| nameOverride | string | `""` |  |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| podSecurityContext.fsGroup | int | `2000` |  |
| secrets.existingSecret | string | `""` |  |
| secrets.existingSecretKeys.keycloakClientId | string | `"KEYCLOAK_CLIENT_ID"` |  |
| secrets.existingSecretKeys.keycloakClientSecret | string | `"KEYCLOAK_CLIENT_SECRET"` |  |
| secrets.existingSecretKeys.keycloakRealm | string | `"KEYCLOAK_REALM"` |  |
| secrets.existingSecretKeys.keycloakUrl | string | `"KEYCLOAK_URL"` |  |
| secrets.existingSecretKeys.spotifyPublic | string | `"SPOTIFY_PUBLIC"` |  |
| secrets.existingSecretKeys.spotifySecret | string | `"SPOTIFY_SECRET"` |  |
| secrets.keycloakClientId | string | `""` |  |
| secrets.keycloakClientSecret | string | `""` |  |
| secrets.keycloakRealm | string | `""` |  |
| secrets.keycloakUrl | string | `""` |  |
| secrets.spotifyPublic | string | `""` |  |
| secrets.spotifySecret | string | `""` |  |
| securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| securityContext.readOnlyRootFilesystem | bool | `false` |  |
| securityContext.runAsNonRoot | bool | `true` |  |
| securityContext.runAsUser | int | `1000` |  |
| server.affinity | object | `{}` |  |
| server.image.pullPolicy | string | `"IfNotPresent"` |  |
| server.image.repository | string | `"ghcr.io/xargsuk/your_spotify_server"` |  |
| server.ingress.annotations | object | `{}` |  |
| server.ingress.className | string | `""` |  |
| server.ingress.enabled | bool | `false` |  |
| server.ingress.hosts[0].host | string | `"your-spotify-api.local"` |  |
| server.ingress.hosts[0].paths[0].path | string | `"/"` |  |
| server.ingress.hosts[0].paths[0].pathType | string | `"Prefix"` |  |
| server.ingress.tls | list | `[]` |  |
| server.livenessProbe.failureThreshold | int | `3` |  |
| server.livenessProbe.httpGet.path | string | `"/"` |  |
| server.livenessProbe.httpGet.port | string | `"http"` |  |
| server.livenessProbe.initialDelaySeconds | int | `30` |  |
| server.livenessProbe.periodSeconds | int | `30` |  |
| server.livenessProbe.timeoutSeconds | int | `10` |  |
| server.nodeSelector | object | `{}` |  |
| server.readinessProbe.failureThreshold | int | `3` |  |
| server.readinessProbe.httpGet.path | string | `"/"` |  |
| server.readinessProbe.httpGet.port | string | `"http"` |  |
| server.readinessProbe.initialDelaySeconds | int | `10` |  |
| server.readinessProbe.periodSeconds | int | `10` |  |
| server.readinessProbe.timeoutSeconds | int | `5` |  |
| server.replicaCount | int | `1` |  |
| server.resources.limits.cpu | string | `"1000m"` |  |
| server.resources.limits.memory | string | `"1Gi"` |  |
| server.resources.requests.cpu | string | `"200m"` |  |
| server.resources.requests.memory | string | `"512Mi"` |  |
| server.service.port | int | `8080` |  |
| server.service.type | string | `"ClusterIP"` |  |
| server.tolerations | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
