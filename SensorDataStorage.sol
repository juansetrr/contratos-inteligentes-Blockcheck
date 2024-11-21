// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SensorDataStorage {
    // Estructura para almacenar los datos de temperatura y humedad
    struct SensorData {
        uint256 timestamp; // Timestamp del registro (en segundos desde el epoch)
        uint8 temperature; // Temperatura en grados Celsius (0-255, representado como un byte)
        uint8 humidity;    // Humedad relativa en porcentaje (0-100, representado como un byte)
    }

    // Mapeo para almacenar los datos de sensores por transacción hash
    mapping(bytes32 => SensorData) public sensorDataRecords;

    // Evento para notificar cuando se registra un nuevo dato
    event SensorDataRecorded(bytes32 indexed txHash, uint256 timestamp, uint8 temperature, uint8 humidity);

    // Función para registrar datos de sensor
    function recordSensorData(uint8 _temperature, uint8 _humidity) external {
        // Generar una clave única basada en el hash de la transacción
        bytes32 txHash = keccak256(abi.encodePacked(msg.sender, block.timestamp, block.number));

        // Almacenar los datos en la blockchain
        sensorDataRecords[txHash] = SensorData(block.timestamp, _temperature, _humidity);

        // Emitir evento de registro de datos
        emit SensorDataRecorded(txHash, block.timestamp, _temperature, _humidity);
    }

    // Función para recuperar los datos de sensor dado un hash de transacción
    function getSensorData(bytes32 _txHash) external view returns (uint256 timestamp, uint8 temperature, uint8 humidity) {
        SensorData memory sensorData = sensorDataRecords[_txHash];
        return (sensorData.timestamp, sensorData.temperature, sensorData.humidity);
    }
}
