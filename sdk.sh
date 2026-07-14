#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# --- SDKMAN ---
if [[ ! -d "$HOME/.sdkman" ]]; then
    curl -s "https://get.sdkman.io" | bash
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    sdk install java 21.0.10-amzn
    sdk install java 25.0.2-amzn
    sdk install quarkus
    sdk install gradle
fi