import React, { useState } from 'react';
import { 
  Settings, Users, Shield, Plus, Edit2, Trash2, CheckCircle2, 
  XCircle, Save, Sliders, Database, Layers, Check, X
} from 'lucide-react';
import { UserRole, PermisosPorRol, PermisoAcceso } from '../types';

interface AdminConfigViewProps {
  catalogos: Record<string, string[]>;
  onUpdateCatalogos: (newCatalogos: Record<string, string[]>) => void;
  permisos: PermisosPorRol;
  onUpdatePermisos: (newPermisos: PermisosPorRol) => void;
}

export const AdminConfigView: React.FC<AdminConfigViewProps> = ({
  catalogos,
  onUpdateCatalogos,
  permisos,
  onUpdatePermisos
}) => {
  const [activeTab, setActiveTab] = useState<'catalogos' | 'permisos'>('catalogos');

  // Catalog State
  const [selectedCategory, setSelectedCategory] = useState<string>(Object.keys(catalogos)[0] || 'laboratorios_unidades');
  const [newItemText, setNewItemText] = useState('');
  const [cats, setCats] = useState<Record<string, string[]>>(catalogos);

  // Permissions State
  const [perms, setPerms] = useState<PermisosPorRol>(permisos);
  const [selectedRole, setSelectedRole] = useState<UserRole>('analista');
  const [isSavedAlert, setIsSavedAlert] = useState(false);

  const categoryLabels: Record<string, string> = {
    laboratorios_unidades: 'Laboratorios y Salas de Ensayo',
    estatus_operativo: 'Estatus Operativos del Activo',
    tipos_mantenimiento: 'Tipos de Mantenimiento PDVSA',
    frecuencias_revision: 'Frecuencias de Calibración / Mantenimiento',
    condicion_fisica_sudebip: 'Condición Física del Bien SUDEBIP',
    catalogo_sudebip_categorias: 'Categorías Catálogo SUDEBIP',
    dictamen_metrologico: 'Dictámenes Metrológicos (ISO 10012)',
    estatus_calibracion: 'Estatus de Calibración',
    tipos_movimiento_sudebip: 'Tipos de Movimiento SUDEBIP'
  };

  const moduleLabels: Record<string, string> = {
    dashboard: '1. Dashboard & Centro de Alertas',
    hoja_de_vida: '2. Hoja de Vida Integral (PM-002)',
    inventario: '3. Inventario General de Activos',
    calibraciones: '4. Calibración & Trazabilidad (ISO 10012)',
    mantenimiento: '5. Mantenimiento & OTs (FO-008)',
    comprobaciones: '6. Comprobaciones Intermedias (ISO 17025)',
    deriva: '7. Control de Deriva Metrológica (FO-018)',
    sudebip: '8. Control Patrimonial SUDEBIP (LOBP)',
    desempeno_fo017: '9. Tablero de 9 KPIs del SGA (FO-017)',
    cierre_brechas_fo030: '10. Cierre de Brechas (FO-030)',
    actas_direccion_fo019: '11. Acuerdos Revisión Dirección (FO-019)',
    decisiones: '12. Matriz de Criticidad & CAPEX/OPEX',
    catalogos_admin: '13. Administración de Parámetros & Listas',
    usuarios_admin: '14. Gestión de Usuarios & Permisos'
  };

  const handleAddItem = (e: React.FormEvent) => {
    e.preventDefault();
    if (!newItemText.trim()) return;

    const currentList = cats[selectedCategory] || [];
    if (currentList.includes(newItemText.trim())) {
      alert('Este elemento ya existe en la lista.');
      return;
    }

    const updated = {
      ...cats,
      [selectedCategory]: [...currentList, newItemText.trim()]
    };
    setCats(updated);
    onUpdateCatalogos(updated);
    setNewItemText('');
  };

  const handleRemoveItem = (item: string) => {
    if (confirm(`¿Eliminar "${item}" de la lista de selección?`)) {
      const currentList = cats[selectedCategory] || [];
      const updated = {
        ...cats,
        [selectedCategory]: currentList.filter(i => i !== item)
      };
      setCats(updated);
      onUpdateCatalogos(updated);
    }
  };

  const handleTogglePerm = (moduleKey: string, permField: keyof PermisoAcceso) => {
    const rolePerms = perms[selectedRole] || {};
    const modPerm = rolePerms[moduleKey] || { ver: false, crear: false, editar: false, eliminar: false };

    const updatedRolePerms = {
      ...rolePerms,
      [moduleKey]: {
        ...modPerm,
        [permField]: !modPerm[permField]
      }
    };

    const updated = {
      ...perms,
      [selectedRole]: updatedRolePerms
    };

    setPerms(updated);
    onUpdatePermisos(updated);
    setIsSavedAlert(true);
    setTimeout(() => setIsSavedAlert(false), 2000);
  };

  return (
    <div className="space-y-6 animate-in fade-in duration-300">
      
      {/* Header Banner */}
      <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-2xl p-6 sm:p-8 shadow-sm flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <div className="flex items-center space-x-2.5 mb-2">
            <span className="p-2 bg-slate-100 dark:bg-slate-800 text-slate-800 dark:text-slate-200 rounded-xl border border-slate-200 dark:border-slate-700">
              <Settings className="w-5 h-5" />
            </span>
            <span className="text-xs sm:text-sm font-bold tracking-wide uppercase text-slate-600 dark:text-slate-400">
              Configuración Maestra del Sistema
            </span>
            <span className="px-2.5 py-0.5 rounded-full text-xs font-semibold bg-blue-50 dark:bg-blue-950 text-blue-700 dark:text-blue-300 border border-blue-200 dark:border-blue-800">
              Solo Administradores
            </span>
          </div>
          <h2 className="text-2xl sm:text-3xl font-black text-slate-900 dark:text-white tracking-tight">
            Gestión de Catálogos y Matriz de Permisos (RBAC)
          </h2>
          <p className="text-sm sm:text-base text-slate-600 dark:text-slate-400 mt-1 max-w-3xl">
            Control dinámico de las listas de selección de todos los formularios (cero código quemado) y asignación granular de qué puede ver, crear, editar o eliminar cada rol.
          </p>
        </div>

        {/* Tab Toggle */}
        <div className="flex bg-slate-100 dark:bg-slate-800 p-1 rounded-xl self-start md:self-auto">
          <button
            onClick={() => setActiveTab('catalogos')}
            className={`px-4 py-2 rounded-lg text-xs sm:text-sm font-bold transition-all ${
              activeTab === 'catalogos' ? 'bg-white dark:bg-slate-900 text-blue-600 dark:text-blue-400 shadow-sm' : 'text-slate-600 dark:text-slate-400'
            }`}
          >
            Listas & Selects Dinámicos
          </button>
          <button
            onClick={() => setActiveTab('permisos')}
            className={`px-4 py-2 rounded-lg text-xs sm:text-sm font-bold transition-all ${
              activeTab === 'permisos' ? 'bg-white dark:bg-slate-900 text-blue-600 dark:text-blue-400 shadow-sm' : 'text-slate-600 dark:text-slate-400'
            }`}
          >
            Matriz de Permisos por Rol
          </button>
        </div>
      </div>

      {/* TAB 1: CATÁLOGOS DINÁMICOS */}
      {activeTab === 'catalogos' && (
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          
          {/* Categories Sidebar */}
          <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl p-5 shadow-sm space-y-2">
            <h3 className="text-xs font-bold uppercase tracking-wider text-slate-500 dark:text-slate-400 px-3 mb-2">
              Seleccionar Catálogo a Modificar
            </h3>
            {Object.keys(cats).map((catKey) => {
              const isSelected = selectedCategory === catKey;
              return (
                <button
                  key={catKey}
                  onClick={() => setSelectedCategory(catKey)}
                  className={`w-full text-left px-3.5 py-3 rounded-xl font-bold text-sm transition-all flex items-center justify-between ${
                    isSelected 
                      ? 'bg-blue-600 text-white shadow-md' 
                      : 'text-slate-700 dark:text-slate-200 hover:bg-slate-100 dark:hover:bg-slate-800'
                  }`}
                >
                  <span className="truncate">{categoryLabels[catKey] || catKey}</span>
                  <span className={`text-xs px-2 py-0.5 rounded-full font-bold ml-2 ${isSelected ? 'bg-white/20 text-white' : 'bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-400'}`}>
                    {(cats[catKey] || []).length}
                  </span>
                </button>
              );
            })}
          </div>

          {/* Items Editor */}
          <div className="lg:col-span-2 bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl p-6 sm:p-8 shadow-sm space-y-6">
            <div className="flex flex-col sm:flex-row justify-between sm:items-center gap-2 border-b border-slate-100 dark:border-slate-800 pb-4">
              <div>
                <h3 className="text-xl font-black text-slate-900 dark:text-white">
                  {categoryLabels[selectedCategory] || selectedCategory}
                </h3>
                <p className="text-xs text-slate-500 dark:text-slate-400">
                  Opciones que aparecen automáticamente en los menús desplegables
                </p>
              </div>
            </div>

            {/* Add New Item Form */}
            <form onSubmit={handleAddItem} className="flex gap-3">
              <input
                type="text"
                value={newItemText}
                onChange={e => setNewItemText(e.target.value)}
                placeholder="Escriba nueva opción para el select..."
                className="flex-1 px-4 py-2.5 rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white text-sm focus:ring-2 focus:ring-blue-500 focus:outline-none"
              />
              <button
                type="submit"
                className="px-5 py-2.5 bg-blue-600 hover:bg-blue-700 text-white font-bold rounded-xl text-sm shadow flex items-center space-x-1.5 whitespace-nowrap"
              >
                <Plus className="w-4 h-4" />
                <span>Añadir Opción</span>
              </button>
            </form>

            {/* Current Items List */}
            <div className="divide-y divide-slate-100 dark:divide-slate-800 border border-slate-200 dark:border-slate-800 rounded-2xl overflow-hidden">
              {(cats[selectedCategory] || []).map((item, index) => (
                <div key={index} className="p-3.5 flex items-center justify-between hover:bg-slate-50 dark:hover:bg-slate-800/40 transition-colors">
                  <span className="font-semibold text-slate-900 dark:text-white text-sm">
                    {item}
                  </span>
                  <button
                    onClick={() => handleRemoveItem(item)}
                    title="Eliminar de la lista"
                    className="p-1.5 rounded-lg text-slate-400 hover:text-rose-600 hover:bg-rose-50 dark:hover:bg-rose-950/40 transition-colors"
                  >
                    <Trash2 className="w-4 h-4" />
                  </button>
                </div>
              ))}
            </div>

          </div>

        </div>
      )}

      {/* TAB 2: MATRIZ DE PERMISOS POR ROL (RBAC) */}
      {activeTab === 'permisos' && (
        <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl p-6 sm:p-8 shadow-sm space-y-6">
          <div className="flex flex-col sm:flex-row justify-between sm:items-center gap-4">
            <div>
              <h3 className="text-xl font-black text-slate-900 dark:text-white">
                Matriz de Control de Acceso Basada en Roles (RBAC)
              </h3>
              <p className="text-xs sm:text-sm text-slate-500 dark:text-slate-400">
                Seleccione el rol institucional y configure qué pantallas puede ver y qué acciones puede ejecutar.
              </p>
            </div>

            {isSavedAlert && (
              <span className="px-3 py-1 bg-emerald-100 dark:bg-emerald-950 text-emerald-800 dark:text-emerald-300 rounded-full text-xs font-bold border border-emerald-300 dark:border-emerald-800 animate-in fade-in">
                ✓ Permisos Actualizados en Vivo
              </span>
            )}
          </div>

          {/* Role Selector Tabs */}
          <div className="grid grid-cols-2 sm:grid-cols-5 gap-2.5">
            {(['admin', 'analista', 'mantenimiento', 'sudebip', 'gerente'] as UserRole[]).map((r) => (
              <button
                key={r}
                onClick={() => setSelectedRole(r)}
                className={`py-3 px-4 rounded-xl font-black text-xs sm:text-sm uppercase tracking-wider transition-all border ${
                  selectedRole === r 
                    ? 'bg-slate-900 text-white dark:bg-blue-600 border-transparent shadow-md' 
                    : 'bg-slate-50 dark:bg-slate-800/60 text-slate-600 dark:text-slate-300 border-slate-200 dark:border-slate-700 hover:border-blue-400'
                }`}
              >
                {r}
              </button>
            ))}
          </div>

          {/* Permissions Table */}
          <div className="overflow-x-auto border border-slate-200 dark:border-slate-800 rounded-2xl">
            <table className="w-full text-left text-sm">
              <thead className="bg-slate-50 dark:bg-slate-800/60 text-slate-700 dark:text-slate-300 font-black uppercase text-xs tracking-wider border-b border-slate-200 dark:border-slate-800">
                <tr>
                  <th className="py-3.5 px-6">Módulo / Pantalla del Sistema</th>
                  <th className="py-3.5 px-4 text-center">Ver 👁️</th>
                  <th className="py-3.5 px-4 text-center">Crear ➕</th>
                  <th className="py-3.5 px-4 text-center">Editar ✏️</th>
                  <th className="py-3.5 px-4 text-center">Eliminar 🗑️</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100 dark:divide-slate-800">
                {Object.keys(moduleLabels).map((modKey) => {
                  const rolePerm = perms[selectedRole]?.[modKey] || { ver: false, crear: false, editar: false, eliminar: false };

                  return (
                    <tr key={modKey} className="hover:bg-slate-50 dark:hover:bg-slate-800/40 transition-colors">
                      <td className="py-3.5 px-6 font-bold text-slate-900 dark:text-white">
                        {moduleLabels[modKey] || modKey}
                      </td>

                      {/* Ver */}
                      <td className="py-3.5 px-4 text-center">
                        <button
                          onClick={() => handleTogglePerm(modKey, 'ver')}
                          className={`w-7 h-7 rounded-lg inline-flex items-center justify-center transition-all ${
                            rolePerm.ver 
                              ? 'bg-blue-600 text-white shadow-sm' 
                              : 'bg-slate-200 dark:bg-slate-700 text-slate-400'
                          }`}
                        >
                          {rolePerm.ver ? <Check className="w-4 h-4 stroke-[3]" /> : <X className="w-4 h-4" />}
                        </button>
                      </td>

                      {/* Crear */}
                      <td className="py-3.5 px-4 text-center">
                        <button
                          onClick={() => handleTogglePerm(modKey, 'crear')}
                          className={`w-7 h-7 rounded-lg inline-flex items-center justify-center transition-all ${
                            rolePerm.crear 
                              ? 'bg-emerald-600 text-white shadow-sm' 
                              : 'bg-slate-200 dark:bg-slate-700 text-slate-400'
                          }`}
                        >
                          {rolePerm.crear ? <Check className="w-4 h-4 stroke-[3]" /> : <X className="w-4 h-4" />}
                        </button>
                      </td>

                      {/* Editar */}
                      <td className="py-3.5 px-4 text-center">
                        <button
                          onClick={() => handleTogglePerm(modKey, 'editar')}
                          className={`w-7 h-7 rounded-lg inline-flex items-center justify-center transition-all ${
                            rolePerm.editar 
                              ? 'bg-amber-600 text-white shadow-sm' 
                              : 'bg-slate-200 dark:bg-slate-700 text-slate-400'
                          }`}
                        >
                          {rolePerm.editar ? <Check className="w-4 h-4 stroke-[3]" /> : <X className="w-4 h-4" />}
                        </button>
                      </td>

                      {/* Eliminar */}
                      <td className="py-3.5 px-4 text-center">
                        <button
                          onClick={() => handleTogglePerm(modKey, 'eliminar')}
                          className={`w-7 h-7 rounded-lg inline-flex items-center justify-center transition-all ${
                            rolePerm.eliminar 
                              ? 'bg-rose-600 text-white shadow-sm' 
                              : 'bg-slate-200 dark:bg-slate-700 text-slate-400'
                          }`}
                        >
                          {rolePerm.eliminar ? <Check className="w-4 h-4 stroke-[3]" /> : <X className="w-4 h-4" />}
                        </button>
                      </td>

                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>

        </div>
      )}

    </div>
  );
};
