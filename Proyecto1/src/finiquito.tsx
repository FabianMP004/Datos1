import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import "./finiquito.css"; // Asegúrate de que este archivo exista

interface FiniquitoProps {
  showMenu: () => void; // Nueva prop para mostrar el menú
}

const Finiquito: React.FC<FiniquitoProps> = ({ showMenu }) => {
  const navigate = useNavigate(); // Hook para navegar entre páginas
  const [isModalOpen, setIsModalOpen] = useState(false); // Estado para controlar el modal

  const handleBackToHome = () => {
    showMenu(); // Llama a la función para mostrar el menú
    navigate("/"); // Redirige al inicio
  };

  const [loanId, setLoanId] = useState<number>(1234); // Estado con un ID de préstamo pagado para simular

  const handleRequestFiniquito = () => {
    // Lógica para generar la carta de finiquito
    console.log(`Solicitud de finiquito para el préstamo #${loanId}`);
    // Aquí puedes generar el PDF de la carta de finiquito con los datos del préstamo
    // También podrías hacer una petición al backend para generar la carta
  };

  return (
    <div>
      <header>
        <h1>Solicitud de Finiquito</h1>
      </header>

      <section className="finiquito-section">
        <p>
          Tu préstamo ha sido cancelado en su totalidad. Puedes solicitar tu
          finiquito.
        </p>

        {/* Botón para solicitar el finiquito */}
        <button onClick={handleRequestFiniquito}>Solicitar Finiquito</button>
      </section>

      <section className="back-button-section">
        {/* Botón para regresar al index.html */}
        <button onClick={handleBackToHome}>Volver al Inicio</button>
      </section>
    </div>
  );
};

export default Finiquito;
