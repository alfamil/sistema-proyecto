import React, { useState } from 'react';
import { ShieldCheck, Lock, Mail, ArrowRight, UserCheck, AlertCircle } from 'lucide-react';
import { UsuarioSistema } from '../types';

interface LoginModalProps {
  usuarios: UsuarioSistema[];
  onLoginSuccess: (user: UsuarioSistema) => void;
  isOpen: boolean;
}

export const LoginModal: React.FC<LoginModalProps> = ({
  usuarios,
  onLoginSuccess,
  isOpen
}) => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');

  if (!isOpen) return null;

  const handleManualLogin = (e: React.FormEvent) => {
    e.preventDefault();
    setError('');

    const target = usuarios.find(u => u.email.toLowerCase() === email.trim().toLowerCase());
    if (!target) {
      setError('El correo institucional no está registrado.');
      return;
    }

    if (target.clave_demo && password !== target.clave_demo) {
      setError('Contraseña incorrecta. Utilice la clave demo asignada.');
      return;
    }

    onLoginSuccess(target);
  };

  const handleQuickDemoLogin = (user: UsuarioSistema) => {
    onLoginSuccess(user);
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-950/80 backdrop-blur-md p-4 overflow-y-auto animate-in fade-in duration-300">
      <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl shadow-2xl w-full max-w-xl overflow-hidden my-auto">
        
        {/* Brand Banner */}
        <div className="p-8 text-center bg-gradient-to-b from-blue-50 to-white dark:from-slate-800/60 dark:to-slate-900 border-b border-slate-100 dark:border-slate-800">
          <div className="inline-flex items-center justify-center w-16 h-16 rounded-2xl bg-gradient-to-tr from-blue-700 to-indigo-600 text-white shadow-xl shadow-blue-500/20 mb-4">
            <ShieldCheck className="w-9 h-9" />
          </div>
          <h2 className="text-2xl sm:text-3xl font-black text-slate-900 dark:text-white tracking-tight">
            SIGAF • PDVSA INTEVEP
          </h2>
          <p className="text-sm sm:text-base text-slate-600 dark:text-slate-300 mt-1 max-w-md mx-auto font-medium">
            Sistema Integrado de Gestión de Activos Físicos • Gerencia de Ambiente
          </p>
          <div className="flex flex-wrap items-center justify-center gap-2 mt-3">
            <span className="px-2.5 py-0.5 rounded-full text-xs font-bold bg-blue-100 dark:bg-blue-950 text-blue-800 dark:text-blue-300 border border-blue-200 dark:border-blue-800">
              ISO 55001:2024
            </span>
            <span className="px-2.5 py-0.5 rounded-full text-xs font-bold bg-emerald-100 dark:bg-emerald-950 text-emerald-800 dark:text-emerald-300 border border-emerald-200 dark:border-emerald-800">
              ISO 17025 & ISO 10012
            </span>
            <span className="px-2.5 py-0.5 rounded-full text-xs font-bold bg-amber-100 dark:bg-amber-950 text-amber-800 dark:text-amber-300 border border-amber-200 dark:border-amber-800">
              SUDEBIP
            </span>
          </div>
        </div>

        <div className="p-6 sm:p-8 space-y-6">
          
          {error && (
            <div className="p-3.5 bg-rose-50 dark:bg-rose-950/40 border border-rose-200 dark:border-rose-900 rounded-xl text-rose-700 dark:text-rose-300 text-sm flex items-center space-x-2.5 animate-in fade-in">
              <AlertCircle className="w-5 h-5 flex-shrink-0" />
              <span>{error}</span>
            </div>
          )}

          {/* Formulario Estándar */}
          <form onSubmit={handleManualLogin} className="space-y-4">
            <div>
              <label className="block text-xs font-bold uppercase tracking-wider text-slate-600 dark:text-slate-300 mb-1.5">
                Correo Electrónico Corporativo
              </label>
              <div className="relative">
                <Mail className="w-5 h-5 absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400" />
                <input
                  type="email"
                  value={email}
                  onChange={e => setEmail(e.target.value)}
                  placeholder="ejemplo@intevep.pdvsa.com"
                  className="w-full pl-11 pr-4 py-3 rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-blue-500 font-medium text-sm sm:text-base"
                />
              </div>
            </div>

            <div>
              <label className="block text-xs font-bold uppercase tracking-wider text-slate-600 dark:text-slate-300 mb-1.5">
                Contraseña de Acceso
              </label>
              <div className="relative">
                <Lock className="w-5 h-5 absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400" />
                <input
                  type="password"
                  value={password}
                  onChange={e => setPassword(e.target.value)}
                  placeholder="••••••••••••"
                  className="w-full pl-11 pr-4 py-3 rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-blue-500 font-medium text-sm sm:text-base"
                />
              </div>
            </div>

            <button
              type="submit"
              className="w-full py-3.5 bg-blue-600 hover:bg-blue-700 text-white font-extrabold rounded-xl shadow-lg shadow-blue-500/25 transition-all flex items-center justify-center space-x-2 text-base"
            >
              <span>Ingresar al Sistema</span>
              <ArrowRight className="w-5 h-5" />
            </button>
          </form>

          {/* Quick Demo Access Bar */}
          <div className="pt-4 border-t border-slate-200 dark:border-slate-800">
            <div className="flex items-center justify-between mb-3">
              <span className="text-xs font-bold uppercase tracking-wider text-slate-600 dark:text-slate-300">
                ⚡ Acceso Rápido por Perfil (Entorno Demostrativo)
              </span>
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-2 gap-2.5">
              {usuarios.map(u => (
                <button
                  key={u.id}
                  onClick={() => handleQuickDemoLogin(u)}
                  className="p-3 text-left rounded-xl border border-slate-200 dark:border-slate-700 hover:border-blue-500 dark:hover:border-blue-500 bg-slate-50 dark:bg-slate-800/60 hover:bg-blue-50 dark:hover:bg-blue-950/30 transition-all flex items-center justify-between group"
                >
                  <div className="min-w-0 pr-2">
                    <p className="text-xs sm:text-sm font-bold text-slate-900 dark:text-white truncate group-hover:text-blue-600 dark:group-hover:text-blue-400">
                      {u.nombre_completo}
                    </p>
                    <p className="text-[11px] text-slate-600 dark:text-slate-300 truncate">
                      {u.cargo}
                    </p>
                  </div>
                  <span className="text-[10px] font-bold px-2 py-0.5 rounded uppercase tracking-wider bg-white dark:bg-slate-700 text-slate-700 dark:text-slate-200 border border-slate-200 dark:border-slate-600 flex-shrink-0">
                    {u.rol}
                  </span>
                </button>
              ))}
            </div>
          </div>

        </div>

      </div>
    </div>
  );
};
