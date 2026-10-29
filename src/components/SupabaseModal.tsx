import React, { useState } from 'react';
import { Database, Key, CheckCircle, AlertTriangle, X, Save } from 'lucide-react';
import { supabaseUrl, supabaseAnonKey, isSupabaseConfigured, saveSupabaseConfig, clearSupabaseConfig } from '../lib/supabase';

interface SupabaseModalProps {
  isOpen: boolean;
  onClose: () => void;
}

export const SupabaseModal: React.FC<SupabaseModalProps> = ({ isOpen, onClose }) => {
  const [url, setUrl] = useState(supabaseUrl);
  const [key, setKey] = useState(supabaseAnonKey);

  if (!isOpen) return null;

  const handleSave = (e: React.FormEvent) => {
    e.preventDefault();
    if (!url || !key) {
      alert('Por favor introduce la URL del proyecto y la Anon Key.');
      return;
    }
    saveSupabaseConfig(url, key);
  };

  const handleClear = () => {
    if (confirm('¿Deseas desvincular las credenciales de Supabase y volver a los datos precargados?')) {
      clearSupabaseConfig();
    }
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm p-4">
      <div className="bg-white border border-slate-200 w-full max-w-xl rounded-2xl shadow-2xl overflow-hidden animate-in fade-in zoom-in-95 duration-200">
        
        {/* Header */}
        <div className="px-6 py-5 bg-slate-50 border-b border-slate-200 flex justify-between items-center">
          <div className="flex items-center space-x-3">
            <div className="p-2.5 bg-emerald-100 text-emerald-800 rounded-xl border border-emerald-200">
              <Database className="w-6 h-6" />
            </div>
            <div>
              <h3 className="font-extrabold text-xl text-slate-900">Conexión con Supabase</h3>
              <p className="text-xs sm:text-sm text-slate-500 font-medium">PostgreSQL para ISO 55001 y PDVSA MM-02-01-01</p>
            </div>
          </div>
          <button 
            onClick={onClose}
            className="text-slate-400 hover:text-slate-700 p-2 rounded-lg hover:bg-slate-100 transition-colors"
          >
            <X className="w-6 h-6" />
          </button>
        </div>

        {/* Content */}
        <form onSubmit={handleSave} className="p-6 space-y-5 text-slate-800">
          {/* Status banner */}
          <div className={`p-4 rounded-xl border flex items-start space-x-3 ${
            isSupabaseConfigured 
              ? 'bg-emerald-50 border-emerald-200 text-emerald-900' 
              : 'bg-amber-50 border-amber-200 text-amber-900'
          }`}>
            {isSupabaseConfigured ? (
              <CheckCircle className="w-5 h-5 flex-shrink-0 text-emerald-600 mt-0.5" />
            ) : (
              <AlertTriangle className="w-5 h-5 flex-shrink-0 text-amber-600 mt-0.5" />
            )}
            <div className="text-xs sm:text-sm space-y-1">
              <p className="font-bold text-sm sm:text-base">
                {isSupabaseConfigured ? 'Conectado a Base de Datos Supabase' : 'Modo Datos Locales (Excel AMBI Precargado)'}
              </p>
              <p className="text-slate-600">
                {isSupabaseConfigured 
                  ? 'La aplicación está sincronizando en vivo con tu proyecto PostgreSQL de Supabase.' 
                  : 'Actualmente estás visualizando los 334 activos reales de la herramienta de Excel. Pega tus credenciales de Supabase para almacenar las modificaciones en la nube.'}
              </p>
            </div>
          </div>

          <div className="space-y-4">
            <div>
              <label className="block text-sm font-bold text-slate-800 mb-1.5">
                Project URL de Supabase
              </label>
              <input
                type="url"
                value={url}
                onChange={(e) => setUrl(e.target.value)}
                placeholder="https://xyzcompany.supabase.co"
                className="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-sm sm:text-base text-slate-900 focus:outline-none focus:border-emerald-600 focus:bg-white font-mono"
              />
            </div>

            <div>
              <label className="block text-sm font-bold text-slate-800 mb-1.5 flex items-center">
                <Key className="w-4 h-4 mr-1.5 text-amber-600" />
                Anon / Publishable API Key
              </label>
              <input
                type="password"
                value={key}
                onChange={(e) => setKey(e.target.value)}
                placeholder="sb_publishable_..."
                className="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-sm sm:text-base text-slate-900 focus:outline-none focus:border-emerald-600 focus:bg-white font-mono"
              />
            </div>
          </div>

          <div className="bg-slate-50 p-4 rounded-xl border border-slate-200 text-xs sm:text-sm text-slate-600 space-y-2 font-medium">
            <p className="font-bold text-slate-900">💡 Instrucciones para preparar Supabase:</p>
            <ol className="list-decimal list-inside space-y-1">
              <li>Abre tu proyecto en <a href="https://supabase.com/dashboard" target="_blank" rel="noreferrer" className="text-emerald-700 underline font-semibold">supabase.com</a>.</li>
              <li>Ve a la pestaña <strong>SQL Editor</strong>.</li>
              <li>Pega y ejecuta primero el archivo <code className="text-slate-800 bg-slate-200 px-1 py-0.5 rounded font-mono">supabase_schema.sql</code>.</li>
              <li>Luego pega y ejecuta el archivo <code className="text-slate-800 bg-slate-200 px-1 py-0.5 rounded font-mono">supabase_seed_data.sql</code> para cargar los 334 equipos y 228 códigos SUDEBIP.</li>
            </ol>
          </div>

          {/* Action buttons */}
          <div className="pt-2 flex justify-between items-center">
            {isSupabaseConfigured ? (
              <button
                type="button"
                onClick={handleClear}
                className="text-xs sm:text-sm text-red-600 hover:text-red-800 font-semibold underline"
              >
                Desconectar Supabase
              </button>
            ) : <span />}

            <div className="flex space-x-3">
              <button
                type="button"
                onClick={onClose}
                className="px-5 py-2.5 text-sm sm:text-base bg-slate-100 hover:bg-slate-200 text-slate-700 font-semibold rounded-xl transition-colors"
              >
                Cerrar
              </button>
              <button
                type="submit"
                className="px-6 py-2.5 text-sm sm:text-base bg-emerald-600 hover:bg-emerald-700 text-white font-bold rounded-xl shadow-md flex items-center transition-colors"
              >
                <Save className="w-5 h-5 mr-2" />
                Guardar y Conectar
              </button>
            </div>
          </div>
        </form>

      </div>
    </div>
  );
};
