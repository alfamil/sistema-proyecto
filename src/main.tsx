import React, { Component, ErrorInfo, ReactNode } from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';
import './index.css';

interface Props {
  children: ReactNode;
}

interface State {
  hasError: boolean;
  error: Error | null;
  errorInfo: ErrorInfo | null;
}

class ErrorBoundary extends Component<Props, State> {
  public state: State = {
    hasError: false,
    error: null,
    errorInfo: null
  };

  public static getDerivedStateFromError(error: Error): State {
    return { hasError: true, error, errorInfo: null };
  }

  public componentDidCatch(error: Error, errorInfo: ErrorInfo) {
    console.error('Uncaught SGAF runtime error:', error, errorInfo);
    this.setState({ errorInfo });
  }

  public render() {
    if (this.state.hasError) {
      return (
        <div style={{ padding: 32, background: '#0f172a', color: '#f8fafc', minHeight: '100vh', fontFamily: 'sans-serif' }}>
          <h1 style={{ color: '#ef4444', fontSize: '24px', fontWeight: 'bold' }}>⚠️ Error en la aplicación SGAF</h1>
          <p style={{ marginTop: 8, color: '#94a3b8' }}>Se ha producido un error al cargar la vista:</p>
          <pre style={{ background: '#1e293b', padding: 16, borderRadius: 8, overflow: 'auto', marginTop: 16, color: '#fca5a5' }}>
            {this.state.error?.toString()}
          </pre>
          <pre style={{ background: '#1e293b', padding: 16, borderRadius: 8, overflow: 'auto', marginTop: 8, color: '#64748b', fontSize: '12px' }}>
            {this.state.errorInfo?.componentStack}
          </pre>
          <button
            onClick={() => { localStorage.clear(); window.location.reload(); }}
            style={{ marginTop: 16, padding: '10px 20px', background: '#2563eb', color: '#fff', border: 'none', borderRadius: 8, cursor: 'pointer', fontWeight: 'bold' }}
          >
            Limpiar caché y recargar
          </button>
        </div>
      );
    }

    return this.props.children;
  }
}

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <ErrorBoundary>
      <App />
    </ErrorBoundary>
  </React.StrictMode>
);
