#!/bin/bash
set -e

sed "s/_BUILD_NUMBER_/`git rev-list HEAD --count`/" "$PROJECT_DIR"/Resources/Info.plist > "$PROJECT_DIR"/Resources/Secret.plist