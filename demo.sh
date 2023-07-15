#!/usr/bin/env bash
dfx stop
set -e
trap 'dfx stop' EXIT

dfx start --background --clean

dfx canister create rep
dfx canister create ver
dfx canister create nft_container

dfx build

dfx canister install rep
dfx canister install ver

CanisterId=$(dfx canister id ver)

dfx deploy --argument "(
  principal\"$(dfx identity get-principal)\", 
  record {
    logo = record {
      logo_type = \"image/png\";
      data = \"1\";
    };
    name = \"Ava dNFT\";
    symbol = \"AVA1\";
    maxLimit = 1;
  }
)" nft_container

dfx canister call nft_container mintDip721 \
"(
  principal\"$(dfx identity get-principal)\", 
  vec { 
    record {
      purpose = variant{Rendered};
      data = blob\"Start\";
      key_val_data = vec {
        record { key = \"description\"; val = variant{TextContent=\"The aVa dNFT metadata\"}; };
        record { key = \"contentType\"; val = variant{TextContent=\"text/plain\"}; };
        record { key = \"locationType\"; val = variant{Nat8Content=4:nat8}; };
        record { key = \"reputationBalance\"; val = variant{LinkContent=\"$(dfx canister id ver).getBalance\"} };
      }
    }
  }
)"

echo "DONE"
