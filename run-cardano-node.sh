#!/bin/bash
# Thiết lập các biến môi trường cho mạng preprod
export CARDANO_NETWORK=preprod
export AGGREGATOR_ENDPOINT="https://aggregator.release-preprod.api.mithril.network/aggregator"
export GENESIS_VERIFICATION_KEY=$(wget -q -O - https://raw.githubusercontent.com/input-output-hk/mithril/main/mithril-infra/configuration/release-preprod/genesis.vkey)
export SNAPSHOT_DIGEST=latest

# Kiểm tra nếu thư mục blockchain chưa tồn tại, tải snapshot mới
DIR="/opt/cardano/config/preprod/db/"
# if [ ! -d "$DIR" ]; then
#   echo "Tải snapshot Cardano blockchain..."
#   mithril-client cardano-db download $SNAPSHOT_DIGEST
# else
#   echo "Dữ liệu của Blockchain Cardano đã tồn tại"
# fi
echo "Tải snapshot Cardano blockchain..."
mithril-client cardano-db download $SNAPSHOT_DIGEST
echo "Dữ liệu của Blockchain Cardano đã tồn tại"

# Khởi động cardano-node
echo "Khởi động cardano-node..."
cardano-node run --config /opt/cardano/config/preprod/config.json --database-path /opt/cardano/config/preprod/db --socket-path /opt/cardano/config/preprod/db/node.socket --host-addr 0.0.0.0 --port 3001 --topology /opt/cardano/config/preprod/topology.json >/dev/null 2>&1