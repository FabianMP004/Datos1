import React from "react";
import { BrowserRouter as Router, Route, Routes, Link } from "react-router-dom";
import IngresarPrestamo from "./ingresar-prestamo";
import RevisionPrestamo from "./revision-prestamo";
import ValidacionPago from "./validacion-pago";
import Reportes from "./reportes";
import IngresoPago from "./ingreso-pago";
import Finiquito from "./finiquito";
import "./styles.css"; // Importa los estilos CSS globales

const App: React.FC = () => {
  return (
    <Router>
      <div className="app-container">
        {/* Header con el título de la página */}
        <header className="app-header">
          <h1>Mi Préstamo S.A.</h1>
        </header>

        {/* Menú de opciones */}
        <section className="menu-section">
          <div className="menu-container">
            <h2>Opciones disponibles</h2>
            <p>
              Por favor, selecciona una opción para gestionar los préstamos y
              pagos.
            </p>
            <div className="button-container">
              <Link to="/ingresar-prestamo" className="btn">
                Ingresar Préstamo
              </Link>
              <Link to="/revision-prestamo" className="btn">
                Revisión de Préstamo
              </Link>
              <Link to="/ingreso-pago" className="btn">
                Ingreso de Pago
              </Link>
              <Link to="/validacion-pago" className="btn">
                Validación de Pago
              </Link>
              <Link to="/reportes" className="btn">
                Reportes
              </Link>
              <Link to="/finiquito" className="btn">
                Finiquito
              </Link>
            </div>
          </div>
        </section>

        <Routes>
          <Route path="/ingresar-prestamo" element={<IngresarPrestamo showMenu={function (): void {
            throw new Error("Function not implemented.");
          } } />} />
          <Route path="/revision-prestamo" element={<RevisionPrestamo showMenu={function (): void {
            throw new Error("Function not implemented.");
          } } />} />
          <Route path="/ingreso-pago" element={<IngresoPago showMenu={function (): void {
            throw new Error("Function not implemented.");
          } } />} />
          <Route path="/validacion-pago" element={<ValidacionPago showMenu={function (): void {
            throw new Error("Function not implemented.");
          } } />} />
          <Route path="/reportes" element={<Reportes showMenu={function (): void {
            throw new Error("Function not implemented.");
          } } />} />
          <Route path="/finiquito" element={<Finiquito showMenu={function (): void {
            throw new Error("Function not implemented.");
          } } />} />
        </Routes>

        <footer className="app-footer">
          <p>© 2024 Mi Préstamo S.A. Todos los derechos reservados.</p>
        </footer>
      </div>
    </Router>
  );
};

export default App;
