import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import "./reportes.css"; // Asegúrate de que este archivo exista

interface RepostesProps {
  showMenu: () => void; // Nueva prop para mostrar el menú
}

const Reportes: React.FC<RepostesProps> = ({ showMenu }) => {
  const navigate = useNavigate(); // Hook para navegar entre páginas
  const [isModalOpen, setIsModalOpen] = useState(false); // Estado para controlar el modal

  const handleBackToHome = () => {
    showMenu(); // Llama a la función para mostrar el menú
    navigate("/"); // Redirige al inicio
  };

  return (
    <div>
      <header>
        <h1>Generar Reportes</h1>
      </header>

      <section className="report-section">
        <p>Selecciona el tipo de reporte que deseas generar.</p>
        <ul>
          <li>
            <a href="#">Reporte de Préstamos Aprobados</a>
          </li>
          <li>
            <a href="#">Reporte de Préstamos Rechazados</a>
          </li>
          <li>
            <a href="#">Reporte de Préstamos Morosos</a>
          </li>
          <li>
            <a href="#">Reporte General</a>
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

export default Reportes;
