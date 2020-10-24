# AsyncTaskSwitcher

[![CI Linux](https://github.com/horothesun/AsyncTaskSwitcher/workflows/CI%20Linux/badge.svg)](https://github.com/horothesun/AsyncTaskSwitcher/blob/master/.github/workflows/ci-linux.yml)
[![CI macOS](https://github.com/horothesun/AsyncTaskSwitcher/workflows/CI%20macOS/badge.svg)](https://github.com/horothesun/AsyncTaskSwitcher/blob/master/.github/workflows/ci-macos.yml)
[![codecov](https://codecov.io/gh/horothesun/AsyncTaskSwitcher/branch/master/graph/badge.svg?token=6XPPUZBF4W)](https://codecov.io/gh/horothesun/AsyncTaskSwitcher)
[![SwiftPM](https://img.shields.io/badge/SwiftPM-Compatible-brightgreen.svg)](https://swift.org/package-manager/)

Swift asynchronous task switcher: it calls the completion handler of the most-recently-completed asynchronous task.

## Generate Xcode project

```bash
swift package generate-xcodeproj
```

## Testing

### macOS

```bash
swift test
```

### Docker Linux

IMPORTANT: regenerate Linux test list executing

```bash
swift test --generate-linuxmain
```

Execute on base `swift:5.2` image

```bash
docker run --rm \
    --volume "$(pwd):/package" \
    --workdir '/package' \
    swift:5.2 \
    /bin/bash -c 'swift test'
```

or create a new image based on `Dockerfile` and run it

```bash
docker build --tag async-task-switcher .
docker run --rm async-task-switcher
```
