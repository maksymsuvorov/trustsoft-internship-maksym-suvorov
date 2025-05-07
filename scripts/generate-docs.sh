# Docker needs to be installed
# Script that generates documentation for each module using terraform-docs
# Run "chmod +x generate-docs.sh" before usage
# Run this script from root folder

#!/usr/bin/env bash

for mod in modules/*; do
  if [ -d "$mod" ]; then
    (cd "$mod" && docker run --rm --volume "$(pwd):/terraform-docs" -u $(id -u) quay.io/terraform-docs/terraform-docs:0.20.0 markdown /terraform-docs > README.md)
    echo "Updated: $mod/README.md"
  fi
done
