// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SubscriptionService {
    // Dirección del propietario del contrato
    address public owner;
    
    // Precio de la suscripción (en wei)
    uint256 public subscriptionPrice = 50000 wei;

    // Duración de la suscripción (30 días)
    uint256 public subscriptionDuration = 30 days;

    // Información de suscripción por dirección de usuario
    mapping(address => uint256) public subscriptions;

    // Evento para notificar cuando un usuario se suscribe
    event Subscribed(address indexed user, uint256 expiryDate);

    // Constructor
    constructor(address _owner) {
        owner = _owner; // El propietario del contrato es quien lo despliega
    }

    // Función para suscribirse
    function subscribe() external payable {
        require(msg.value == subscriptionPrice, "Debe enviar exactamente el precio de la suscripcion");
        
        if (subscriptions[msg.sender] < block.timestamp) {
            // Si la suscripción ha expirado o nunca existió, establecer una nueva fecha de vencimiento
            subscriptions[msg.sender] = block.timestamp + subscriptionDuration;
        } else {
            // Si la suscripción aún está activa, extender la fecha de vencimiento
            subscriptions[msg.sender] += subscriptionDuration;
        }

        emit Subscribed(msg.sender, subscriptions[msg.sender]);
    }

    // Función para verificar si una cuenta tiene una suscripción activa
    function isSubscribed(address _user) public view returns (bool) {
        return subscriptions[_user] > block.timestamp;
    }

    // Función para retirar los fondos acumulados
    function withdraw() external {
        require(msg.sender == owner, "Solo el propietario puede retirar fondos");
        payable(owner).transfer(address(this).balance);
    }

    // Función para cambiar el precio de la suscripción
    function setSubscriptionPrice(uint256 _newPrice) external {
        require(msg.sender == owner, "Solo el propietario puede cambiar el precio");
        subscriptionPrice = _newPrice;
    }

    // Función para cambiar la duración de la suscripción
    function setSubscriptionDuration(uint256 _newDuration) external {
        require(msg.sender == owner, "Solo el propietario puede cambiar la duracion");
        subscriptionDuration = _newDuration;
    }
}
