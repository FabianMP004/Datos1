import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import "./validacion-pago.css"; // Asegúrate de que este archivo exista

interface ValidacionPagoProps {
  showMenu: () => void; // Nueva prop para mostrar el menú
}

const ValidacionPago: React.FC<ValidacionPagoProps> = ({ showMenu }) => {
  const navigate = useNavigate(); // Hook para navegar entre páginas
  const [isModalOpen, setIsModalOpen] = useState(false); // Estado para controlar el modal

  const handleBackToHome = () => {
    showMenu(); // Llama a la función para mostrar el menú
    navigate("/"); // Redirige al inicio
  };

  const handleApprove = (paymentId: number) => {
    // Lógica para aprobar el pago
    console.log(`Pago de Préstamo #${paymentId} aprobado`);
  };

  const handleReject = (paymentId: number) => {
    // Lógica para rechazar el pago
    console.log(`Pago de Préstamo #${paymentId} rechazado`);
  };

  return (
    <div>
      <header>
        <h1>Validación de Pago</h1>
      </header>

      <section className="validation-section">
        <p>Valida los comprobantes de pago enviados por los clientes.</p>
        {/* Simulación de lista de pagos pendientes de validación */}
        <ul>
          <li>
            Pago de Préstamo #1234 - Q500.00
            <button onClick={() => handleApprove(1234)}>Aprobar</button>
            <button onClick={() => handleReject(1234)}>Rechazar</button>
          </li>
          <li>
            Pago de Préstamo #5678 - Q200.00
            <button onClick={() => handleApprove(5678)}>Aprobar</button>
            <button onClick={() => handleReject(5678)}>Rechazar</button>
          </li>
        </ul>
      </section>

      <section className="back-button-section">
        {/* Botón para regresar al index.html */}
        <button onClick={handleBackToHome}>Volver al Inicio</button>
      </section>
    </div>
  );
};

export default ValidacionPago;
