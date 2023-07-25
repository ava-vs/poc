// Reputation System Mock

import Principal "mo:base/Principal";
import Types "./Types";
import List "mo:base/List";
import Map "mo:base/HashMap";
import Text "mo:base/Text";
import Iter "mo:base/Iter";
import Int "mo:base/Int";

actor ReputationSystem {

  type Balance = Types.ReputationBalance;

  type Verifier = {
    account : Text;
    callback : shared Balance -> ();
  };

  stable var verifiers = List.nil<Verifier>();
  var balances : Map.HashMap<Principal, Int> = 
       Map.HashMap<Principal, Int>(10, Principal.equal, Principal.hash);

  public func subscribe(verifier : Verifier) {
    verifiers := List.push(verifier, verifiers);
    balances.put(Principal.fromText(verifier.account), 0);
  };

  public func publish(balance : Balance) {
    for (verifier in List.toArray(verifiers).vals()) {
      if (verifier.account == balance.account) {
        verifier.callback(balance);
      };
    };
  };

  public func incrementBalance(account: Text, increment: Int) : async () {
    let balanceOpt = balances.get(Principal.fromText(account));
    
    let newBalance = switch (balanceOpt) {
      case (null) { 0 }; 
      case (?balance) { Int.add(balance, increment) }; 
    };
    balances.put(Principal.fromText(account), newBalance);
    let balanceObj = { account = account; value = newBalance };
    publish(balanceObj);
  };

//   Function returning the caller's identifier
  public shared (message) func whoami() : async Principal {
    return message.caller;
  };

//   Function returning the current actor's identifier
  public func id() : async Principal {
    return await whoami();
  };

   public func getUsers() : async [(Principal, Int)] {
    Iter.toArray(balances.entries());
  };
}
