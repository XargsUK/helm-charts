# helm-charts

## Usage

[Helm](https://helm.sh) must be installed to use the charts.
Please refer to Helm's [documentation](https://helm.sh/docs) to get started.

Once Helm has been set up correctly, add the repo as follows:

  `helm repo add <alias> https://xargsuk.github.io/helm-charts`

If you had already added this repo earlier, run `helm repo update` to retrieve the latest versions of the packages.
You can then run `helm search repo <alias>` to see the charts.

## Available Charts

### VIA - QMK Keyboard Configuration Tool

VIA is a powerful, open-source web-based interface for configuring your QMK-powered mechanical keyboard.

**Prerequisites:** You must build and push a custom Docker image before installing this chart. See the [VIA chart README](charts/via/README.md) for detailed instructions.

To install the VIA chart:

  `helm install my-via <alias>/via --set image.repository=your-registry/via`

To uninstall the chart:

  `helm delete my-via`

For more information about VIA, visit: https://github.com/the-via/app