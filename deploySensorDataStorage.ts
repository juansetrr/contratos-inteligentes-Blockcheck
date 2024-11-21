import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import { Contract } from "ethers";

const deploySensorDataStorage: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = hre.deployments;

  // Dirección del propietario deseado del contrato
  const ownerAddress = "0xAa430f304A093A807592004260Aa0A99d6F2939E"; // Cambiar por la dirección deseada

  await deploy("SensorDataStorage", {
    from: deployer,
    args: [ownerAddress],
    log: true,
    autoMine: true,
  });

  // Obtenemos el contrato desplegado
  const deployment = await hre.deployments.get("SensorDataStorage");
  const { address } = deployment;

  // Obtenemos el proveedor (provider) y el Signer utilizando async/await
  const ethers = hre.ethers;
  const provider = ethers.provider!;
  const signer = await provider.getSigner(deployer);

  // Conectamos al contrato desplegado usando el Signer obtenido
  const contract = new Contract(address, deployment.abi, signer);

  // Transferimos la propiedad al propietario especificado
  await contract.transferOwnership(ownerAddress);

  console.log(`Contract deployed at address: ${address}`);
  console.log(`Ownership transferred to: ${ownerAddress}`);
};

export default deploySensorDataStorage;

// Etiquetas (tags) para identificar el contrato en el despliegue
deploySensorDataStorage.tags = ["SensorDataStorage"];
