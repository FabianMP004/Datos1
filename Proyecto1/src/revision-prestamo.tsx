import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import "./revision-prestamo.css"; // Asegúrate de que este archivo exista

interface Loan {
  id: number;
  cliente: string;
  monto: number;
  tasaInteres?: number;
  iva?: number;
  costosAdmin?: number;
  aprobado?: boolean;
  codigoPrestamo?: string;
  cuotas?: Array<{
    fechaPago: string;
    montoPago: number;
    capital: number;
    interes: number;
    iva: number;
  }>;
}

interface RevisionPrestamoProps {
  showMenu: () => void; // Nueva prop para mostrar el menú
}

const RevisionPrestamo: React.FC<RevisionPrestamoProps> = ({ showMenu }) => {
  const navigate = useNavigate(); // Hook para navegar entre páginas
  const [isModalOpen, setIsModalOpen] = useState(false); // Estado para controlar el modal

  const handleBackToHome = () => {
    showMenu(); // Llama a la función para mostrar el menú
    navigate("/"); // Redirige al inicio
  };

  const [loans, setLoans] = useState<Loan[]>([
    { id: 1234, cliente: "Juan Pérez", monto: 5000 },
    { id: 5678, cliente: "María Gómez", monto: 2000 },
  ]);
  const [loanDetails, setLoanDetails] = useState<Loan | null>(null); // Estado para manejar los detalles del préstamo actual
  const [formValues, setFormValues] = useState({
    tasaInteres: 0,
    iva: 0,
    costosAdmin: 0,
    cantidadPagos: 12, // Cantidad de pagos por defecto
  });

  const handleApprove = (loan: Loan) => {
    // Generar código único para el préstamo aprobado
    const codigoPrestamo = `PRST-${loan.id}-${new Date().getTime()}`;

    // Calcular cuotas
    const cuotas = calcularCuotas(
      loan.monto,
      formValues.tasaInteres,
      formValues.iva,
      formValues.costosAdmin,
      formValues.cantidadPagos
    );

    // Actualizar el estado del préstamo con la aprobación y las cuotas
    setLoans((prevLoans) =>
      prevLoans.map((l) =>
        l.id === loan.id
          ? {
              ...l,
              aprobado: true,
              tasaInteres: formValues.tasaInteres,
              iva: formValues.iva,
              costosAdmin: formValues.costosAdmin,
              codigoPrestamo,
              cuotas,
            }
          : l
      )
    );

    // Limpiar detalles del préstamo actual
    setLoanDetails(null);

    console.log(`Préstamo #${loan.id} aprobado. Código: ${codigoPrestamo}`);
  };

  const handleDeny = (loanId: number) => {
    // Actualizar el estado del préstamo como denegado
    setLoans((prevLoans) =>
      prevLoans.map((loan) =>
        loan.id === loanId ? { ...loan, aprobado: false } : loan
      )
    );
    console.log(`Préstamo #${loanId} denegado`);
  };

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setFormValues((prevValues) => ({
      ...prevValues,
      [name]: parseFloat(value),
    }));
  };

  const calcularCuotas = (
    monto: number,
    tasaInteres: number,
    iva: number,
    costosAdmin: number,
    meses: number
  ) => {
    const cuotas = [];
    const interesMensual = tasaInteres / 100 / 12;
    const montoConInteres = monto * (1 + interesMensual);
    const montoPorMes = montoConInteres / meses;

    const fechaActual = new Date();
    for (let i = 1; i <= meses; i++) {
      fechaActual.setMonth(fechaActual.getMonth() + 1); // Aumentar el mes
      const fechaPago = fechaActual.toISOString().slice(0, 10); // Formato de fecha "YYYY-MM-DD"

      const cuota = {
        fechaPago,
        montoPago: montoPorMes + costosAdmin / meses + iva,
        capital: montoPorMes,
        interes: interesMensual * monto,
        iva,
      };
      cuotas.push(cuota);
    }
    return cuotas;
  };

  return (
    <div>
      <header>
        <h1>Revisión de Préstamo</h1>
      </header>

      <section className="review-section">
        <p>
          Los analistas revisan los préstamos y deciden la tasa de interés y los
          términos.
        </p>

        {/* Lista de préstamos pendientes de revisión */}
        <ul>
          {loans.map((loan) => (
            <li key={loan.id}>
              Préstamo #{loan.id} - Cliente: {loan.cliente} - Monto: Q
              {loan.monto.toFixed(2)}
              {loan.aprobado ? (
                <span> - Aprobado (Código: {loan.codigoPrestamo})</span>
              ) : (
                <div>
                  <button onClick={() => setLoanDetails(loan)}>Revisar</button>
                  <button onClick={() => handleDeny(loan.id)}>Denegar</button>
                </div>
              )}
            </li>
          ))}
        </ul>
      </section>

      {loanDetails && (
        <div className="loan-details">
          <h2>Detalles del Préstamo #{loanDetails.id}</h2>
          <p>Cliente: {loanDetails.cliente}</p>
          <p>Monto del préstamo: Q{loanDetails.monto.toFixed(2)}</p>

          <h3>Establecer términos del préstamo:</h3>
          <form>
            <div className="form-group">
              <label htmlFor="tasaInteres">Tasa de Interés (%):</label>
              <input
                type="number"
                id="tasaInteres"
                name="tasaInteres"
                value={formValues.tasaInteres}
                onChange={handleInputChange}
              />
            </div>
            <div className="form-group">
              <label htmlFor="iva">IVA (%):</label>
              <input
                type="number"
                id="iva"
                name="iva"
                value={formValues.iva}
                onChange={handleInputChange}
              />
            </div>
            <div className="form-group">
              <label htmlFor="costosAdmin">Costos Administrativos:</label>
              <input
                type="number"
                id="costosAdmin"
                name="costosAdmin"
                value={formValues.costosAdmin}
                onChange={handleInputChange}
              />
            </div>
            <div className="form-group">
              <label htmlFor="cantidadPagos">Cantidad de Pagos (Meses):</label>
              <input
                type="number"
                id="cantidadPagos"
                name="cantidadPagos"
                value={formValues.cantidadPagos}
                onChange={handleInputChange}
              />
            </div>

            <button type="button" onClick={() => handleApprove(loanDetails)}>
              Aprobar Préstamo
            </button>
          </form>
        </div>
      )}

      <section className="back-button-section">
        {/* Botón para regresar al index.html */}
        <button onClick={handleBackToHome}>Volver al Inicio</button>
      </section>
    </div>
  );
};

export default RevisionPrestamo;
