# Discord Alertmanager Helm Chart

Bridge between Prometheus Alertmanager and Discord with interactive buttons.

## Features

- **Interactive Discord Messages**: Adds Silence, Grafana, and Alert buttons to Discord messages
- **Message Updates**: Updates existing messages when alerts resolve instead of creating new messages
- **Label-based Routing**: Routes alerts to different Discord channels based on Alertmanager labels
- **Silence Integration**: Creates silences in Alertmanager directly from Discord buttons

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+
- Discord Bot Token
- Alertmanager instance

## Installing the Chart

```bash
helm repo add xargsuk https://xargsuk.github.io/helm-charts
helm repo update

helm install discord-alertmanager xargsuk/discord-alertmanager \
  --namespace monitoring \
  --set secrets.discordBotToken="YOUR_DISCORD_BOT_TOKEN" \
  --set config.discord.defaultChannelId="YOUR_CHANNEL_ID"
```

## Configuration

See [values.yaml](values.yaml) for the full list of configuration options.

### Required Configuration

| Parameter | Description |
|-----------|-------------|
| `secrets.discordBotToken` | Discord bot token (required) |
| `config.discord.defaultChannelId` | Default Discord channel ID for alerts |

### Discord Channel Routing

Configure label-based routing to send alerts to different channels:

```yaml
config:
  discord:
    defaultChannelId: "123456789"
    routes:
      - name: "Critical Alerts"
        channelId: "111111111"
        matchers:
          severity: critical
      - name: "Backend Team"
        channelId: "222222222"
        matchers:
          team: backend
```

### Persistence

By default, a 1Gi PVC is created for the SQLite database:

```yaml
persistence:
  enabled: true
  storageClass: ""  # Use default storage class
  size: 1Gi
```

## Alertmanager Configuration

Configure Alertmanager to send webhooks to discord-alertmanager:

```yaml
receivers:
  - name: 'discord-alertmanager'
    webhook_configs:
      - url: 'http://discord-alertmanager.monitoring.svc.cluster.local:8000/webhook'
        send_resolved: true

route:
  receiver: 'discord-alertmanager'
```

## Values

See [values.yaml](./values.yaml) for detailed configuration options.
