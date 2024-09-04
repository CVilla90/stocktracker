// Rails\portfolio\portfolio-frontend\src\App.js

import React, { useState, useEffect } from 'react';
import './App.css';

function App() {
  const [stocks, setStocks] = useState([]);
  const [loading, setLoading] = useState(true);
  const [currentTime, setCurrentTime] = useState(new Date());
  const [showPortfolioSection, setShowPortfolioSection] = useState(false);
  const [showPortfolioForm, setShowPortfolioForm] = useState(false);
  const [portfolioName, setPortfolioName] = useState('');
  const [selectedStocks, setSelectedStocks] = useState({});
  const [portfolios, setPortfolios] = useState([]);
  const [selectedPortfolio, setSelectedPortfolio] = useState(null);
  const [portfolioData, setPortfolioData] = useState(null);

  useEffect(() => {
    fetch('http://localhost:3000/api/stocks')
      .then((response) => response.json())
      .then((data) => {
        setStocks(data);
        setLoading(false);
      })
      .catch((error) => {
        console.error('Error fetching stocks:', error);
        setLoading(false);
      });

    fetch('http://localhost:3000/api/investment_portfolios')
      .then((response) => response.json())
      .then((data) => setPortfolios(data))
      .catch((error) => console.error('Error fetching portfolios:', error));

    const timer = setInterval(() => setCurrentTime(new Date()), 1000);
    return () => clearInterval(timer);
  }, []);

  const handleCreatePortfolio = (e) => {
    e.preventDefault();
    const newPortfolio = {
      name: portfolioName,
      stocks: Object.entries(selectedStocks)
        .filter(([id, { quantity }]) => quantity > 0)
        .map(([id, { quantity }]) => ({
          stock_id: parseInt(id, 10),
          quantity: parseInt(quantity, 10),
        })),
    };

    console.log('Creating portfolio with data:', newPortfolio);

    fetch('http://localhost:3000/api/investment_portfolios', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(newPortfolio),
    })
      .then((response) => response.json())
      .then((data) => {
        console.log('Portfolio created:', data);
        setPortfolios([...portfolios, data]);
        setPortfolioName('');
        setSelectedStocks({});
        setShowPortfolioForm(false);
      })
      .catch((error) => console.error('Error creating portfolio:', error));
  };

  const handleStockChange = (stockId, field, value) => {
    setSelectedStocks((prevSelectedStocks) => ({
      ...prevSelectedStocks,
      [stockId]: {
        ...prevSelectedStocks[stockId],
        [field]: isNaN(value) ? 0 : value,
      },
    }));
  };

  const handlePortfolioChange = (e) => {
    const portfolioId = e.target.value;
    if (portfolioId === 'default') {
      setSelectedPortfolio(null);
      setPortfolioData(null);
    } else {
      setSelectedPortfolio(portfolioId);
      setLoading(true);
      fetch(`http://localhost:3000/api/investment_portfolios/${portfolioId}`)
        .then((response) => response.json())
        .then((data) => {
          const { totals } = data;
          totals.added_price = Number(totals.added_price || 0);
          totals.current_price = Number(totals.current_price || 0);
          totals.profit_or_loss = Number(totals.profit_or_loss || 0);
          totals.annualized_return = calculateWeightedAnnualizedReturn(data.stocks);
          setPortfolioData(data);
          setLoading(false);
        })
        .catch((error) => {
          console.error('Error fetching portfolio data:', error);
          setLoading(false);
        });
    }
  };

  const calculateWeightedAnnualizedReturn = (stocks) => {
    const totalValue = stocks.reduce((acc, stock) => acc + stock.current_price * stock.quantity, 0);
    if (totalValue === 0) return 0; // Avoid division by zero
    const weightedAnnualizedReturn = stocks.reduce((acc, stock) => {
      const weight = (stock.current_price * stock.quantity) / totalValue;
      return acc + weight * stock.annualized_return;
    }, 0);
    return (weightedAnnualizedReturn * 100).toFixed(2); // Return as a percentage
  };

  const handleDeletePortfolio = (portfolioId) => {
    if (!window.confirm("Are you sure you want to delete this portfolio?")) return;

    fetch(`http://localhost:3000/api/investment_portfolios/${portfolioId}`, {
      method: 'DELETE',
    })
      .then((response) => {
        if (response.ok) {
          setPortfolios(portfolios.filter(p => p.id !== portfolioId));
          setSelectedPortfolio(null);
          setPortfolioData(null);
        } else {
          console.error('Error deleting portfolio:', response.statusText);
        }
      })
      .catch((error) => console.error('Error deleting portfolio:', error));
  };

  if (loading) {
    return (
      <div className="App">
        <p>Loading...</p>
      </div>
    );
  }

  const totals = portfolioData?.totals || {
    quantity: 0,
    added_price: 0,
    current_price: 0,
    profit_or_loss: 0,
    annualized_return: 0,
  };

  const totalAddedPrice = Number(totals.added_price);
  const totalCurrentPrice = Number(totals.current_price);
  const totalProfitOrLoss = Number(totals.profit_or_loss);
  const totalAnnualizedReturn = totals.annualized_return;

  return (
    <div className="App">
      <header className="App-header">
        <h1>Stock Tracker</h1>
        <p className="simulation-note">
          Simulación basada en precios ficticios. Los precios reales no se usan debido a las limitaciones de la API gratuita.
        </p>
        <div className="clock">
          {currentTime.toLocaleDateString()} {currentTime.toLocaleTimeString()}
        </div>
        <div
          className="my-portfolios-button"
          onClick={() => setShowPortfolioSection(!showPortfolioSection)}
        >
          My Portfolios
        </div>
        {showPortfolioSection && (
          <div className="portfolio-section">
            <button
              className="create-portfolio-button"
              onClick={() => setShowPortfolioForm(!showPortfolioForm)}
            >
              Create Portfolio
            </button>

            {showPortfolioForm && (
              <form className="portfolio-form" onSubmit={handleCreatePortfolio}>
                <h2>Crear Nuevo Portafolio</h2>
                <label>
                  Nombre del Portafolio:
                  <input
                    type="text"
                    value={portfolioName}
                    onChange={(e) => setPortfolioName(e.target.value)}
                    required
                  />
                </label>
                <h3>Selecciona Stocks:</h3>
                {stocks.map((stock) => (
                  <div key={stock.id} className="stock-selection">
                    <label>
                      {stock.name}
                      <input
                        type="number"
                        min="0"
                        placeholder="Cantidad"
                        value={selectedStocks[stock.id]?.quantity || 0}
                        onChange={(e) => handleStockChange(stock.id, 'quantity', parseInt(e.target.value, 10))}
                      />
                    </label>
                  </div>
                ))}
                <button type="submit">Crear Portafolio</button>
              </form>
            )}

            <div className="portfolio-dropdown">
              <select
                onChange={handlePortfolioChange}
                value={selectedPortfolio || 'default'}
              >
                <option value="default">Select a Portfolio</option>
                {portfolios.map((portfolio) => (
                  <option key={portfolio.id} value={portfolio.id}>
                    {portfolio.name}
                  </option>
                ))}
              </select>
            </div>

            {selectedPortfolio && portfolioData ? (
              <div className="portfolio-details">
                <h2>
                  Portafolio: {portfolioData.name}
                  <button 
                    className="delete-portfolio-button" 
                    onClick={() => handleDeletePortfolio(portfolioData.id)}
                  >
                    Delete Portfolio
                  </button>
                </h2>
                {portfolioData.stocks && portfolioData.stocks.length > 0 ? (
                  <table>
                    <thead>
                      <tr>
                        <th>Stock Name</th>
                        <th>Quantity</th>
                        <th>Added Price</th>
                        <th>Current Price</th>
                        <th>Profit/Loss</th>
                        <th>Annualized Return</th>
                      </tr>
                    </thead>
                    <tbody>
                      {portfolioData.stocks.map((stock) => {
                        const quantity = stock.quantity || 0;
                        const addedPrice = parseFloat(stock.added_price) || 0;
                        const currentPrice = parseFloat(stock.current_price) || 0;
                        const totalCurrentPrice = currentPrice * quantity;
                        const totalAddedPrice = addedPrice * quantity;
                        const profitOrLoss = totalCurrentPrice - totalAddedPrice;
                        const annualizedReturn = stock.annualized_return * 100;

                        return (
                          <tr key={stock.id}>
                            <td>{stock.name}</td>
                            <td>{quantity}</td>
                            <td>${totalAddedPrice.toFixed(2)}</td>
                            <td>${totalCurrentPrice.toFixed(2)}</td>
                            <td className={profitOrLoss > 0 ? 'profit' : profitOrLoss < 0 ? 'loss' : 'neutral'}>
                              ${profitOrLoss.toFixed(2)}
                            </td>
                            <td>{annualizedReturn.toFixed(2)}%</td>
                          </tr>
                        );
                      })}
                      <tr className="totals-row">
                        <td>Total</td>
                        <td>{totals.quantity}</td>
                        <td>${totalAddedPrice.toFixed(2)}</td>
                        <td>${totalCurrentPrice.toFixed(2)}</td>
                        <td className={totalProfitOrLoss > 0 ? 'profit' : totalProfitOrLoss < 0 ? 'loss' : 'neutral'}>
                          ${totalProfitOrLoss.toFixed(2)}
                        </td>
                        <td>{totalAnnualizedReturn}%</td> {/* Total Annualized Return */}
                      </tr>
                    </tbody>
                  </table>
                ) : (
                  <p>No stocks in this portfolio.</p>
                )}
              </div>
            ) : (
              <p>Selecciona un portafolio para ver los detalles.</p>
            )}
          </div>
        )}

        {selectedPortfolio === null && (
          <table>
            <thead>
              <tr>
                <th>Stock Name</th>
                <th>Current Price</th>
              </tr>
            </thead>
            <tbody>
              {stocks.map((stock) => (
                <tr key={stock.id}>
                  <td>{stock.name}</td>
                  <td>${stock.price}</td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </header>
    </div>
  );
}

export default App;
