module.exports = {
  // 🚀 Ejecutar tests en paralelo
  maxWorkers: '50%',
  
  // 📊 Solo reportes necesarios
  collectCoverageFrom: [
    'src/**/*.{js,jsx,ts,tsx}',
    '!src/**/*.test.{js,jsx,ts,tsx}',
  ],
  
  // ⚡ Cache para tests
  cache: true,
  cacheDirectory: '<rootDir>/.cache/jest',
  
  // 🎯 Solo mostrar fallos en CI
  verbose: process.env.CI ? false : true,
  
  // 🔕 Silenciar warnings innecesarios
  silent: process.env.CI ? true : false,
};