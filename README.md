# Voting Contract — Hardhat3 Project

> Simple on-chain voting contract (Solidity 0.8.20) with Solidity tests and a TypeScript Hardhat deploy script.

---

## Project overview

This repository contains a small voting smart contract `contracts/Voting.sol` and a set of unit tests written in Solidity (`tests/Voting.t.sol`) . A TypeScript deploy script (`scripts/deploy.ts`) shows how to deploy the contract using Hardhat's scripting environment and Viem client.

The contract lets the owner add candidates, allows any address to vote for **one** candidate, and exposes helper views such as `getCandidates()` and `getWinner()`.

### Key behaviours

* Only the contract owner (deployer) can add candidates.
* Each address can vote **only once**.
* `getWinner()` returns the candidate with the highest votes. In case of a tie, the **first** candidate with the max votes is returned.
* The contract uses custom errors for gas-efficient reverts: `RestrictedToOwner`, `YouHaveAlreadyVoted`, `InvalidCandidateIndex`, `NoCandidates`.

---

## Repo layout

```
contracts/
  Voting.sol           # The voting contract
  Voting.t.sol         # Solidity tests
scripts/
  deploy.ts            # Hardhat/viem TypeScript deploy script
README.md

package.json / pnpm-lock.yaml (or yarn.lock)
```

---

## Prerequisites

* Node.js (v20+ recommended)
* pnpm or npm/yarn (npm used frequently in this project)
* Hardhat (installed as a devDependency)

Optional but useful:

* Anvil (from Foundry) or Hardhat node for local deployment/testing
* `ts-node` / `typescript` to run TypeScript scripts if not using `npx hardhat run`

---

## Quick start

1. Install Node dependencies

```bash
# or using npm
npm install
```

2. Start a local dev node

* Using npx hardhat node

```bash
npx hardhat node
```

4. Compile

```bash
# Hardhat compile (TypeScript/JS/solidity)
npx hardhat compile
```

5. Run tests

* Solidity tests (the test file `Voting.t.sol` is a Solidity test):

```bash
npx hardhat test

```

* If you want get coverage of Solidity tests, run:

```bash
npx hardhat test --coverage
```

6. Deploy locally (example)

```bash
# deploy to a hardhat local node  using Hardhat script
npx hardhat run scripts/deploy.ts --network localhost
```

> The supplied `scripts/deploy.ts` uses Hardhat's `network.connect()`/Viem client. If you run into TypeScript runtime issues, you can invoke the script using Hardhat's runner (`npx hardhat run`) which handles the environment and TypeScript compilation.

---

## Contract API (summary)

**Errors**

* `RestrictedToOwner()` — revert when non-owner tries to add a candidate
* `YouHaveAlreadyVoted()` — revert if an address tries to vote more than once
* `InvalidCandidateIndex()` — revert when voting with an index outside `candidates` range
* `NoCandidates()` — revert when querying winner with zero candidates

**Events**

* `CandidateAdded(string indexed c_name, uint indexed c_index)` — emitted when a candidate is added
* `VoteCastTo(uint indexed v_index)` — emitted when a vote is cast to candidate index

**Functions**

* `constructor()` — sets `i_owner` to the deployer
* `addCandidate(string)` — `onlyOwner` adds a candidate (emits `CandidateAdded`)
* `vote(uint index)` — cast a single vote (emits `VoteCastTo`), reverts on invalid index or double-vote
* `getCandidates()` — returns `Candidate[]` array with `{ name, votes }`
* `getWinner()` — returns the name of the winning candidate (tie: first highest wins)

---

## Example interaction (web3.js)

```js
- Interact with the deployed contract using web3.js is used in voting_backend project. written in Express.js, using web3js to connect to the deployed Voting contract.
```

---

## Notes, caveats & suggestions

* **Tie-breaking**: current `getWinner()` returns the **first** candidate encountered with the highest vote count. If you want deterministic tie-breaking (e.g., based on timestamp, random seed, or lexicographic order), implement and test that logic explicitly.
* **Gas & storage**: `getCandidates()` returns the full `Candidate[]` which is fine for small candidate lists. For many candidates, consider pagination or separate getters to reduce gas & ABI payload size.
* **Access control**: owner-only `addCandidate` is enforced by `onlyOwner()` modifier. If you expect the owner to renounce ownership or transfer it, add that functionality.
* **Testing**: the repository includes Foundry tests demonstrating typical behaviors and edge cases (owner restrictions, invalid index, double-vote, tie behavior).

---

## Troubleshooting

* If your deployment script prints the **same** contract address repeatedly on a local node, remember that some local dev nodes (Hardhat network anvil) use deterministic account nonces which can produce repeatable addresses if you reset the chain — this is expected for ephemeral test networks. Restarting the node with fresh state or using a different private key will produce different addresses.

* If TypeScript/Hardhat scripts error with top-level `await` or `viem` API missing, use `npx hardhat run ...` which sets up the runtime environment, or ensure your Node version supports top-level await and that Hardhat plugins (viem integration) are correctly configured in `hardhat.config.ts`.

---


## License

MIT

---

