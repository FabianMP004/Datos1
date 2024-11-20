import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import "./ingresar-prestamo.css";

interface IngresarPrestamoProps {
  showMenu: () => void; // Nueva prop para mostrar el menú
}

const IngresarPrestamo: React.FC<IngresarPrestamoProps> = ({ showMenu }) => {
  const navigate = useNavigate(); // Hook para navegar entre páginas
  const [isModalOpen, setIsModalOpen] = useState(false); // Estado para controlar el modal

  const handleSubmit = (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    navigate("/revision-prestamo");
    setIsModalOpen(false);
  };

  const handleBackToHome = () => { 
    showMenu();
    navigate("/"); 
  };

  return (
    <div>
      <header>
        <h1>Ingresar Préstamo</h1>
      </header>

      <section className="form-section">
        {/* Botón para abrir el modal */}
        <button onClick={() => setIsModalOpen(true)}>Ingresar Préstamo</button>
      </section>

      {/* Modal para ingresar datos del préstamo */}
      {isModalOpen && (
        <div className="modal-overlay">
          <div className="modal-content">
            <h2>Formulario de Datos del Cliente</h2>

            <form onSubmit={handleSubmit}>
              <div className="form-group">
                <label htmlFor="first-name">Primer Nombre:</label>
                <input type="text" id="first-name" name="first-name" required />
              </div>
              <div className="form-group">
                <label htmlFor="second-name">Segundo Nombre:</label>
                <input type="text" id="second-name" name="second-name" />
              </div>
              <div className="form-group">
                <label htmlFor="third-name">Tercer Nombre:</label>
                <input type="text" id="third-name" name="third-name" />
              </div>
              <div className="form-group">
                <label htmlFor="last-name">Primer Apellido:</label>
                <input type="text" id="last-name" name="last-name" required />
              </div>
              <div className="form-group">
                <label htmlFor="second-last-name">Segundo Apellido:</label>
                <input
                  type="text"
                  id="second-last-name"
                  name="second-last-name"
                  required
                />
              </div>
              <div className="form-group">
                <label htmlFor="married-last-name">Apellido de Casada:</label>
                <input
                  type="text"
                  id="married-last-name"
                  name="married-last-name"
                />
              </div>
              <div className="form-group">
                <label htmlFor="gender">Género:</label>
                <select id="gender" name="gender" required>
                  <option value="">Seleccionar</option>
                  <option value="masculino">Masculino</option>
                  <option value="femenino">Femenino</option>
                  <option value="otro">Otro</option>
                </select>
              </div>
              <div className="form-group">
                <label htmlFor="cui">CUI:</label>
                <input type="text" id="cui" name="cui" required />
              </div>
              <div className="form-group">
                <label htmlFor="dob">Fecha de Nacimiento:</label>
                <input type="date" id="dob" name="dob" required />
              </div>
              <div className="form-group">
                <label htmlFor="dpi-expiry">
                  Fecha de Vencimiento del DPI:
                </label>
                <input type="date" id="dpi-expiry" name="dpi-expiry" required />
              </div>

              {/* Referencias personales */}
              <h3>Referencias Personales</h3>
              <div className="form-group">
                <label htmlFor="personal-ref-1">Referencia Personal 1:</label>
                <input
                  type="text"
                  id="personal-ref-1"
                  name="personal-ref-1"
                  required
                />
              </div>
              <div className="form-group">
                <label htmlFor="personal-ref-2">Referencia Personal 2:</label>
                <input
                  type="text"
                  id="personal-ref-2"
                  name="personal-ref-2"
                  required
                />
              </div>

              {/* Referencias laborales */}
              <h3>Referencias Laborales</h3>
              <div className="form-group">
                <label htmlFor="work-ref-1">Referencia Laboral 1:</label>
                <input type="text" id="work-ref-1" name="work-ref-1" required />
              </div>
              <div className="form-group">
                <label htmlFor="work-ref-2">Referencia Laboral 2:</label>
                <input type="text" id="work-ref-2" name="work-ref-2" required />
              </div>

              <button type="submit">Registrar Préstamo</button>
              <button type="button" onClick={() => setIsModalOpen(false)}>
                Cerrar
              </button>
            </form>
          </div>
        </div>
      )}

      <section className="back-button-section">
        {/* Botón para regresar al index.html */}
        <button onClick={handleBackToHome}>Volver al Inicio</button>
      </section>
    </div>
  );
};

export default IngresarPrestamo;
