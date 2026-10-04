#!/bin/bash

export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)


if [ -z "$YC_TOKEN" ]; then
    echo "Ошибка: Не удалось получить YC_TOKEN"
    echo "Проверьте, что вы авторизованы: yc init"
    exit 1
fi

echo "   Переменные установлены:"
echo "   YC_CLOUD_ID: $YC_CLOUD_ID"
echo "   YC_FOLDER_ID: $YC_FOLDER_ID"
echo "   YC_TOKEN: ${YC_TOKEN:0:20}... "
