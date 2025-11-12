# Production MicroK8s Setup for Helicone Core

This document explains how the Helicone Core chart has been adapted for your specific production MicroK8s infrastructure.

## Your Infrastructure Pattern

Based on your open-webui Terraform configuration, your MicroK8s cluster has:

- **ArgoCD** for GitOps deployment management
- **External DNS** with Cloudflare integration
- **Nginx Ingress** with automatic TLS
- **Storage classes** (like `hdd-bulk`)
- **Prometheus monitoring** with probe annotations
- **Keycloak SSO** (for other applications)

## Helicone Core Adaptations

### 1. Terraform Integration

The Helicone Core deployment follows your exact pattern:

```
terraform/helicone-core/
├── main.tf           # ArgoCD application + secrets
├── variables.tf      # Input variables
├── values.yaml.tpl   # Helm values template
└── README.md         # Deployment guide
```

### 2. Infrastructure Alignment

| Component | Your Pattern | Helicone Implementation |
|-----------|--------------|------------------------|
| **Deployment** | ArgoCD Application | ✅ ArgoCD Application |
| **DNS** | External DNS + Cloudflare | ✅ External DNS + Cloudflare |
| **TLS** | Terraform-managed secrets | ✅ Terraform-managed secrets |
| **Storage** | `hdd-bulk` storage class | ✅ `hdd-bulk` storage class |
| **Ingress** | Nginx with annotations | ✅ Nginx with annotations |
| **Monitoring** | Prometheus probes | ✅ Prometheus probes |

### 3. Configuration Files

#### For Development (Local MicroK8s)
- `values.microk8s.yaml` - Local development with `.local` domains
- Uses hostpath storage and reduced resources

#### For Production (Your MicroK8s Cluster)
- `values.production-microk8s.yaml` - Production-ready configuration
- `terraform/` - Infrastructure as Code following your pattern

## Key Differences from AWS

| Aspect | AWS (Original) | Your MicroK8s |
|--------|----------------|---------------|
| **Database** | Aurora RDS | PostgreSQL pod with persistent storage |
| **Storage** | EBS volumes | `hdd-bulk` storage class |
| **Images** | ECR private registry | Public Docker Hub |
| **DNS** | Route53 | External DNS + Cloudflare |
| **TLS** | ACM certificates | Terraform-managed certificates |
| **Secrets** | AWS Secrets Manager | Kubernetes secrets |
| **Deployment** | Manual Helm | ArgoCD GitOps |

## Deployment Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    Your MicroK8s Cluster                       │
│                                                                 │
│  ┌─────────────┐    ┌─────────────────────────────────────────┐ │
│  │   ArgoCD    │───▶│           Helicone Core                 │ │
│  │             │    │  ┌─────────┐  ┌─────────┐  ┌─────────┐ │ │
│  └─────────────┘    │  │   Web   │  │  Jawn   │  │ ClickH. │ │ │
│                     │  └─────────┘  └─────────┘  └─────────┘ │ │
│  ┌─────────────┐    │  ┌─────────┐  ┌─────────┐              │ │
│  │External DNS │    │  │ PostgreS│  │  MinIO  │              │ │
│  │             │    │  └─────────┘  └─────────┘              │ │
│  └─────────────┘    └─────────────────────────────────────────┘ │
│         │                                                       │
│         ▼                                                       │
│  ┌─────────────┐    ┌─────────────────────────────────────────┐ │
│  │   Nginx     │    │            Storage                      │ │
│  │  Ingress    │    │  ┌─────────┐  ┌─────────┐  ┌─────────┐ │ │
│  └─────────────┘    │  │ PG-PVC  │  │ CH-PVC  │  │MinIO-PVC│ │ │
│                     │  │20Gi     │  │50Gi     │  │100Gi    │ │ │
│                     │  └─────────┘  └─────────┘  └─────────┘ │ │
└─────────────────────────────────────────────────────────────────┘
         │
         ▼
┌─────────────────┐
│   Cloudflare    │
│   DNS + Proxy   │
└─────────────────┘
```

## Production Features

### High Availability
- **Web**: 2-6 replicas with HPA
- **Jawn**: 2-8 replicas with HPA
- **Pod Disruption Budgets** for critical services

### Monitoring Integration
```yaml
annotations:
  prometheus.io/probe: "true"
  prometheus.io/probe-module: "https_2xx"
  prometheus.io/probe-path: "/"
```

### External DNS Integration
```yaml
annotations:
  external-dns.alpha.kubernetes.io/hostname: "helicone.your-domain.com"
  external-dns.alpha.kubernetes.io/target: "your.cluster.ip"
  external-dns.alpha.kubernetes.io/cloudflare-proxied: "true"
```

### Resource Management
- **Production-sized** resource requests/limits
- **Persistent storage** with your storage classes
- **Proper security contexts** and pod security

## Quick Start for Your Environment

1. **Prepare Terraform variables:**
   ```bash
   cd terraform/helicone-core
   cp terraform.tfvars.example terraform.tfvars
   # Edit with your domain, cluster IP, and secrets
   ```

2. **Deploy with Terraform:**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

3. **Verify deployment:**
   ```bash
   kubectl get application helicone-core -n argocd
   kubectl get pods -n helicone-core
   ```

4. **Access services:**
   - Web UI: `https://helicone.your-domain.com`
   - MinIO: `https://minio.your-domain.com`

## Security Considerations

### Secrets Management
- All secrets managed via Terraform
- Consider external secrets operator for enhanced security
- Rotate secrets regularly

### Network Security
- All traffic encrypted with TLS
- Cloudflare proxy for additional protection
- Internal service communication over cluster network

### Access Control
- Kubernetes RBAC for service accounts
- Consider integrating with your Keycloak for SSO

## Maintenance

### Updates
- ArgoCD will automatically sync chart updates
- Use Terraform for infrastructure changes
- Monitor resource usage and scale as needed

### Backups
- PostgreSQL: Regular database backups
- MinIO: Object storage backups
- ClickHouse: Analytics data backups

### Monitoring
- Prometheus probes for health checks
- Resource monitoring via Kubernetes metrics
- Application-level monitoring via Helicone UI

## Migration Path

If migrating from AWS:
1. **Export data** from AWS services
2. **Deploy** on MicroK8s using Terraform
3. **Import data** into new deployment
4. **Update DNS** to point to MicroK8s cluster
5. **Verify** functionality and performance

## Support

For issues specific to your MicroK8s deployment:
- Check ArgoCD application status
- Review Terraform state and resources
- Monitor ingress and DNS resolution
- Verify storage and persistent volumes

This setup provides a production-ready Helicone Core deployment that integrates seamlessly with your existing MicroK8s infrastructure patterns.
