# Helicone Core for MicroK8s

This guide explains how to deploy Helicone Core on a MicroK8s cluster instead of AWS.

## Prerequisites

1. **MicroK8s cluster** with the following addons enabled:
   ```bash
   microk8s enable dns
   microk8s enable storage
   microk8s enable ingress
   microk8s enable registry
   ```

2. **Helm 3** installed and configured to work with your MicroK8s cluster:
   ```bash
   microk8s kubectl config view --raw > ~/.kube/config
   ```

## Key Differences from AWS Deployment

### Storage
- Uses `microk8s-hostpath` storage class instead of AWS EBS (`gp2-immediate`)
- Suitable for single-node development clusters

### Database
- Uses local PostgreSQL container instead of AWS Aurora
- Includes built-in PostgreSQL with persistent storage

### Container Images
- Uses public Docker Hub images instead of AWS ECR
- Images: `helicone/web`, `helicone/jawn`, `helicone/migrations`

### Networking
- Uses local hostnames (`helicone.local`, `minio.local`, `mailhog.local`)
- Configured for MicroK8s ingress controller

### Scaling
- Disabled HPA (Horizontal Pod Autoscaler) for single-node clusters
- Disabled VPA (Vertical Pod Autoscaler)
- Reduced resource requests for development use

## Installation

1. **Add your local hostnames to `/etc/hosts`:**
   ```bash
   echo "127.0.0.1 helicone.local minio.local mailhog.local" | sudo tee -a /etc/hosts
   ```

2. **Install the chart:**
   ```bash
   helm install helicone-core ./charts/helicone-core \
     -f ./charts/helicone-core/values.microk8s.yaml \
     --namespace helicone \
     --create-namespace
   ```

3. **Wait for all pods to be ready:**
   ```bash
   kubectl get pods -n helicone -w
   ```

## Accessing Services

Once deployed, you can access:

- **Helicone Web UI**: http://helicone.local
- **MinIO Console**: http://minio.local (admin/minioadmin123)
- **MailHog**: http://mailhog.local (email testing)

## Configuration

### Default Credentials

The microk8s configuration includes development-friendly defaults:

- **PostgreSQL**: `helicone_admin` / `helicone-dev-password`
- **MinIO**: `minioadmin` / `minioadmin123`
- **Better Auth Secret**: `dev-better-auth-secret-key-32-chars`

### Customization

To customize the deployment, create your own values file based on `values.microk8s.yaml`:

```bash
cp charts/helicone-core/values.microk8s.yaml my-values.yaml
# Edit my-values.yaml as needed
helm upgrade helicone-core ./charts/helicone-core -f my-values.yaml -n helicone
```

## Troubleshooting

### Common Issues

1. **Pods stuck in Pending state**
   - Check if storage addon is enabled: `microk8s status`
   - Verify PVC creation: `kubectl get pvc -n helicone`

2. **Ingress not working**
   - Ensure ingress addon is enabled: `microk8s enable ingress`
   - Check ingress controller: `kubectl get pods -n ingress`

3. **Database connection issues**
   - Check PostgreSQL pod logs: `kubectl logs -n helicone deployment/helicone-core-postgresql`
   - Verify secrets: `kubectl get secrets -n helicone`

### Debugging Commands

```bash
# Check all resources
kubectl get all -n helicone

# Check pod logs
kubectl logs -n helicone deployment/helicone-core-web
kubectl logs -n helicone deployment/helicone-core-jawn

# Check ingress
kubectl get ingress -n helicone
kubectl describe ingress -n helicone

# Port forward for direct access
kubectl port-forward -n helicone svc/helicone-core-web 3000:3000
```

## Development

### Building Custom Images

If you need to build custom images for development:

1. **Enable MicroK8s registry:**
   ```bash
   microk8s enable registry
   ```

2. **Build and push images:**
   ```bash
   docker build -t localhost:32000/helicone/web:dev .
   docker push localhost:32000/helicone/web:dev
   ```

3. **Update values file to use local images:**
   ```yaml
   helicone:
     web:
       image:
         repository: localhost:32000/helicone/web
         tag: dev
   ```

### Resource Monitoring

Monitor resource usage:

```bash
# Node resources
kubectl top nodes

# Pod resources
kubectl top pods -n helicone

# Persistent volumes
kubectl get pv
```

## Production Considerations

This MicroK8s configuration is designed for development and testing. For production:

1. **Use external databases** (PostgreSQL, ClickHouse)
2. **Configure proper secrets management**
3. **Set up monitoring and logging**
4. **Use production-grade storage**
5. **Configure backup strategies**
6. **Set appropriate resource limits**
7. **Enable TLS/SSL certificates**

## Migration from AWS

To migrate from AWS to MicroK8s:

1. **Export data** from Aurora PostgreSQL
2. **Backup S3 data** from AWS
3. **Deploy on MicroK8s** using this configuration
4. **Import data** into local PostgreSQL
5. **Upload files** to MinIO
6. **Update DNS** to point to new cluster

## Support

For issues specific to the MicroK8s deployment, check:

- MicroK8s documentation: https://microk8s.io/docs
- Kubernetes troubleshooting guides
- Helm documentation: https://helm.sh/docs/
