import React from 'react';
import { 
  LayoutDashboard, FileSpreadsheet, Layers, ShieldCheck, Wrench, 
  CheckCircle2, TrendingDown, Building2, Target, Award, Settings, 
  LogOut, Sun, Moon, ChevronRight, UserCircle
} from 'lucide-react';
import { UsuarioSistema, UserRole, PermisosPorRol } from '../types';

export type ActiveTabType = 
  | 'dashboard' 
  | 'hoja_de_vida' 
  | 'inventario' 
  | 'calibraciones' 
  | 'mantenimiento' 
  | 'comprobaciones' 
  | 'deriva' 
  | 'sudebip' 
  | 'decisiones' 
  | 'gobierno_sga' 
  | 'admin_config';

interface SidebarProps {
  activeTab: ActiveTabType;
  setActiveTab: (tab: ActiveTabType) => void;
  currentUser: UsuarioSistema | null;
  permisos: PermisosPorRol;
  onLogout: () => void;
  darkMode: boolean;
  setDarkMode: (val: boolean) => void;
  alertasCount: number;
}

export const Sidebar: React.FC<SidebarProps> = ({
  activeTab,
  setActiveTab,
  currentUser,
  permisos,
  onLogout,
  darkMode,
  setDarkMode,
  alertasCount
}) => {
  const userRole = (currentUser?.rol || 'analista') as UserRole;
  const userPerms = permisos[userRole] || {};

  const menuSections = [
    {
      title: 'OPERACIÓN & SEGUIMIENTO',
      items: [
        {
          id: 'dashboard',
          label: 'Dashboard & Alertas',
          icon: LayoutDashboard,
          badge: alertasCount > 0 ? alertasCount : null,
          badgeColor: 'bg-rose-500 text-white',
          permKey: 'dashboard'
        },
        {
          id: 'hoja_de_vida',
          label: 'Hoja de Vida Integral',
          subLabel: 'AMB-GEN-SGA-PM-002',
          icon: FileSpreadsheet,
          permKey: 'hoja_de_vida'
        },
        {
          id: 'inventario',
          label: 'Inventario General',
          subLabel: '340 Equipos GAMB',
          icon: Layers,
          permKey: 'inventario'
        }
      ]
    },
    {
      title: 'METROLOGÍA & O&M',
      items: [
        {
          id: 'calibraciones',
          label: 'Calibración & Trazabilidad',
          subLabel: 'ISO 10012 / ISO 17025',
          icon: ShieldCheck,
          permKey: 'calibraciones'
        },
        {
          id: 'mantenimiento',
          label: 'Mantenimiento & OTs',
          subLabel: 'PDVSA MM-02-01-01',
          icon: Wrench,
          permKey: 'mantenimiento'
        },
        {
          id: 'comprobaciones',
          label: 'Comprobaciones Intermedias',
          subLabel: 'ISO 17025 Cl. 6.4.10',
          icon: CheckCircle2,
          permKey: 'comprobaciones'
        },
        {
          id: 'deriva',
          label: 'Control de Deriva (FO-018)',
          subLabel: 'Acción Predictiva Cl. 10.3',
          icon: TrendingDown,
          permKey: 'deriva'
        }
      ]
    },
    {
      title: 'PATRIMONIO & GOBIERNO SGA',
      items: [
        {
          id: 'sudebip',
          label: 'Bienes Públicos SUDEBIP',
          subLabel: 'Depreciación & Actas LOBP',
          icon: Building2,
          permKey: 'sudebip'
        },
        {
          id: 'decisiones',
          label: 'Criticidad & Decisiones',
          subLabel: 'CAPEX / OPEX / Overhaul',
          icon: Target,
          permKey: 'decisiones'
        },
        {
          id: 'gobierno_sga',
          label: 'Gobierno del SGA (Macro)',
          subLabel: 'FO-017 / FO-019 / FO-030',
          icon: Award,
          permKey: 'desempeno_fo017'
        }
      ]
    },
    {
      title: 'CONFIGURACIÓN DEL SISTEMA',
      items: [
        {
          id: 'admin_config',
          label: 'Parámetros & Roles',
          subLabel: 'Catálogos & Matriz RBAC',
          icon: Settings,
          permKey: 'catalogos_admin'
        }
      ]
    }
  ];

  return (
    <aside className="no-print print:hidden w-72 bg-white dark:bg-slate-900 border-r border-slate-200 dark:border-slate-800 flex flex-col h-screen sticky top-0 transition-colors z-40 select-none shadow-sm flex-shrink-0">
      
      {/* Brand Header */}
      <div className="p-5 border-b border-slate-200 dark:border-slate-800 flex items-center justify-between">
        <div className="flex items-center space-x-3">
          <div className="w-10 h-10 rounded-xl bg-gradient-to-tr from-blue-700 to-indigo-600 flex items-center justify-center text-white shadow-md font-black tracking-wider text-lg">
            SGA
          </div>
          <div>
            <div className="flex items-center space-x-1.5">
              <span className="font-extrabold text-base text-slate-900 dark:text-white tracking-tight">SIGAF</span>
              <span className="text-[10px] font-bold px-1.5 py-0.5 rounded bg-blue-100 dark:bg-blue-950 text-blue-800 dark:text-blue-300 border border-blue-200 dark:border-blue-800">
                INTEVEP
              </span>
            </div>
            <p className="text-xs text-slate-500 dark:text-slate-400 font-medium">
              Gerencia de Ambiente
            </p>
          </div>
        </div>

        {/* Theme Toggle Button */}
        <button
          onClick={() => setDarkMode(!darkMode)}
          title={darkMode ? 'Cambiar a Tema Claro' : 'Cambiar a Tema Oscuro'}
          className="p-2 rounded-xl text-slate-500 hover:text-slate-900 dark:text-slate-400 dark:hover:text-white hover:bg-slate-100 dark:hover:bg-slate-800 transition-colors"
        >
          {darkMode ? <Sun className="w-5 h-5 text-amber-400" /> : <Moon className="w-5 h-5" />}
        </button>
      </div>

      {/* Navigation Menu */}
      <div className="flex-1 overflow-y-auto px-3 py-4 space-y-6">
        {menuSections.map((section, sIdx) => {
          // Filter items based on permissions
          const visibleItems = section.items.filter(item => {
            const perm = userPerms[item.permKey];
            return perm ? perm.ver : true;
          });

          if (visibleItems.length === 0) return null;

          return (
            <div key={sIdx} className="space-y-1">
              <h4 className="px-3 text-[11px] font-bold tracking-wider uppercase text-slate-600 dark:text-slate-300">
                {section.title}
              </h4>
              <div className="space-y-1 pt-1">
                {visibleItems.map(item => {
                  const Icon = item.icon;
                  const isActive = activeTab === item.id;

                  return (
                    <button
                      key={item.id}
                      onClick={() => setActiveTab(item.id as ActiveTabType)}
                      className={`w-full flex items-center justify-between px-3 py-2.5 rounded-xl text-left transition-all group ${
                        isActive 
                          ? 'bg-blue-600 text-white font-bold shadow-sm shadow-blue-500/20' 
                          : 'text-slate-700 dark:text-slate-200 hover:bg-slate-100 dark:hover:bg-slate-800/60 font-medium'
                      }`}
                    >
                      <div className="flex items-center space-x-3 min-w-0">
                        <Icon className={`w-5 h-5 flex-shrink-0 ${isActive ? 'text-white' : 'text-slate-600 dark:text-slate-300 group-hover:text-slate-900 dark:group-hover:text-white'}`} />
                        <div className="min-w-0">
                          <p className="text-sm truncate leading-tight">
                            {item.label}
                          </p>
                          {item.subLabel && (
                            <p className={`text-[11px] truncate leading-tight font-normal ${isActive ? 'text-blue-100' : 'text-slate-600 dark:text-slate-300'}`}>
                              {item.subLabel}
                            </p>
                          )}
                        </div>
                      </div>

                      {item.badge !== null && item.badge !== undefined && (
                        <span className={`text-xs px-2 py-0.5 rounded-full font-bold ml-2 flex-shrink-0 ${item.badgeColor || 'bg-slate-200 text-slate-800'}`}>
                          {item.badge}
                        </span>
                      )}
                    </button>
                  );
                })}
              </div>
            </div>
          );
        })}
      </div>

      {/* User Session Footer */}
      <div className="p-4 border-t border-slate-200 dark:border-slate-800 bg-slate-50/70 dark:bg-slate-950/40">
        <div className="flex items-center justify-between">
          <div className="flex items-center space-x-3 min-w-0">
            <div className="w-9 h-9 rounded-full bg-slate-200 dark:bg-slate-800 flex items-center justify-center text-slate-700 dark:text-slate-300 font-bold flex-shrink-0">
              <UserCircle className="w-6 h-6" />
            </div>
            <div className="min-w-0">
              <p className="text-xs font-bold text-slate-900 dark:text-white truncate">
                {currentUser?.nombre_completo || 'Usuario Activo'}
              </p>
              <span className="inline-block px-1.5 py-0.5 rounded text-[10px] font-bold uppercase tracking-wider bg-blue-100 dark:bg-blue-900/60 text-blue-700 dark:text-blue-300 border border-blue-200 dark:border-blue-800">
                {currentUser?.rol || 'analista'}
              </span>
            </div>
          </div>

          <button
            onClick={onLogout}
            title="Cerrar Sesión"
            className="p-2 rounded-xl text-slate-600 hover:text-rose-600 dark:text-slate-300 dark:hover:text-rose-400 hover:bg-rose-50 dark:hover:bg-rose-950/40 transition-colors ml-2 flex-shrink-0"
          >
            <LogOut className="w-4 h-4" />
          </button>
        </div>
      </div>

    </aside>
  );
};

