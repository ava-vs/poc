# Proof-Of-Concept
aVa Verification System (Internet Computer)

See aVa [Wiki](https://github.com/ava-vs/poc/wiki)

## Install:

Use commands:
```bash
dfx canister create rep

dfx canister create ver

dfx build

dfx canister install rep
dfx canister install ver

dfx deploy --argument "(
  principal\"$(dfx identity get-principal)\", 
  record {
    logo = record {
      logo_type = \"image/png\";
      data = \"1\";
    };
    name = \"Ava dNFT\";
    symbol = \"AVAD\";
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
        record { key = \"verificathionLink\"; val = variant{TextContent=\"https://a4gq6-oaaaa-aaaab-qaa4q-cai.raw.icp0.io/?id=4rouu-2iaaa-aaaal-qcahq-cai\"}; };
        record { key = \"reputationBalance\"; val = variant{LinkContent=\"4rouu-2iaaa-aaaal-qcahq-cai.getBalance\"} };
      }
    }
  }
)"
```
or 

type <code> ./demo.sh</code>


