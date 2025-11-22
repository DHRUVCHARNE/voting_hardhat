import { network } from "hardhat";

const { viem, networkName } = await network.connect();
const client = await viem.getPublicClient();

console.log(`Deploying voting_contract to ${networkName}...`);
console.log(`Client: ${client.account}\n`);
//owner_address 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266
const voting_contract = await viem.deployContract("Voting");

console.log("Contract Address:", voting_contract.address);

console.log("Deployment successful!");