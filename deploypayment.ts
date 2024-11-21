import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import { Contract } from "ethers";

const deployPayment: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = hre.deployments;

  // Aquí establecemos el propietario (owner) que deseamos asignar al contrato
  const ownerAddress = "0xAa430f304A093A807592004260Aa0A99d6F2939E"; // Cambia por la dirección deseada

  await deploy("SubscriptionService", {
    from: deployer,
    args: [ownerAddress], // Pasamos la dirección del propietario al constructor del contrato
    log: true,
    autoMine: true,
  });

  const payment = await hre.ethers.getContract<Contract>("SubscriptionService", deployer);
};

export default deployPayment;

deployPayment.tags = ["SubscriptionService"];
