# Your Spotify Helm Chart

A Helm chart for deploying [Your Spotify](https://github.com/Yooooomi/your_spotify) - a self-hosted application that tracks what you listen and offers you a dashboard to explore statistics about your Spotify usage.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+
- A Spotify Developer Application (see [Creating a Spotify Application](#creating-a-spotify-application))

## Installation

### Add the Helm repository (if published)

```bash
helm repo add xargsuk https://xargsuk.github.io/helm-charts
helm repo update
```

### Install the chart

```bash
helm install my-spotify xargsuk/your-spotify \
  --set secrets.spotifyPublic="your_spotify_client_id" \
  --set secrets.spotifySecret="your_spotify_secret" \
  --set config.apiEndpoint="https://your-domain.com/api" \
  --set config.clientEndpoint="https://your-domain.com"
```

Or create a `values.yaml` file:

```yaml
config:
  apiEndpoint: "https://your-domain.com/api"
  clientEndpoint: "https://your-domain.com"

secrets:
  spotifyPublic: "your_spotify_client_id"
  spotifySecret: "your_spotify_secret"

server:
  ingress:
    enabled: true
    className: "nginx"
    hosts:
      - host: your-domain.com
        paths:
          - path: /api
            pathType: Prefix
    tls:
      - secretName: your-spotify-api-tls
        hosts:
          - your-domain.com

client:
  ingress:
    enabled: true
    className: "nginx"
    hosts:
      - host: your-domain.com
        paths:
          - path: /
            pathType: Prefix
    tls:
      - secretName: your-spotify-tls
        hosts:
          - your-domain.com
```

Then install:

```bash
helm install my-spotify xargsuk/your-spotify -f values.yaml
```

## Creating a Spotify Application

1. Go to the [Spotify Developer Dashboard](https://developer.spotify.com/dashboard/applications)
2. Click **Create app**
3. Fill in the application details:
   - App name: Your Spotify
   - App description: Self-hosted Spotify statistics
   - Website: Your domain
   - Redirect URI: `http://your-domain.com/api/oauth/spotify/callback` (must match your `config.apiEndpoint` + `/oauth/spotify/callback`)
4. Check **Web API**
5. Accept the terms and click **Save**
6. Click **Settings** at the top right
7. Copy the **Client ID** and **Client Secret** - you'll need these for the Helm chart installation

### Registering Users

By default, Spotify requires you to register users who can access your application:

1. Click **User Management** in your Spotify app dashboard
2. Enter the user's name and the email associated with their Spotify account
3. (Optional) Click **Request Extension** if you don't want to manually register users

Note: The account that created the application doesn't need to be registered.

## Configuration

### Core Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `config.apiEndpoint` | API server endpoint (must be in Spotify redirect URIs) | `http://localhost:8080` |
| `config.clientEndpoint` | Web client endpoint | `http://localhost:3000` |
| `config.timezone` | Timezone for statistics | `Europe/Paris` |
| `config.logLevel` | Log level (debug, info, warn, error) | `info` |
| `config.cookieValidityMs` | Cookie validity duration | `1h` |

### Secrets

| Parameter | Description | Default |
|-----------|-------------|---------|
| `secrets.spotifyPublic` | Spotify Client ID | `""` |
| `secrets.spotifySecret` | Spotify Client Secret | `""` |
| `secrets.existingSecret` | Name of existing secret | `""` |

**Important:** For production, use Kubernetes secrets or a secret management solution (Sealed Secrets, External Secrets, etc.)

Example with existing secret:

```bash
kubectl create secret generic spotify-credentials \
  --from-literal=SPOTIFY_PUBLIC=your_client_id \
  --from-literal=SPOTIFY_SECRET=your_client_secret
```

Then reference it:

```yaml
secrets:
  existingSecret: "spotify-credentials"
```

### Server Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `server.replicaCount` | Number of server replicas | `1` |
| `server.image.repository` | Server image repository | `yooooomi/your_spotify_server` |
| `server.image.tag` | Server image tag | `latest` |
| `server.service.type` | Server service type | `ClusterIP` |
| `server.service.port` | Server service port | `8080` |
| `server.ingress.enabled` | Enable server ingress | `false` |
| `server.resources.limits.cpu` | CPU limit | `500m` |
| `server.resources.limits.memory` | Memory limit | `512Mi` |

### Client Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `client.replicaCount` | Number of client replicas | `1` |
| `client.image.repository` | Client image repository | `yooooomi/your_spotify_client` |
| `client.image.tag` | Client image tag | `latest` |
| `client.service.type` | Client service type | `ClusterIP` |
| `client.service.port` | Client service port | `3000` |
| `client.ingress.enabled` | Enable client ingress | `false` |
| `client.resources.limits.cpu` | CPU limit | `500m` |
| `client.resources.limits.memory` | Memory limit | `512Mi` |

### MongoDB Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `mongodb.enabled` | Deploy MongoDB as part of the chart | `true` |
| `mongodb.persistence.enabled` | Enable persistence | `true` |
| `mongodb.persistence.size` | Storage size | `8Gi` |
| `mongodb.resources.limits.cpu` | CPU limit | `1000m` |
| `mongodb.resources.limits.memory` | Memory limit | `1Gi` |

To use an external MongoDB:

```yaml
mongodb:
  enabled: false

config:
  mongoEndpoint: "mongodb://external-mongo:27017/your_spotify"
```

## Importing Historical Data

Your Spotify can import your historical listening data from Spotify:

### Option 1: Account Data (Last Year)

1. Request your data: https://www.spotify.com/account/privacy/
2. Select "Account data"
3. Wait up to 5 days
4. Once received, log into Your Spotify
5. Go to Settings → Choose "Account data" method
6. Upload your `StreamingHistoryX.json` files

### Option 2: Extended Streaming History (Full History)

1. Request your data: https://www.spotify.com/account/privacy/
2. Select "Extended streaming history"
3. Wait up to 30 days
4. Once received, log into Your Spotify
5. Go to Settings → Choose "Extended streaming history" method
6. Upload your `endsongX.json` files

## Examples

### Basic Installation

```bash
helm install my-spotify ./your-spotify \
  --set secrets.spotifyPublic="abc123" \
  --set secrets.spotifySecret="xyz789" \
  --set config.apiEndpoint="http://192.168.1.100:8080" \
  --set config.clientEndpoint="http://192.168.1.100:3000"
```

### With Ingress and TLS

```yaml
config:
  apiEndpoint: "https://spotify.example.com/api"
  clientEndpoint: "https://spotify.example.com"

server:
  ingress:
    enabled: true
    className: "nginx"
    annotations:
      cert-manager.io/cluster-issuer: "letsencrypt-prod"
    hosts:
      - host: spotify.example.com
        paths:
          - path: /api
            pathType: Prefix
    tls:
      - secretName: spotify-api-tls
        hosts:
          - spotify.example.com

client:
  ingress:
    enabled: true
    className: "nginx"
    annotations:
      cert-manager.io/cluster-issuer: "letsencrypt-prod"
    hosts:
      - host: spotify.example.com
        paths:
          - path: /
            pathType: Prefix
    tls:
      - secretName: spotify-tls
        hosts:
          - spotify.example.com
```

### With External MongoDB

```yaml
mongodb:
  enabled: false

config:
  mongoEndpoint: "mongodb://mongo.database.svc.cluster.local:27017/your_spotify"
```

### Production Setup with Resource Limits

```yaml
server:
  replicaCount: 2
  resources:
    limits:
      cpu: 1000m
      memory: 1Gi
    requests:
      cpu: 500m
      memory: 512Mi

client:
  replicaCount: 2
  resources:
    limits:
      cpu: 500m
      memory: 512Mi
    requests:
      cpu: 250m
      memory: 256Mi

mongodb:
  persistence:
    size: 20Gi
  resources:
    limits:
      cpu: 2000m
      memory: 2Gi
    requests:
      cpu: 500m
      memory: 1Gi
```

## Troubleshooting

### Songs not synchronizing

This can happen if you revoked access on your Spotify account:
1. Go to Settings in the web interface
2. Click "Relog to Spotify"

### Cannot retrieve global preferences

The web application can't connect to the backend. Verify:
- `config.apiEndpoint` is reachable from your browser
- Server pod is running: `kubectl get pods -l app.kubernetes.io/component=server`
- Check server logs: `kubectl logs -l app.kubernetes.io/component=server`

### Import failed

Imports can fail if:
- The server reboots during import
- A request fails 10 times in a row

Retry the import from the Settings page.

## Uninstallation

```bash
helm uninstall my-spotify
```

To also remove the PVCs:

```bash
kubectl delete pvc -l app.kubernetes.io/instance=my-spotify
```

## Links

- [Your Spotify GitHub](https://github.com/Yooooomi/your_spotify)
- [Spotify Developer Dashboard](https://developer.spotify.com/dashboard/applications)
- [Request Privacy Data](https://www.spotify.com/account/privacy/)

## License

This Helm chart is provided as-is. Your Spotify is licensed under GPL-3.0.
