import reactLogo from './assets/react.svg'
import viteLogo from '/vite.svg'
import './App.css'

function App() {

  return (
    <>
      <div>
        <a href="https://vite.dev" target="_blank">
          <img src={viteLogo} className="logo" alt="Vite logo" />
        </a>
        <a href="https://react.dev" target="_blank">
          <img src={reactLogo} className="logo react" alt="React logo" />
        </a>
      </div>
      <h1>Despliegue con ansible y vagrant. Desafio completado</h1>
      <p className="read-the-docs">
        #90DiasDevops - Semana 1 dia 6
      </p>
    </>
  )
}

export default App
