import React, { useState } from "react";
import { Principal } from "@dfinity/principal";
import { eton_token_backend } from "../../declarations/eton_token_backend";

function Balance() {

  const [inputValue, setInputValue] = useState("");
  const [balanceResult, setBalance] = useState("");
  const [tokenSymbol, setSymbol] = useState("");
  const [isHidden, setHidden] = useState(true);

  async function handleClick() {
    // console.log("Balance Button Clicked");
    // console.log(inputValue);
    const principal = Principal.fromText(inputValue);
    const balance = await eton_token_backend.balanceOf(principal);
    const symbol = await eton_token_backend.getSymbol();

    setSymbol(symbol);
    setBalance(balance.toLocaleString());
    setHidden(false);
  }


  return (
    <div className="window white">
      <label>Check account token balance:</label>
      <p>
        <input
          id="balance-principal-id"
          type="text"
          placeholder="Enter a Principal ID"
          value={inputValue}
          onChange={(e) => setInputValue(e.target.value)}
        />
      </p>
      <p className="trade-buttons">
        <button
          id="btn-request-balance"
          onClick={handleClick}
        >
          Check Balance
        </button>
      </p>
      <p hidden={isHidden}>This account has a balance of {balanceResult} {tokenSymbol}.</p>
    </div>
  );
}

export default Balance;
