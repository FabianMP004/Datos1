import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import "./ingreso-pago.css"; // Importa los estilos específicos para esta página

interface IngresoPagoProps {
  showMenu: () => void; // Nueva prop para mostrar el menú
}

const IngresoPago: React.FC<IngresoPagoProps> = ({ showMenu }) => {
  const navigate = useNavigate(); // Hook para navegar entre páginas
  const [isModalOpen, setIsModalOpen] = useState(false); // Estado para controlar el modal

  const handleBackToHome = () => {
    showMenu(); // Llama a la función para mostrar el menú
    navigate("/"); // Redirige al inicio
  };

  const [codigoPrestamo, setCodigoPrestamo] = useState("");
  const [codigoTransaccion, setCodigoTransaccion] = useState("");
  const [montoCancelado, setMontoCancelado] = useState("");
  const [prestamoValido, setPrestamoValido] = useState(false); // Nuevo estado para verificar si el préstamo es válido

  const handlePrestamoSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    // Aquí se puede hacer una validación del código de préstamo o una llamada a la API
    if (codigoPrestamo === "1234") {
      // Validación simulada
      setPrestamoValido(true); // Si el código es válido, se muestran los detalles del préstamo
    } else {
      alert("Código de préstamo inválido");
    }
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    // Aquí puedes agregar la lógica para registrar el pago
    alert(
      `Código de préstamo: ${codigoPrestamo}, Código de transacción: ${codigoTransaccion}, Monto cancelado: ${montoCancelado}`
    );
  };

  return (
    <div className="ingreso-pago-container">
      <header>
        <h1>Detalle del Préstamo y Registro de Pago</h1>
      </header>

      {!prestamoValido ? (
        <section className="prestamo-form">
          <h2>Ingresa el Código de Préstamo</h2>
          <form onSubmit={handlePrestamoSubmit}>
            <div className="form-group">
              <label htmlFor="codigo-prestamo">Código de Préstamo:</label>
              <input
                type="text"
                id="codigo-prestamo"
                value={codigoPrestamo}
                onChange={(e) => setCodigoPrestamo(e.target.value)}
                required
              />
            </div>
            <button type="submit">Ver Detalles</button>
          </form>
        </section>
      ) : (
        <>
          <section className="loan-details">
            <h2>Detalles del Préstamo</h2>
            <p>Cuotas faltantes: 3</p>
            <p>Pagos realizados: 2</p>
            <p>Monto del siguiente pago: Q1,200.00 (incluye mora)</p>
          </section>

          <section className="payment-form">
            <h2>Registrar Comprobante de Pago</h2>
            <form onSubmit={handleSubmit}>
              <div className="form-group">
                <label htmlFor="codigo-transaccion">
                  Código de Transacción Bancaria:
                </label>
                <input
                  type="text"
                  id="codigo-transaccion"
                  value={codigoTransaccion}
                  onChange={(e) => setCodigoTransaccion(e.target.value)}
                  required
                />
              </div>
              <div className="form-group">
                <label htmlFor="monto-cancelado">Monto Cancelado:</label>
                <input
                  type="number"
                  id="monto-cancelado"
                  value={montoCancelado}
                  onChange={(e) => setMontoCancelado(e.target.value)}
                  required
                />
              </div>
              <button type="submit">Registrar Pago</button>
            </form>
          </section>
        </>
      )}

      <section className="back-button-section">
        {/* Botón para regresar al index.html */}
        <button onClick={handleBackToHome}>Volver al Inicio</button>
      </section>
    </div>
  );
};

export default IngresoPago;
