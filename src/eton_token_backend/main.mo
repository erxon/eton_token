import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";

actor Token {
  Debug.print("hello");
  var owner : Principal = Principal.fromText("2xcnw-iqx7l-whno3-vywcr-4rxgg-c3lnd-j2par-ba2ip-334lg-64e3e-vqe");
  var totalSupply : Nat = 1000000000;
  var symbol : Text = "ETON";

  stable var balanceEntries : [(Principal, Nat)] = [];
  var balances = HashMap.HashMap<Principal, Nat>(1, Principal.equal, Principal.hash);
  if (balances.size() < 1) {
    balances.put(owner, totalSupply);
  };

  public query func balanceOf(who : Principal) : async Nat {

    let balance : Nat = switch (balances.get(who)) {
      case null 0;
      case (?result) result;
    };

    return balance;
  };

  public query func getSymbol() : async Text {
    return symbol;
  };

  public shared (msg) func payOut() : async Text {
    Debug.print(debug_show (msg.caller));
    // if (balances.get(msg.caller) == null) {
    //   var amount = 10000;
    //   balances.put(msg.caller, amount);

    //   return "Success";
    // } else {
    //   return "Already Claimed";
    // };
    if (balances.get(msg.caller) == null) {
      let amount = 10000;
      let result = await transfer(msg.caller, amount);

      return result;
    } else {
      return "Already Claimed";
    };
  };

  public shared (msg) func transfer(to : Principal, amount : Nat) : async Text {
    let balance = await balanceOf(msg.caller);

    if (balance > amount) {
      let newBalanceFrom : Nat = balance - amount;
      balances.put(msg.caller, newBalanceFrom);

      let recipientBalance = await balanceOf(to);
      let newRecipientBalance = recipientBalance + amount;
      balances.put(to, newRecipientBalance);

      return "Success";
    } else {
      return "Insufficient funds";
    };

  };

  system func preupgrade() {
    balanceEntries := Iter.toArray(balances.entries());
  };

  system func postupgrade() {
    balances := HashMap.fromIter<Principal, Nat>(balanceEntries.vals(), 1, Principal.equal, Principal.hash);
    if (balances.size() < 1) {
      balances.put(owner, totalSupply);
    };
  };
};
