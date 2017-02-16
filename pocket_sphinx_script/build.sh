#!/usr/bin/env sh

SPHINXBASE_ARCHIVE="sphinxbase-5prealpha.tar.gz"
POCKETSPHINX_ARCHIVE="pocketsphinx-5prealpha.tar.gz"

ARCHS=("arm64" "armv7" "x86_64" "i386")
SCRATCH="scratch"
BITCODE_ENABLED=false
MIN_IOS_VERSION="8.0"

SPHINXBASE_PATH="$(pwd)/sphinxbase"
POCKETSPHINX_PATH="$(pwd)/pocketsphinx"

SPHINXBASE_DEST="${SPHINXBASE_PATH}/bin"
POCKETSPHINX_DEST="${POCKETSPHINX_PATH}/bin"

SPHINXBASE_SCRATCH="${SPHINXBASE_PATH}/${SCRATCH}"
POCKETSPHINX_SCRATCH="${POCKETSPHINX_PATH}/${SCRATCH}"

rm -rf "${SPHINXBASE_PATH}"
rm -rf "${POCKETSPHINX_PATH}"

mkdir -p "${SPHINXBASE_PATH}"
mkdir -p "${POCKETSPHINX_PATH}"

mkdir -p "${SPHINXBASE_DEST}"
mkdir -p "${POCKETSPHINX_DEST}"

mkdir -p "${SPHINXBASE_SCRATCH}"
mkdir -p "${SPHINXBASE_SCRATCH}"

tar -xzf "${SPHINXBASE_ARCHIVE}" -C "${SPHINXBASE_PATH}" --strip-components=1
tar -xzf "${POCKETSPHINX_ARCHIVE}" -C "${POCKETSPHINX_PATH}" --strip-components=1

pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}

build_sphinxbase () {
    for ARCH in "${ARCHS[@]}"
    do
        echo "building sphinxbase for $ARCH..."

        SCRATCH_DIR="${SPHINXBASE_SCRATCH}/${ARCH}"
        mkdir -p "${SCRATCH_DIR}" || exit 1
        pushd "${SCRATCH_DIR}"
            if [ "$ARCH" = "i386" -o "$ARCH" = "x86_64" ]
            then
                PLATFORM="iPhoneSimulator"
                IOS_CFLAGS="-arch $ARCH -mios-simulator-version-min=${MIN_IOS_VERSION}"
            else
                PLATFORM="iPhoneOS"
                IOS_CFLAGS="-arch $ARCH -mios-version-min=${MIN_IOS_VERSION}"
            fi

            if ${BITCODE_ENABLED}; then
                IOS_CFLAGS="${IOS_CFLAGS} -fembed-bitcode"
            fi

            HOST_TYPE="${ARCH}-apple-darwin"
            if [ "${ARCH}" == "arm64" ]; then
                HOST_TYPE="arm-apple-darwin"
            fi

            export DEVELOPER=`xcode-select --print-path`
            export DEVROOT="${DEVELOPER}/Platforms/${PLATFORM}.platform/Developer"
            export SDKROOT="${DEVROOT}/SDKs/${PLATFORM}${IPHONE_SDK}.sdk"
            export CC=`xcrun -find clang`
            export LD=`xcrun -find ld`
            export CFLAGS="-O3 ${IOS_CFLAGS} -isysroot ${SDKROOT}"
            export LDFLAGS="${IOS_CFLAGS} -isysroot ${SDKROOT}"
            export CPPFLAGS="${CFLAGS}"

            ${SPHINXBASE_PATH}/configure \
                --host="${HOST_TYPE}" \
                --prefix="${SPHINXBASE_DEST}/${ARCH}" \
                --without-lapack \
                --without-python \
            || exit 1

            make -j3 install || exit 1
        popd
    done
}

build_pocketsphinx () {
    for ARCH in "${ARCHS[@]}"
    do
        echo "building pocketsphinx for $ARCH..."

        SCRATCH_DIR="${POCKETSPHINX_SCRATCH}/${ARCH}"
        mkdir -p "${SCRATCH_DIR}" || exit 1
        pushd "${SCRATCH_DIR}"
            if [ "$ARCH" = "i386" -o "$ARCH" = "x86_64" ]
            then
                PLATFORM="iPhoneSimulator"
                IOS_CFLAGS="-arch $ARCH -mios-simulator-version-min=${MIN_IOS_VERSION}"
            else
                PLATFORM="iPhoneOS"
                IOS_CFLAGS="-arch $ARCH -mios-version-min=${MIN_IOS_VERSION}"
            fi

            if ${BITCODE_ENABLED}; then
                IOS_CFLAGS="${IOS_CFLAGS} -fembed-bitcode"
            fi

            HOST_TYPE="${ARCH}-apple-darwin"
            if [ "${ARCH}" == "arm64" ]; then
                HOST_TYPE="arm-apple-darwin"
            fi

            export DEVELOPER=`xcode-select --print-path`
            export DEVROOT="${DEVELOPER}/Platforms/${PLATFORM}.platform/Developer"
            export SDKROOT="${DEVROOT}/SDKs/${PLATFORM}${IPHONE_SDK}.sdk"
            export CC=`xcrun -find clang`
            export LD=`xcrun -find ld`
            export CFLAGS="-O3 ${IOS_CFLAGS} -isysroot ${SDKROOT}"
            export LDFLAGS="${IOS_CFLAGS} -isysroot ${SDKROOT}"
            export CPPFLAGS="${CFLAGS}"

            SPHINXBASE_DIR="${SPHINXBASE_DEST}/${ARCH}"

            ${POCKETSPHINX_PATH}/configure \
                --host="${HOST_TYPE}" \
                --prefix="${POCKETSPHINX_DEST}/${ARCH}" \
                --without-lapack \
                --without-python \
                --with-sphinxbase="${SPHINXBASE_DIR}" \
            || exit 1

            make -j3 install || exit 1
        popd
    done
}

make_universal_library_for_sphinxbase () {
    pushd "${SPHINXBASE_DEST}"

    mkdir -p "universal"

    PARAMS_XAD=()
    PARAMS_BASE=()
    for ARCH in "${ARCHS[@]}"
    do
        PARAMS_XAD+=("${ARCH}/lib/libsphinxad.a")
        PARAMS_BASE+=("${ARCH}/lib/libsphinxbase.a")
    done

    lipo -create "${PARAMS_XAD[@]}" -output "universal/libsphinxad.a"
    lipo -create "${PARAMS_BASE[@]}" -output "universal/libsphinxbase.a"

    popd
}

make_universal_library_for_pocketsphinx () {
    pushd "${POCKETSPHINX_DEST}"

    mkdir -p "universal"

    PARAMS=()
    for ARCH in "${ARCHS[@]}"
    do
        PARAMS+=("${ARCH}/lib/libpocketsphinx.a")
    done

    lipo -create "${PARAMS[@]}" -output "universal/libpocketsphinx.a"

    popd
}

build_sphinxbase && \
build_pocketsphinx && \
make_universal_library_for_sphinxbase && \
make_universal_library_for_pocketsphinx

OUTPUT_PATH="$(pwd)/sphinx"
OUTPUT_PATH_INCLUDE="${OUTPUT_PATH}/include"

rm -rf "${OUTPUT_PATH}"

mkdir -p "${OUTPUT_PATH}"
mkdir -p "${OUTPUT_PATH_INCLUDE}"

cp -r "${SPHINXBASE_DEST}/${ARCHS[0]}/include/sphinxbase" "${OUTPUT_PATH_INCLUDE}"
cp -r "${POCKETSPHINX_DEST}/${ARCHS[0]}/include/pocketsphinx" "${OUTPUT_PATH_INCLUDE}"

OUTPUT_PATH_LIB="${OUTPUT_PATH}/lib"

mkdir -p "${OUTPUT_PATH_LIB}"

cp -r "${SPHINXBASE_DEST}/universal/libsphinxad.a" "${OUTPUT_PATH_LIB}"
cp -r "${SPHINXBASE_DEST}/universal/libsphinxbase.a" "${OUTPUT_PATH_LIB}"
cp -r "${POCKETSPHINX_DEST}/universal/libpocketsphinx.a" "${OUTPUT_PATH_LIB}"

rm -rf "${SPHINXBASE_PATH}"
rm -rf "${POCKETSPHINX_PATH}"

echo "Done..."
