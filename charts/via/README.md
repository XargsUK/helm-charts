# VIA Helm Chart

VIA is a powerful, open-source web-based interface for configuring your QMK-powered mechanical keyboard. This Helm chart deploys VIA as a web application in your Kubernetes cluster.

## Prerequisites

- Kubernetes 1.16+
- Helm 3.0+
- Docker (for building the custom VIA image)

## Docker Image

Since VIA doesn't have an official Docker image, you'll need to build and push your own image before deploying the chart.

### Building the VIA Image

1. **Clone this repository and navigate to the chart directory:**
   ```bash
   git clone <your-repo-url>
   cd helm-charts/charts/via
   ```

2. **Build the Docker image:**
   ```bash
   docker build -t your-registry/via:latest .
   ```

3. **Push the image to your registry:**
   ```bash
   docker push your-registry/via:latest
   ```

   > **Note:** Replace `your-registry` with your actual Docker registry (e.g., `docker.io/username`, `gcr.io/project-id`, etc.)

### What the Image Contains

The Docker image:
- ✅ Builds VIA from the latest source code from [the-via/app](https://github.com/the-via/app)
- ✅ Serves the static application using nginx on port 8080
- ✅ Includes security headers and optimized caching
- ✅ Runs as non-root user for security
- ✅ Includes health checks

## Installation

### Quick Start

1. **Add the Helm repository:**
   ```bash
   helm repo add <repo-name> https://xargsuk.github.io/helm-charts
   helm repo update
   ```

2. **Update the image repository in values:**
   ```bash
   helm install my-via <repo-name>/via \
     --set image.repository=your-registry/via \
     --set image.tag=latest
   ```

### Custom Values

Create a `values.yaml` file to customize your deployment:

```yaml
# values.yaml
image:
  repository: your-registry/via
  tag: latest

ingress:
  enabled: true
  hosts:
    - host: via.yourdomain.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: via-tls
      hosts:
        - via.yourdomain.com

resources:
  limits:
    cpu: 200m
    memory: 256Mi
  requests:
    cpu: 100m
    memory: 128Mi
```

Install with custom values:
```bash
helm install my-via <repo-name>/via -f values.yaml
```

## Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `image.repository` | VIA image repository | `your-registry/via` |
| `image.tag` | VIA image tag | `latest` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `replicaCount` | Number of replicas | `1` |
| `service.type` | Kubernetes service type | `ClusterIP` |
| `service.port` | Service port | `80` |
| `ingress.enabled` | Enable ingress controller resource | `false` |
| `ingress.hosts` | Ingress hosts configuration | `[via.local]` |
| `resources` | CPU/Memory resource requests/limits | See values.yaml |
| `autoscaling.enabled` | Enable horizontal pod autoscaler | `false` |
| `autoscaling.minReplicas` | Minimum number of replicas | `1` |
| `autoscaling.maxReplicas` | Maximum number of replicas | `5` |

## Usage

### Accessing VIA

After installation, you can access VIA using one of these methods:

#### 1. Port Forward (for testing)
```bash
kubectl port-forward service/my-via 8080:80
```
Then open http://localhost:8080

#### 2. Ingress (recommended for production)
Configure the ingress in your values.yaml and access via your domain.

#### 3. LoadBalancer/NodePort
Set `service.type` to `LoadBalancer` or `NodePort` in your values.

### Using VIA

1. **Connect your keyboard:** Plug in your QMK-compatible keyboard via USB
2. **Authorize device:** Click "Authorize device +" and select your keyboard
3. **Configure:** Use the interface to customize keymaps, create macros, and adjust RGB settings
4. **Real-time updates:** Changes are applied immediately without flashing firmware

## Keyboard Compatibility

VIA supports 1400+ keyboards. Check the [supported keyboards list](https://github.com/the-via/keyboards) to see if your keyboard is compatible.

## Security

The chart includes several security best practices:
- Non-root container execution
- Security headers in nginx configuration
- Minimal container privileges
- Read-only root filesystem where possible

## Troubleshooting

### Common Issues

1. **Keyboard not detected:**
   - Ensure your keyboard has VIA-compatible firmware
   - Try different USB ports
   - Check if your browser supports WebHID (Chrome-based browsers only)

2. **Image pull errors:**
   - Verify you've built and pushed the image to your registry
   - Check image repository and tag in values.yaml
   - Ensure Kubernetes can access your registry

3. **Pod not starting:**
   - Check pod logs: `kubectl logs deployment/my-via`
   - Verify resource limits are appropriate
   - Check security context settings

### Getting Help

- [VIA Documentation](https://github.com/the-via/app)
- [QMK Firmware](https://qmk.fm/)
- [VIA Discord](https://discord.gg/via)

## Development

### Building from Source

The Dockerfile automatically clones and builds the latest VIA source code. To build from a specific version or fork:

1. Modify the Dockerfile to use a specific git tag or branch:
   ```dockerfile
   RUN git clone --branch v1.3.1 https://github.com/the-via/app.git .
   ```

2. Rebuild and push the image.

### Customizing nginx Configuration

The nginx configuration is optimized for VIA but can be customized by modifying `nginx.conf` before building the image.

## License

This chart is released under the same license as VIA (GPL-3.0). See the [LICENSE](https://github.com/the-via/app/blob/main/LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.