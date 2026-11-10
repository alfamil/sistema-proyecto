import React, { useState, useEffect } from 'react';
import { Sidebar, ActiveTabType } from './components/Sidebar';
import { LoginModal } from './components/LoginModal';
import { DashboardView } from './components/DashboardView';
import { HojaVidaIntegralView } from './components/HojaVidaIntegralView';
import { InventoryView } from './components/InventoryView';
import { MaintenanceView } from './components/MaintenanceView';
import { StrategicDecisionsView } from './components/StrategicDecisionsView';
import { DerivaMetrologicaView } from './components/DerivaMetrologicaView';
import { SudebipPatrimonioView } from './components/SudebipPatrimonioView';
import { GobiernoSGAView } from './components/GobiernoSGAView';
import { AdminConfigView } from './components/AdminConfigView';
import { AssetFormModal } from './components/AssetFormModal';
import { EvaluationWizardModal } from './components/EvaluationWizardModal';
import { SupabaseModal } from './components/SupabaseModal';
import { 
  ActivoFisico, SudebipItem, HistorialFalla, UserRole, 
  UsuarioSistema, PermisosPorRol, CalibracionMetrologica, 
  MantenimientoPDVSA, ComprobacionIntermedia, DerivaMetrologicaLectura, 
  DepreciacionPatrimonial, ActaMovimientoSudebip, KpiSGA, 
  AcuerdoDireccion, CierreBrecha 
} from './types';
import { supabase, isSupabaseConfigured } from './lib/supabase';
import initialData from '../sga_data.json';
import { Database, Bell, Shield, UserCircle, Trash2 } from 'lucide-react';

export default function App() {
  // Navigation & User State
  const [activeTab, setActiveTab] = useState<ActiveTabType>('dashboard');
  const [targetHojaVidaTag, setTargetHojaVidaTag] = useState<string>('');

  // Dark Mode State
  const [darkMode, setDarkMode] = useState<boolean>(() => {
    return localStorage.getItem('sgaf_theme') === 'dark';
  });

  useEffect(() => {
    if (darkMode) {
      document.documentElement.classList.add('dark');
      localStorage.setItem('sgaf_theme', 'dark');
    } else {
      document.documentElement.classList.remove('dark');
      localStorage.setItem('sgaf_theme', 'light');
    }
  }, [darkMode]);

  // Auth & Session State
  const defaultUser = (initialData as any)?.usuarios?.[0] || {
    id: 'usr-admin-01',
    email: 'admin@intevep.pdvsa.com',
    nombre_completo: 'Ing. Carlos Mendoza (Admin)',
    rol: 'admin',
    cargo: 'Líder de Calidad y Coordinador SGA',
    laboratorio: 'Gerencia de Ambiente (GAMB)'
  };

  const [currentUser, setCurrentUser] = useState<UsuarioSistema | null>(() => {
    const saved = localStorage.getItem('sgaf_user_session');
    if (saved) {
      try {
        return JSON.parse(saved);
      } catch (e) {
        console.error(e);
      }
    }
    return defaultUser;
  });

  const [isLoginModalOpen, setIsLoginModalOpen] = useState(false);

  // Dynamic Catalogs & Permissions
  const [catalogos, setCatalogos] = useState<Record<string, string[]>>(
    (initialData as any)?.catalogos || {}
  );

  const [permisos, setPermisos] = useState<PermisosPorRol>(
    (initialData as any)?.permisos_roles || {}
  );

  // Core Data
  const [activos, setActivos] = useState<ActivoFisico[]>(() => {
    const cached = localStorage.getItem('sgaf_activos_data');
    if (cached) {
      try {
        const parsed = JSON.parse(cached);
        if (Array.isArray(parsed) && parsed.length >= 300) return parsed;
      } catch (e) {
        console.error('Error parsing cached activos', e);
      }
    }
    return (initialData as any)?.activos || [];
  });

  const [catalogoSudebip, setCatalogoSudebip] = useState<SudebipItem[]>(
    (initialData as any)?.catalogo_sudebip || []
  );

  const [calibraciones, setCalibraciones] = useState<CalibracionMetrologica[]>(
    (initialData as any)?.calibraciones || []
  );

  const [mantenimientos, setMantenimientos] = useState<MantenimientoPDVSA[]>(
    (initialData as any)?.mantenimientos || []
  );

  const [comprobaciones, setComprobaciones] = useState<ComprobacionIntermedia[]>(
    (initialData as any)?.comprobaciones || []
  );

  const [depreciaciones, setDepreciaciones] = useState<DepreciacionPatrimonial[]>(
    (initialData as any)?.depreciaciones || []
  );

  const [movimientosSudebip, setMovimientosSudebip] = useState<ActaMovimientoSudebip[]>(
    (initialData as any)?.movimientos_sudebip || []
  );

  const [derivaLecturas, setDerivaLecturas] = useState<DerivaMetrologicaLectura[]>(
    (initialData as any)?.deriva_fo018 || []
  );

  const [kpisSga, setKpisSga] = useState<KpiSGA[]>(
    (initialData as any)?.kpis_sga_fo017 || []
  );

  const [acuerdosDireccion, setAcuerdosDireccion] = useState<AcuerdoDireccion[]>(
    (initialData as any)?.acuerdos_fo019 || []
  );

  const [brechasSga, setBrechasSga] = useState<CierreBrecha[]>(
    (initialData as any)?.brechas_fo030 || []
  );

  // Modals & UI State
  const [selectedActivo, setSelectedActivo] = useState<ActivoFisico | null>(null);
  const [isFormOpen, setIsFormOpen] = useState(false);
  const [isWizardOpen, setIsWizardOpen] = useState(false);
  const [isSupabaseModalOpen, setIsSupabaseModalOpen] = useState(false);

  // Sync with Supabase on start if available
  useEffect(() => {
    if (!isSupabaseConfigured || !supabase) return;

    const fetchSupabaseData = async () => {
      try {
        const { data: actData } = await supabase.from('activos').select('*').limit(350);
        if (actData && actData.length > 0) {
          setActivos(actData);
          localStorage.setItem('sgaf_activos_data', JSON.stringify(actData));
        }

        const { data: calData } = await supabase.from('calibraciones_metrologicas').select('*');
        if (calData && calData.length > 0) setCalibraciones(calData);

        const { data: mantData } = await supabase.from('mantenimientos_pdvsa').select('*');
        if (mantData && mantData.length > 0) setMantenimientos(mantData);

        const { data: ciData } = await supabase.from('comprobaciones_intermedias').select('*');
        if (ciData && ciData.length > 0) setComprobaciones(ciData);

        let { data: kpiData } = await supabase.from('kpis_sga_fo017').select('*');
        if (!kpiData || kpiData.length === 0) {
          const res = await supabase.from('desempeno_sga_fo017').select('*');
          kpiData = res.data;
        }
        if (kpiData && kpiData.length > 0) setKpisSga(kpiData);

        const { data: brechaData } = await supabase.from('cierre_brechas_fo030').select('*');
        if (brechaData && brechaData.length > 0) setBrechasSga(brechaData);
      } catch (err) {
        console.warn('Supabase offline or table missing, using local dataset', err);
      }
    };

    fetchSupabaseData();
  }, []);

  // Handlers
  const handleLoginSuccess = (user: UsuarioSistema) => {
    setCurrentUser(user);
    localStorage.setItem('sgaf_user_session', JSON.stringify(user));
    setIsLoginModalOpen(false);
  };

  const handleLogout = () => {
    setCurrentUser(null);
    localStorage.removeItem('sgaf_user_session');
    setIsLoginModalOpen(true);
  };

  const handleSaveActivo = async (saved: ActivoFisico) => {
    const updated = activos.map(a => a.tag_pdvsa === saved.tag_pdvsa ? saved : a);
    if (!activos.some(a => a.tag_pdvsa === saved.tag_pdvsa)) {
      updated.unshift(saved);
    }
    setActivos(updated);
    localStorage.setItem('sgaf_activos_data', JSON.stringify(updated));
    setIsFormOpen(false);
    setIsWizardOpen(false);

    // Save to Supabase if configured
    if (supabase) {
      try {
        await supabase.from('activos').upsert([saved]);
      } catch (e) {
        console.error('Error syncing asset to Supabase', e);
      }
    }
  };

  const handleGoToHojaVida = (tag: string) => {
    setTargetHojaVidaTag(tag);
    setActiveTab('hoja_de_vida');
  };

  const handlePurgeAllData = () => {
    if (window.confirm('¿Desea depurar y vaciar todos los datos de prueba? Esta acción vaciará el inventario local para dejar el sistema listo para recibir el nuevo archivo oficial.')) {
      localStorage.removeItem('sgaf_activos_data');
      setActivos([]);
      setCalibraciones([]);
      setMantenimientos([]);
      setComprobaciones([]);
      setDepreciaciones([]);
      setMovimientosSudebip([]);
      setDerivaLecturas([]);
      setKpisSga([]);
      setAcuerdosDireccion([]);
      setBrechasSga([]);
      alert('Sistema depurado correctamente. Todos los datos de prueba han sido eliminados.');
    }
  };

  // Calibraciones vencidas count for sidebar badge
  const alertasVencidasCount = calibraciones.filter(c => c.estatus_metrologico === 'VENCIDA' || c.dias_restantes < 0).length;

  return (
    <div className="min-h-screen bg-slate-50 dark:bg-slate-950 text-slate-800 dark:text-slate-100 flex flex-col md:flex-row transition-colors">
      
      {/* 1. SIDEBAR LATERAL IZQUIERDO */}
      <Sidebar
        activeTab={activeTab}
        setActiveTab={setActiveTab}
        currentUser={currentUser}
        permisos={permisos}
        onLogout={handleLogout}
        darkMode={darkMode}
        setDarkMode={setDarkMode}
        alertasCount={alertasVencidasCount}
      />

      {/* 2. CONTENIDO PRINCIPAL */}
      <div className="flex-1 flex flex-col min-w-0 h-screen overflow-y-auto print:h-auto print:overflow-visible">
        
        {/* Top Floating App Bar */}
        <header className="no-print print:hidden bg-white/80 dark:bg-slate-900/80 backdrop-blur-md border-b border-slate-200 dark:border-slate-800 px-6 py-3.5 flex items-center justify-between sticky top-0 z-30 flex-shrink-0">
          <div className="flex items-center space-x-3">
            <span className="font-mono text-xs font-black px-2.5 py-1 rounded-lg bg-blue-50 dark:bg-blue-950 text-blue-700 dark:text-blue-300 border border-blue-200 dark:border-blue-800">
              {currentUser?.laboratorio || 'Gerencia de Ambiente'}
            </span>
          </div>

          <div className="flex items-center space-x-3">
            {/* Supabase Status Button */}
            <button
              onClick={() => setIsSupabaseModalOpen(true)}
              className={`flex items-center space-x-2 text-xs font-bold px-3 py-1.5 rounded-xl border transition-all ${
                isSupabaseConfigured
                  ? 'bg-emerald-50 dark:bg-emerald-950 text-emerald-700 dark:text-emerald-300 border-emerald-300'
                  : 'bg-amber-50 dark:bg-amber-950 text-amber-700 dark:text-amber-300 border-amber-300'
              }`}
            >
              <Database className="w-3.5 h-3.5" />
              <span>{isSupabaseConfigured ? 'Supabase Nube Conectado' : 'Modo Local (Configurar Supabase)'}</span>
            </button>

            {/* User Switch Profile Button */}
            <button
              onClick={() => setIsLoginModalOpen(true)}
              className="flex items-center space-x-1.5 text-xs font-bold text-slate-700 dark:text-slate-300 hover:text-blue-600 dark:hover:text-blue-400 bg-slate-100 dark:bg-slate-800 px-3 py-1.5 rounded-xl border border-slate-200 dark:border-slate-700"
            >
              <UserCircle className="w-4 h-4" />
              <span>Cambiar Perfil</span>
            </button>

            {/* Purge Test Data Button */}
            <button
              onClick={handlePurgeAllData}
              title="Depurar y vaciar datos de prueba locales"
              className="flex items-center space-x-1.5 text-xs font-bold text-rose-700 dark:text-rose-300 hover:text-white hover:bg-rose-600 bg-rose-50 dark:bg-rose-950 px-3 py-1.5 rounded-xl border border-rose-200 dark:border-rose-800 transition-colors"
            >
              <Trash2 className="w-3.5 h-3.5" />
              <span>Vaciar Datos</span>
            </button>
          </div>
        </header>

        {/* Dynamic Screen View */}
        <main className="p-4 sm:p-8 flex-1 max-w-7xl w-full mx-auto">
          
          {/* PANTALLA 1: DASHBOARD & ALERTAS */}
          {activeTab === 'dashboard' && (
            <DashboardView
              activos={activos}
              calibraciones={calibraciones}
              mantenimientos={mantenimientos}
              derivaLecturas={derivaLecturas}
              onSelectActivo={(a) => {
                setSelectedActivo(a);
                setIsFormOpen(true);
              }}
              onGoToHojaVida={handleGoToHojaVida}
              onGoToDecisions={() => setActiveTab('decisiones')}
              onOpenWizard={() => setIsWizardOpen(true)}
            />
          )}

          {/* PANTALLA 2: HOJA DE VIDA INTEGRAL */}
          {activeTab === 'hoja_de_vida' && (
            <HojaVidaIntegralView
              activos={activos}
              calibraciones={calibraciones}
              mantenimientos={mantenimientos}
              comprobaciones={comprobaciones}
              depreciaciones={depreciaciones}
              initialTag={targetHojaVidaTag}
              currentUser={currentUser}
            />
          )}

          {/* PANTALLA 3: INVENTARIO GENERAL */}
          {activeTab === 'inventario' && (
            <InventoryView
              activos={activos}
              onSelectActivo={(a) => {
                setSelectedActivo(a);
                setIsFormOpen(true);
              }}
              onCreateActivo={() => {
                setSelectedActivo(null);
                setIsFormOpen(true);
              }}
              onGoToHojaVida={handleGoToHojaVida}
            />
          )}

          {/* PANTALLA 4: CALIBRACIÓN METROLÓGICA (ISO 10012) */}
          {activeTab === 'calibraciones' && (
            <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl p-6 sm:p-8 shadow-sm space-y-6">
              <div className="flex justify-between items-center border-b border-slate-100 dark:border-slate-800 pb-4">
                <div>
                  <h3 className="text-xl font-black text-slate-900 dark:text-white">
                    Historial de Calibraciones y Trazabilidad Metrológica (ISO 10012)
                  </h3>
                  <p className="text-xs text-slate-500 dark:text-slate-400">
                    Control de certificados, incertidumbre (U), entidad acreditada y error máximo permisible
                  </p>
                </div>
              </div>

              <div className="overflow-x-auto">
                <table className="w-full text-left text-sm">
                  <thead className="bg-slate-50 dark:bg-slate-800/60 text-slate-600 dark:text-slate-300 font-bold uppercase text-[11px] tracking-wider border-b border-slate-200 dark:border-slate-800">
                    <tr>
                      <th className="py-3 px-4">TAG</th>
                      <th className="py-3 px-4">N° Certificado</th>
                      <th className="py-3 px-4">Fecha Calibración</th>
                      <th className="py-3 px-4">Vencimiento</th>
                      <th className="py-3 px-4">Días Restantes</th>
                      <th className="py-3 px-4">Entidad Acreditada</th>
                      <th className="py-3 px-4">Incertidumbre</th>
                      <th className="py-3 px-4">Dictamen</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-slate-100 dark:divide-slate-800">
                    {calibraciones.map((c) => (
                      <tr key={c.id_calibracion} className="hover:bg-slate-50 dark:hover:bg-slate-800/40 transition-colors">
                        <td className="py-3.5 px-4 font-mono font-bold text-blue-600 dark:text-blue-400">{c.tag_pdvsa}</td>
                        <td className="py-3.5 px-4 font-mono font-bold text-slate-900 dark:text-white">{c.nro_certificado}</td>
                        <td className="py-3.5 px-4 font-mono text-xs text-slate-600 dark:text-slate-400">{c.fecha_calibracion}</td>
                        <td className="py-3.5 px-4 font-mono text-xs text-slate-600 dark:text-slate-400">{c.fecha_vencimiento}</td>
                        <td className="py-3.5 px-4 font-mono font-bold">
                          <span className={c.dias_restantes < 0 ? 'text-rose-600' : (c.dias_restantes <= 30 ? 'text-amber-600' : 'text-emerald-600')}>
                            {c.dias_restantes} días
                          </span>
                        </td>
                        <td className="py-3.5 px-4 text-xs text-slate-600 dark:text-slate-400">{c.entidad_acreditada}</td>
                        <td className="py-3.5 px-4 font-mono text-xs text-slate-800 dark:text-slate-200">{c.incertidumbre_u}</td>
                        <td className="py-3.5 px-4">
                          <span className="px-2.5 py-0.5 rounded-full text-xs font-bold bg-emerald-50 text-emerald-700 dark:bg-emerald-950 dark:text-emerald-300 border border-emerald-200">
                            {c.dictamen}
                          </span>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          )}

          {/* PANTALLA 5: MANTENIMIENTO & OTS */}
          {activeTab === 'mantenimiento' && (
            <MaintenanceView
              activos={activos}
              onUpdateActivoFallas={(tag, fallas) => {
                const updated = activos.map(a => a.tag_pdvsa === tag ? { ...a, historial_fallas: fallas } : a);
                setActivos(updated);
                localStorage.setItem('sgaf_activos_data', JSON.stringify(updated));
              }}
            />
          )}

          {/* PANTALLA 6: COMPROBACIONES INTERMEDIAS */}
          {activeTab === 'comprobaciones' && (
            <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl p-6 sm:p-8 shadow-sm space-y-6">
              <div className="flex justify-between items-center border-b border-slate-100 dark:border-slate-800 pb-4">
                <div>
                  <h3 className="text-xl font-black text-slate-900 dark:text-white">
                    Comprobaciones Intermedias de Instrumental (ISO/IEC 17025 Cl. 6.4.10)
                  </h3>
                  <p className="text-xs text-slate-500 dark:text-slate-400">
                    Aseguramiento metrológico periódico contra patrones trazables NIST / SENCAMER
                  </p>
                </div>
              </div>

              <div className="overflow-x-auto">
                <table className="w-full text-left text-sm">
                  <thead className="bg-slate-50 dark:bg-slate-800/60 text-slate-600 dark:text-slate-300 font-bold uppercase text-[11px] tracking-wider border-b border-slate-200 dark:border-slate-800">
                    <tr>
                      <th className="py-3 px-4">ID</th>
                      <th className="py-3 px-4">TAG</th>
                      <th className="py-3 px-4">Fecha</th>
                      <th className="py-3 px-4">Parámetro Verificado</th>
                      <th className="py-3 px-4">Patrón Referencia</th>
                      <th className="py-3 px-4">Rango Aceptable</th>
                      <th className="py-3 px-4">Valor Medido</th>
                      <th className="py-3 px-4">Dictamen</th>
                      <th className="py-3 px-4">Rótulo Operativo</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-slate-100 dark:divide-slate-800">
                    {comprobaciones.map((ci) => (
                      <tr key={ci.id_comprobacion} className="hover:bg-slate-50 dark:hover:bg-slate-800/40 transition-colors">
                        <td className="py-3.5 px-4 font-mono font-bold text-slate-900 dark:text-white">{ci.id_comprobacion}</td>
                        <td className="py-3.5 px-4 font-mono font-bold text-blue-600 dark:text-blue-400">{ci.tag_pdvsa}</td>
                        <td className="py-3.5 px-4 font-mono text-xs text-slate-600 dark:text-slate-400">{ci.fecha_verificacion}</td>
                        <td className="py-3.5 px-4 font-medium text-slate-800 dark:text-slate-200 max-w-xs">{ci.parametro_verificado}</td>
                        <td className="py-3.5 px-4 text-xs text-slate-600 dark:text-slate-400 max-w-xs">{ci.patron_referencia}</td>
                        <td className="py-3.5 px-4 font-mono text-xs text-slate-700 dark:text-slate-300">[{ci.limite_min} - {ci.limite_max}]</td>
                        <td className="py-3.5 px-4 font-mono font-black text-indigo-600 dark:text-indigo-400">{ci.valor_experimental}</td>
                        <td className="py-3.5 px-4">
                          <span className="px-2.5 py-0.5 rounded-full text-xs font-bold bg-emerald-100 text-emerald-800 dark:bg-emerald-950 dark:text-emerald-300 border border-emerald-300">
                            {ci.dictamen_auto}
                          </span>
                        </td>
                        <td className="py-3.5 px-4">
                          <span className="px-2.5 py-0.5 rounded-full text-[11px] font-bold bg-emerald-50 text-emerald-700 dark:bg-emerald-950 dark:text-emerald-300 border border-emerald-200">
                            {ci.rotulado_operativo}
                          </span>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          )}

          {/* PANTALLA 7: CONTROL DE DERIVA (FO-018) */}
          {activeTab === 'deriva' && (
            <DerivaMetrologicaView
              lecturas={derivaLecturas}
              onAddLectura={(newLect) => {
                setDerivaLecturas([...derivaLecturas, newLect]);
              }}
            />
          )}

          {/* PANTALLA 8: BIENES PÚBLICOS SUDEBIP */}
          {activeTab === 'sudebip' && (
            <SudebipPatrimonioView
              depreciaciones={depreciaciones}
              movimientos={movimientosSudebip}
              activos={activos}
              onAddMovimiento={(newMov) => {
                setMovimientosSudebip([newMov, ...movimientosSudebip]);
              }}
            />
          )}

          {/* PANTALLA 9: CRITICIDAD & DECISIONES ESTRATÉGICAS */}
          {activeTab === 'decisiones' && (
            <StrategicDecisionsView
              activos={activos}
              onSelectActivo={(a) => {
                setSelectedActivo(a);
                setIsFormOpen(true);
              }}
              onGoToHojaVida={handleGoToHojaVida}
            />
          )}

          {/* PANTALLA 10: GOBIERNO DEL SGA (MACRO) */}
          {activeTab === 'gobierno_sga' && (
            <GobiernoSGAView
              kpis={kpisSga}
              acuerdos={acuerdosDireccion}
              brechas={brechasSga}
            />
          )}

          {/* PANTALLA 11: CONFIGURACIÓN & ROLES */}
          {activeTab === 'admin_config' && (
            <AdminConfigView
              catalogos={catalogos}
              onUpdateCatalogos={(newCats) => {
                setCatalogos(newCats);
              }}
              permisos={permisos}
              onUpdatePermisos={(newPerms) => {
                setPermisos(newPerms);
              }}
            />
          )}

        </main>
      </div>

      {/* MODAL DE LOGIN */}
      <LoginModal
        usuarios={(initialData as any)?.usuarios || [defaultUser]}
        onLoginSuccess={handleLoginSuccess}
        isOpen={isLoginModalOpen}
      />

      {/* MODAL WIZARD EVALUACIÓN PASO A PASO */}
      {isWizardOpen && (
        <EvaluationWizardModal
          isOpen={isWizardOpen}
          onClose={() => setIsWizardOpen(false)}
          onSave={handleSaveActivo}
          activosDisponibles={activos}
          catalogoSudebip={catalogoSudebip}
        />
      )}

      {/* MODAL FICHA TÉCNICA DEL ACTIVO */}
      {isFormOpen && (
        <AssetFormModal
          activo={selectedActivo}
          catalogoSudebip={catalogoSudebip}
          isOpen={isFormOpen}
          onClose={() => setIsFormOpen(false)}
          onSave={handleSaveActivo}
        />
      )}

      {/* MODAL CONFIGURACIÓN SUPABASE */}
      {isSupabaseModalOpen && (
        <SupabaseModal
          isOpen={isSupabaseModalOpen}
          onClose={() => setIsSupabaseModalOpen(false)}
        />
      )}

    </div>
  );
}
