#!/bin/bash

PROJ_DIR="$HOME/Documents/QT_Programs/Proj_1_1"
RELEASE_DIR="$HOME/Documents/QT_Programs/Proj_1_1-Release"

BUILD_BINARY=$(find "$HOME/Documents/QT_Programs" -type f -name "Proj_1_1" -executable ! -name "*.sh")

if [ -z "$BUILD_BINARY" ]; then
	echo "Error: Compiled binary 'proj_1_1' not found. Build your project in Qt Creator first."
	exit 1
fi

echo "Found compiled binary at: $BUILD_BINARY"

rm -rf "$RELEASE_DIR"
mkdir -p "$RELEASE_DIR/bin"
mkdir -p "$RELEASE_DIR/lib"
mkdir -p "$RELEASE_DIR/plugins/platforms"
mkdir -p "$RELEASE_DIR/models"
mkdir -p "$RELEASE_DIR/qml/QtQuick"
mkdir -p "$RELEASE_DIR/plugins/platforminputcontexts"

cp "$BUILD_BINARY" "$RELEASE_DIR/bin/"

cp -r /usr/lib/aarch64-linux-gnu/qt5/qml/QtQuick/VirtualKeyboard "$RELEASE_DIR/qml/QtQuick/"
cp /usr/lib/aarch64-linux-gnu/qt5/plugins/platforminputcontexts/libqtvirtualkeyboardplugin.so "$RELEASE_DIR/plugins/platforminputcontexts/"

cp "$PROJ_DIR"/3rdparty/sherpa-onnx/lib/*.so* "$RELEASE_DIR/lib/"
cp "$PROJ_DIR"/models/*-epoch-99-avg-1.onnx "$RELEASE_DIR/models/"
cp "$PROJ_DIR"/models/tokens.txt "$RELEASE_DIR/models/"

cp /usr/lib/aarch64-linux-gnu/libmodbus.so* "$RELEASE_DIR/lib/" 2>/dev/null || true

cp /usr/lib/aarch64-linux-gnu/libQt5Core.so* "$RELEASE_DIR/lib/"
cp /usr/lib/aarch64-linux-gnu/libQt5Gui.so* "$RELEASE_DIR/lib/"
cp /usr/lib/aarch64-linux-gnu/libQt5Network.so* "$RELEASE_DIR/lib/"
cp /usr/lib/aarch64-linux-gnu/libQt5Multimedia.so* "$RELEASE_DIR/lib/"


cp /usr/lib/aarch64-linux-gnu/qt5/plugins/platforms/libqxcb.so "$RELEASE_DIR/plugins/platforms/" 2>/dev/null || true
cp /usr/lib/aarch64-linux-gnu/qt5/plugins/platforms/libqeglfs.so "$RELEASE_DIR/plugins/platforms/" 2>/dev/null || true

cat << 'EOF' > "$RELEASE_DIR/run.sh"
#!/bin/sh
HERE="$(cd "$(dirname "$0")" && pwd)"
export LD_LIBRARY_PATH="$HERE/lib:$LD_LIBRARY_PATH"
export QT_QPA_PLATFORM_PLUGIN_PATH="$HERE/plugins/platforms"
export QT_PLUGIN_PATH="$HERE/plugins"
export QML2_IMPORT_PATH="$HERE/qml"
export QT_IM_MODULE=qtvirtualkeyboard

export QT_QPA_PLATFORM="offscreen"
exec "$HERE/bin/Proj_1_1" "$@"
EOF

chmod +x "$RELEASE_DIR/run.sh"
echo "Package successfully generated at: $RELEASE_DIR"
