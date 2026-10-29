import React from 'react';
import { 
  Activity, LayoutDashboard, Database, 
  GitFork, Layers, Wrench, ShieldCheck, Sparkles, UserCheck
} from 'lucide-react';
import { isSupabaseConfigured } from '../lib/supabase';
import { UserRole } from '../types';

interface NavbarProps {
  currentTab: 'dashboard' | 'inventory' | 'decisions' | 'maintenance';
  setCurrentTab: (tab: 'dashboard' | 'inventory' | 'decisions' | 'maintenance') => void;
  onOpenSupabaseModal: () => void;
  onOpenWizard: () => void;
  totalActivos: number;
  userRole: UserRole;
  setUserRole: (role: UserRole) => void;
}

export const Navbar: React.FC<NavbarProps> = ({
  currentTab,
  setCurrentTab,
  onOpenSupabaseModal,
  onOpenWizard,
  totalActivos,
  userRole,
  setUserRole
}) => {
  return (
    <header className="bg-white border-b border-slate-200 sticky top-0 z-40 shadow-sm backdrop-blur-md bg-opacity-95">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        
        {/* Upper bar */}
        <div className="py-3.5 flex flex-col md:flex-row md:items-center justify-between border-b border-slate-100 gap-3">
          <div className="flex items-center space-x-3.5">
            <div className="h-11 w-11 rounded-xl bg-gradient-to-tr from-blue-700 via-blue-600 to-indigo-700 flex items-center justify-center shadow-md shadow-blue-500/20 text-white flex-shrink-0">
              <Activity className="w-6 h-6 text-white" />
            </div>
            <div>
              <div className="flex items-center space-x-2 flex-wrap gap-y-1">
                <span className="font-black text-slate-900 text-xl tracking-tight">SGAF</span>
                <span className="px-2.5 py-0.5 rounded text-xs font-bold bg-blue-50 text-blue-800 border border-blue-200">
                  ISO 55001:2024
                </span>
                <span className="px-2.5 py-0.5 rounded text-xs font-bold bg-red-50 text-red-700 border border-red-200">
                  PDVSA MM-02-01-01
                </span>
                <span className="px-2.5 py-0.5 rounded text-xs font-bold bg-emerald-50 text-emerald-800 border border-emerald-200">
                  SUDEBIP
                </span>
              </div>
              <p className="text-xs sm:text-sm text-slate-500 mt-0.5 font-medium">
                Sistema Integrado de Gestión de Activos Físicos | Gerencia de Ambiente - INTEVEP
              </p>
            </div>
          </div>

          <div className="flex items-center space-x-3 self-stretch sm:self-auto justify-between sm:justify-end flex-wrap gap-y-2">
            
            {/* User Role Selector */}
            <div className="flex items-center space-x-2 bg-slate-50 border border-slate-300 rounded-xl px-3 py-1.5 text-xs sm:text-sm">
              <UserCheck className="w-4 h-4 text-blue-600 flex-shrink-0" />
              <div className="flex flex-col">
                <span className="text-[10px] text-slate-400 font-bold uppercase leading-none">Rol de Usuario:</span>
                <select
                  value={userRole}
                  onChange={(e) => setUserRole(e.target.value as UserRole)}
                  className="bg-transparent font-bold text-slate-800 focus:outline-none cursor-pointer text-xs sm:text-sm"
                >
                  <option value="analista">🧑‍🔬 Analista de Laboratorio</option>
                  <option value="gerente">👨‍💼 Gerente de Activos (SAMP)</option>
                  <option value="mantenimiento">🔧 Especialista Mantenimiento</option>
                  <option value="sudebip">🏛️ Custodio SUDEBIP</option>
                </select>
              </div>
            </div>

            {/* Wizard Quick Button */}
            <button
              onClick={onOpenWizard}
              className="flex items-center space-x-1.5 bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-700 hover:to-indigo-700 text-white font-bold px-3.5 py-2 rounded-xl shadow-sm text-xs sm:text-sm transition-all"
              title="Evaluar un activo paso a paso con el asistente guiado"
            >
              <Sparkles className="w-4 h-4 text-amber-300" />
              <span>Evaluar Activo</span>
            </button>

            {/* Supabase status badge button */}
            <button
              onClick={onOpenSupabaseModal}
              className={`flex items-center space-x-2 px-3 py-2 rounded-xl border text-xs sm:text-sm font-semibold transition-all ${
                isSupabaseConfigured
                  ? 'bg-emerald-50 border-emerald-300 text-emerald-800 hover:bg-emerald-100'
                  : 'bg-slate-100 border-slate-300 text-slate-700 hover:bg-slate-200'
              }`}
            >
              <Database className={`w-3.5 h-3.5 ${isSupabaseConfigured ? 'text-emerald-600' : 'text-slate-500'}`} />
              <span className="hidden sm:inline">{isSupabaseConfigured ? 'Supabase' : 'Conectar'}</span>
              <span className={`w-2 h-2 rounded-full ${isSupabaseConfigured ? 'bg-emerald-500 animate-pulse' : 'bg-amber-500'}`} />
            </button>

          </div>
        </div>

        {/* Navigation Tabs - Responsive pill tabs with larger fonts */}
        <div className="flex space-x-2 sm:space-x-3 py-2 overflow-x-auto no-scrollbar">
          <button
            onClick={() => setCurrentTab('dashboard')}
            className={`py-2.5 px-4 font-bold text-sm sm:text-base flex items-center space-x-2 rounded-xl transition-all whitespace-nowrap ${
              currentTab === 'dashboard'
                ? 'bg-blue-600 text-white shadow-sm'
                : 'text-slate-600 hover:text-slate-900 hover:bg-slate-100'
            }`}
          >
            <LayoutDashboard className="w-4 h-4 sm:w-5 sm:h-5" />
            <span>1. Dashboard Ejecutivo</span>
          </button>

          <button
            onClick={() => setCurrentTab('inventory')}
            className={`py-2.5 px-4 font-bold text-sm sm:text-base flex items-center space-x-2 rounded-xl transition-all whitespace-nowrap ${
              currentTab === 'inventory'
                ? 'bg-blue-600 text-white shadow-sm'
                : 'text-slate-600 hover:text-slate-900 hover:bg-slate-100'
            }`}
          >
            <Layers className="w-4 h-4 sm:w-5 sm:h-5" />
            <span>2. Inventario Operativo</span>
          </button>

          <button
            onClick={() => setCurrentTab('decisions')}
            className={`py-2.5 px-4 font-bold text-sm sm:text-base flex items-center space-x-2 rounded-xl transition-all whitespace-nowrap ${
              currentTab === 'decisions'
                ? 'bg-blue-600 text-white shadow-sm'
                : 'text-slate-600 hover:text-slate-900 hover:bg-slate-100'
            }`}
          >
            <GitFork className="w-4 h-4 sm:w-5 sm:h-5" />
            <span>3. Decisiones Estratégicas (SAMP)</span>
          </button>

          <button
            onClick={() => setCurrentTab('maintenance')}
            className={`py-2.5 px-4 font-bold text-sm sm:text-base flex items-center space-x-2 rounded-xl transition-all whitespace-nowrap ${
              currentTab === 'maintenance'
                ? 'bg-blue-600 text-white shadow-sm'
                : 'text-slate-600 hover:text-slate-900 hover:bg-slate-100'
            }`}
          >
            <Wrench className="w-4 h-4 sm:w-5 sm:h-5" />
            <span>4. Mantenimiento & O&M</span>
          </button>
        </div>

      </div>
    </header>
  );
};
