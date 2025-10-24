import React, { useState, useEffect } from 'react';
import ReactDOM from 'react-dom/client';

function App() {
  const [products, setProducts] = useState([]);
  const [orders, setOrders] = useState([]);
  const [status, setStatus] = useState('loading...');

  const API_URL = '/api';

  useEffect(() => {
    fetchProducts();
    checkStatus();
  }, []);

  const checkStatus = async () => {
    try {
      const response = await fetch(`${API_URL}/health`);
      const data = await response.json();
      setStatus(data.status);
    } catch (error) {
      setStatus('error');
    }
  };

  const fetchProducts = async () => {
    try {
      const response = await fetch(`${API_URL}/products`);
      const data = await response.json();
      if (data.success) {
        setProducts(data.data);
      }
    } catch (error) {
      console.error('Error:', error);
    }
  };

  const buyProduct = async (product) => {
    try {
      const orderData = {
        userId: 'user123',
        products: [{ id: product.id, name: product.name, price: product.price }],
        total: product.price
      };

      const response = await fetch(`${API_URL}/orders`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(orderData)
      });

      const data = await response.json();
      if (data.success) {
        setOrders([...orders, data.data]);
        alert(`¡Orden creada! ID: ${data.data.id}`);
      }
    } catch (error) {
      alert('Error al crear orden');
    }
  };

  return (
    <div className="container">
      <div className="status">Backend: {status}</div>
      
      <div className="header">
        <h1>🛍️ DevOps E-commerce</h1>
        <p>Proyecto final - Kubernetes Integration</p>
      </div>

      <div className="products">
        {products.map(product => (
          <div key={product.id} className="product">
            <h3>{product.name}</h3>
            <p>{product.description}</p>
            <div className="price">${product.price}</div>
            <p>Stock: {product.stock}</p>
            <button 
              className="btn"
              onClick={() => buyProduct(product)}
              disabled={product.stock === 0}
            >
              {product.stock > 0 ? 'Comprar' : 'Sin Stock'}
            </button>
          </div>
        ))}
      </div>

      <div style={{marginTop: '40px', background: 'white', padding: '20px', borderRadius: '8px'}}>
        <h3>📊 Órdenes: {orders.length}</h3>
        {orders.slice(-3).map(order => (
          <div key={order.id} style={{padding: '10px', borderBottom: '1px solid #eee'}}>
            Orden #{order.id} - ${order.total}
          </div>
        ))}
      </div>
    </div>
  );
}

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(<App />);