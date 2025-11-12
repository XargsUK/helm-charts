# leantime

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square)

A Leantime Helm chart for Kubernetes. Project management more capable than Trello and no where near as overwhelming as Jira

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | mariadb | 11.5.3 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| app.defaultTimezone | string | `"America/Los_Angeles"` | Sets the default Timezone |
| app.email.enabled | bool | `false` | Set to true if you want to use SMTP. If set to false, the default php mail() function will be used |
| app.email.return | string | `"leantime@cluster.local"` | Sets the email address to use for notifications and registrations |
| app.email.smtp.autoTLS | bool | `true` | Set autoTLS? |
| app.email.smtp.hosts | string | `""` | SMTP host |
| app.email.smtp.password | string | `""` | SMTP password |
| app.email.smtp.port | int | `587` | SMTP port |
| app.email.smtp.secure | string | `"STARTLS"` | Sets the SMTP security protocol (usually one of: TLS, SSL, STARTTLS) |
| app.email.smtp.username | string | `""` | SMTP username |
| app.language | string | `"en-US"` | Sets application language |
| app.ldap.DN | string | `""` | Location of users, example: CN=users,DC=example,DC=com |
| app.ldap.baseDN | string | `""` | Base DN, example: DC=example,DC=com |
| app.ldap.defaultRoleKey | string | `""` | Sets the default role for users when they are first created |
| app.ldap.enabled | bool | `false` | Set to true if you want to use LDAP |
| app.ldap.groupAssignment | string | `""` | Default role assignments upon first login |
| app.ldap.host | string | `""` | FQDN |
| app.ldap.keys | string | `""` | Default ldap keys in your directory |
| app.ldap.port | int | `389` | Sets LDAP port |
| app.ldap.type | string | `""` | Select the correct directory type. Currently Supported: OL - OpenLdap, AD - Active Directory |
| app.ldap.userDomain | string | `""` | Domain after ldap, example @example.com |
| app.leanSessionSecure | string | `"true"` | Sets the cookie flag to only allow HTTPS transfer. |
| app.s3.bucket | string | `""` | S3 bucket |
| app.s3.enabled | bool | `false` | Set to true if you want to use S3 instead of local files |
| app.s3.enpoint | string | `""` | S3 endpoint |
| app.s3.folderName | string | `""` | Sets the foldername within S3 (can be empty) |
| app.s3.key | string | `""` | S3 key |
| app.s3.region | string | `""` | S3 region |
| app.s3.secret | string | `""` | S3 secret |
| app.s3.usePathStyleEndpoint | string | `"false"` | Sets wether or not use path-style endpoint |
| app.session.expiration | int | `28800` | Session expiration |
| app.session.password | string | `"changeme"` | Salting sessions. Replace with a strong password |
| app.sitename | string | `"Leantime"` | Sets the name for the instance |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| fullnameOverride | string | `""` | Ovverrides the fullname of the kubernetes object names for this release |
| image.pullPolicy | string | `"IfNotPresent"` | The pull policy of the Leantime OCI image applied to the deployment |
| image.repository | string | `"leantime/leantime"` | OCI image repository of the Leantime application |
| image.tag | string | `"latest"` | Overrides the image tag whose default is the chart appVersion |
| imagePullSecrets | list | `[]` | The pull secrets to be used if you want to use a Leantime application image hosted in a private registry |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| mariadb.auth.database | string | `"leantime"` | Database name |
| mariadb.auth.password | string | `"changeme"` | Database password |
| mariadb.auth.rootPassword | string | `"changeme"` | Database root password |
| mariadb.auth.username | string | `"leantime"` | Database username |
| mariadb.enabled | bool | `true` |  |
| nameOverride | string | `""` | Overrides the name of the chart |
| nodeSelector | object | `{}` |  |
| persistence.enabled | bool | `true` | Enables or disables the persistence |
| persistence.size | string | `"5Gi"` | Sets the size of the PVs for Leantime's public and private userfiles |
| persistence.storageClass | string | `""` | empty will use system default |
| podAnnotations | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| securityContext | object | `{}` |  |
| service.port | int | `80` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `false` |  |
| serviceAccount.name | string | `""` |  |
| tolerations | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
