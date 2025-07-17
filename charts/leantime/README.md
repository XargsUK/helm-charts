# Leantime Helm Chart

Leantime is an open source project management system for creative teams, written in PHP with MySQL support. This Helm chart deploys Leantime as a web application in your Kubernetes cluster.

## Prerequisites

- Kubernetes 1.16+
- Helm 3.0+
- MySQL 5.7+ or 8.0+ (can be provided as a dependency or external)

## Installation

### Quick Start

1. **Add the Helm repository:**

   ```bash
   helm repo add <repo-name> https://xargsuk.github.io/helm-charts
   helm repo update
   ```

2. **Install Leantime:**
   ```bash
   helm install my-leantime <repo-name>/leantime
   ```

### Custom Values

Create a `values.yaml` file to customize your deployment:

```yaml
# values.yaml
image:
  repository: leantime/leantime
  tag: "3.1.6"

mysql:
  enabled: true
  auth:
    rootPassword: "changeme123"
    database: "leantime"
    username: "lean"
    password: "changeme123"

ingress:
  enabled: true
  hosts:
    - host: leantime.yourdomain.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: leantime-tls
      hosts:
        - leantime.yourdomain.com

persistence:
  enabled: true
  size: 10Gi

resources:
  limits:
    cpu: 500m
    memory: 512Mi
  requests:
    cpu: 250m
    memory: 256Mi
```

Install with custom values:

```bash
helm install my-leantime <repo-name>/leantime -f values.yaml
```

## Configuration

| Parameter             | Description                        | Default             |
| --------------------- | ---------------------------------- | ------------------- |
| `image.repository`    | Leantime image repository          | `leantime/leantime` |
| `image.tag`           | Leantime image tag                 | `3.1.6`             |
| `image.pullPolicy`    | Image pull policy                  | `IfNotPresent`      |
| `replicaCount`        | Number of replicas                 | `1`                 |
| `service.type`        | Kubernetes service type            | `ClusterIP`         |
| `service.port`        | Service port                       | `80`                |
| `ingress.enabled`     | Enable ingress controller resource | `false`             |
| `mysql.enabled`       | Deploy MySQL as dependency         | `true`              |
| `persistence.enabled` | Enable persistent storage          | `true`              |
| `persistence.size`    | Storage size                       | `10Gi`              |

## Usage

### Accessing Leantime

After installation, you can access Leantime using one of these methods:

#### 1. Port Forward (for testing)

```bash
kubectl port-forward service/my-leantime 8080:80
```

Then open http://localhost:8080

#### 2. Ingress (recommended for production)

Configure the ingress in your values.yaml and access via your domain.

#### 3. LoadBalancer/NodePort

Set `service.type` to `LoadBalancer` or `NodePort` in your values.

### Initial Setup

1. **First login:** Use the default admin credentials (check documentation)
2. **Database setup:** If using external MySQL, configure connection details
3. **Configure settings:** Set up your organization details and preferences
4. **Create projects:** Start creating projects and invite team members

## Features

Leantime provides:

- Project management with Kanban boards
- Time tracking and reporting
- Team collaboration tools
- Milestone and goal tracking
- File management
- User and role management

## Storage

The chart supports persistent storage for:

- User uploaded files (`/var/www/html/userfiles`)
- Public files and logos (`/var/www/html/public/userfiles`)
- Application logs (`/var/www/html/storage/logs`)
- Plugin directory (`/var/www/html/app/Plugins`)

## Security

The chart includes several security best practices:

- Non-root container execution
- Configurable security contexts
- Support for Kubernetes secrets
- Network policies (when enabled)

## Troubleshooting

### Common Issues

1. **Database connection errors:**

   - Verify MySQL is running and accessible
   - Check database credentials in configuration
   - Ensure network connectivity between pods

2. **Permission issues:**

   - Check persistent volume permissions
   - Verify security context settings
   - Ensure proper file ownership

3. **Pod not starting:**
   - Check pod logs: `kubectl logs deployment/my-leantime`
   - Verify resource limits are appropriate
   - Check image pull policies and availability

### Getting Help

- [Leantime Documentation](https://docs.leantime.io)
- [GitHub Issues](https://github.com/Leantime/leantime/issues)
- [Discord Community](https://discord.gg/4zMzJtAq9z)

## License

This chart is released under the same license as Leantime (AGPL-3.0). See the [LICENSE](https://github.com/Leantime/leantime/blob/main/LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
