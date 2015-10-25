#!/bin/sh

curl -s -F "token=anSbF44UGeiR6bMyHWfpXG56KmEn27"     -F "user=IoF0EFPsfQ7Ig0qlnObSdnvk2689BH"  -F "message=$1" https://api.pushover.net/1/messages.json
