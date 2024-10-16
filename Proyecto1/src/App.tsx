import React, { useState } from "react";
import { BrowserRouter as Router, Route, Routes, Link } from "react-router-dom";
import IngresarPrestamo from "./ingresar-prestamo";
import RevisionPrestamo from "./revision-prestamo";
import ValidacionPago from "./validacion-pago";
import Reportes from "./reportes";
import IngresoPago from "./ingreso-pago";
import Finiquito from "./finiquito";
import "./styles.css"; // Importa los estilos CSS globales

const App: React.FC = () => {
  const [menuVisible, setMenuVisible] = useState(true);

  const handleMenuClick = () => {
    setMenuVisible(false); // Oculta el menú y el header al hacer clic en una opción
  };

  const showMenu = () => {
    setMenuVisible(true); // Función para volver a mostrar el menú y el header
  };

  return (
    <Router>
      <div>
        {/* Condición para mostrar el header solo cuando el menú está visible */}
        {menuVisible && (
          <header>
            <h1>Mi Préstamo S.A.</h1>
          </header>
        )}

        {menuVisible && (
          <section className="welcome-section">
            <h2>Opciones disponibles</h2>
            <p>
              Por favor, selecciona una de las opciones para gestionar los
              préstamos y pagos.
            </p>

            <div className="button-container">
              <Link
                to="/ingresar-prestamo"
                className="btn"
                onClick={handleMenuClick}
              >
                Ingresar Préstamo
              </Link>
              <Link
                to="/revision-prestamo"
                className="btn"
                onClick={handleMenuClick}
              >
                Revisión de Préstamo
              </Link>
              <Link
                to="/ingreso-pago"
                className="btn"
                onClick={handleMenuClick}
              >
                Ingreso de Pago
              </Link>
              <Link
                to="/validacion-pago"
                className="btn"
                onClick={handleMenuClick}
              >
                Validación de Pago
              </Link>
              <Link to="/reportes" className="btn" onClick={handleMenuClick}>
                Reportes
              </Link>
              <Link to="/finiquito" className="btn" onClick={handleMenuClick}>
                Finiquito
              </Link>
            </div>
          </section>
        )}

        <Routes>
          <Route
            path="/ingresar-prestamo"
            element={<IngresarPrestamo showMenu={showMenu} />}
          />
          <Route
            path="/revision-prestamo"
            element={<RevisionPrestamo showMenu={showMenu} />}
          />
          <Route
            path="/ingreso-pago"
            element={<IngresoPago showMenu={showMenu} />}
          />
          <Route
            path="/validacion-pago"
            element={<ValidacionPago showMenu={showMenu} />}
          />
          <Route path="/reportes" element={<Reportes showMenu={showMenu} />} />
          <Route
            path="/finiquito"
            element={<Finiquito showMenu={showMenu} />}
          />
        </Routes>

        <footer>
          <p>© 2024 Mi Préstamo S.A. Todos los derechos reservados.</p>
        </footer>
      </div>
    </Router>
  );
};

export default App;
