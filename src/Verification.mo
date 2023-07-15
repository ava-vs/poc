import Nat "mo:base/Nat";
import Principal "mo:base/Principal";
import Types "./Types";
import Text "mo:base/Text";
import Int "mo:base/Int";
import ReputationSystem "canister:rep";
import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";

actor Verifier {

  type Balance = {
    account : Text;
    value : Int;
  };

  var balances: HashMap.HashMap<Text, Int> = 
       HashMap.HashMap<Text, Int>(10, Text.equal, Text.hash);  

  public func init(account0 : Text) : async () {
    let principal = Principal.fromText(account0);
    
    ReputationSystem.subscribe({
      account = account0;
      callback = updateBalance;
    });
  };

  public func updateBalance(balance0 : Balance) {
    balances.put(balance0.account, balance0.value);
  };

  public query func getBalance(account: Text) : async ?Int {
    balances.get(account);
  }; 
 
}

