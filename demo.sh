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

VerCanisterId=$(dfx canister id ver)

echo "Call Verification canister for current principal"

dfx canister call ver init $(dfx identity get-principal)

echo "Call Reputation canister and increase reputation balance for current user"

dfx canister call rep incrementBalance '("'$(dfx identity get-principal)'", 1)'

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

echo "Creating dNFT"

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

echo "dNFT has been created!"

echo "Metadata: "

dfx canister call nft_container getMetadataDip721 "0"

echo " "

echo "dNFT metadata will track reputation balance changes!"

echo "DONE"
