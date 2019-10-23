#
# The key must be generated as described in doc
# with
# openssl enc -aes-256-cbc -k <PASSPHRASE> -P -md sha1
# The file is in the format
# salt=
# key=
# iv=
# parameters: $1 = input file, $2 = output file
swu_encrypt_file() {
	input=$1
	output=$2
	key=`cat ${SWUPDATE_AES_FILE} | grep ^key | cut -d '=' -f 2`
	iv=`cat ${SWUPDATE_AES_FILE} | grep ^iv | cut -d '=' -f 2`
	salt=`cat ${SWUPDATE_AES_FILE} | grep ^salt | cut -d '=' -f 2`
	if [ -z ${salt} ] || [ -z ${key} ] || [ -z ${iv} ];then
		bbfatal "SWUPDATE_AES_FILE=$SWUPDATE_AES_FILE does not contain valid keys"
	fi
	openssl enc -aes-256-cbc -in ${input} -out ${output} -K ${key} -iv ${iv} -S ${salt}
}

CONVERSIONTYPES += "enc"

CONVERSION_DEPENDS_enc = "openssl-native coreutils-native"
CONVERSION_CMD_enc="swu_encrypt_file ${IMAGE_NAME}${IMAGE_NAME_SUFFIX}.${type} ${IMAGE_NAME}${IMAGE_NAME_SUFFIX}.${type}.enc"


# To get the keys and certificates installed the variables SWUPDATE_CMS_CERT
# and SWUPDATE_AES_FILE need to be defined for the image and the update-image.
install_key_and_cert() {
    # Install the image signature verification certificate
    if [ "x${SWUPDATE_CMS_CERT}" != "x" ]; then
        install -m 0600 ${SWUPDATE_CMS_CERT} ${IMAGE_ROOTFS}${libdir}/swupdate/image-signing.cert.pem
        echo 'SWUPDATE_ARGS="${SWUPDATE_ARGS} -k /usr/lib/swupdate/image-signing.cert.pem"' > ${WORKDIR}/80-enable-sign-images
        install -m 0644 ${WORKDIR}/80-enable-sign-images ${IMAGE_ROOTFS}${libdir}/swupdate/conf.d
    fi

    # Install the key to decrypt update images
    if [ "x${SWUPDATE_AES_FILE}" != "x" ]; then
        key=`grep ^key ${SWUPDATE_AES_FILE} | cut -d '=' -f 2`
        iv=`grep ^iv ${SWUPDATE_AES_FILE} | cut -d '=' -f 2`
        if [ -z ${key} ] || [ -z ${iv} ]; then
            bbfatal "SWUPDATE_AES_FILE=$SWUPDATE_AES_FILE does not contain valid keys"
        fi
        echo "${key} ${iv}" > ${WORKDIR}/image-enc-aes.key
        install -m 0600 ${WORKDIR}/image-enc-aes.key ${IMAGE_ROOTFS}${libdir}/swupdate
        echo 'SWUPDATE_ARGS="${SWUPDATE_ARGS} -K /usr/lib/swupdate/image-enc-aes.key"' > ${WORKDIR}/81-enable-enc-images
        install -m 0644 ${WORKDIR}/81-enable-enc-images ${IMAGE_ROOTFS}${libdir}/swupdate/conf.d
    fi
}
ROOTFS_POSTPROCESS_COMMAND += 'install_key_and_cert;'
