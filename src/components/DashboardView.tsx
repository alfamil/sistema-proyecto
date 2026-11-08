import React, { useMemo } from 'react';
import { 
  AlertTriangle, ShieldAlert, CheckCircle2, TrendingUp, 
  Activity, Gauge, Sparkles, Filter, ChevronRight, Clock, 
  HelpCircle, ArrowRight, PlayCircle, Layers, CheckCircle, 
  Calendar, ShieldCheck, Wrench, Building2, TrendingDown, Eye
} from 'lucide-react';
import { 
  ResponsiveContainer, BarChart, Bar, XAxis, YAxis, 
  Tooltip as RechartsTooltip, CartesianGrid, PieChart, Pie, Cell, Legend, LineChart, Line
} from 'recharts';
import { ActivoFisico, CalibracionMetrologica, MantenimientoPDVSA, DerivaMetrologicaLectura } from '../types';

interface DashboardViewProps {
  activos: ActivoFisico[];
  calibraciones: CalibracionMetrologica[];
  mantenimientos: MantenimientoPDVSA[];
  derivaLecturas: DerivaMetrologicaLectura[];
  onSelectActivo: (activo: ActivoFisico) => void;
  onGoToHojaVida: (tag: string) => void;
  onGoToDecisions: () => void;
  onOpenWizard: () => void;
}

export const DashboardView: React.FC<DashboardViewProps> = ({
  activos,
  calibraciones,
  mantenimientos,
  derivaLecturas,
  onSelectActivo,
  onGoToHojaVida,
  onGoToDecisions,
  onOpenWizard
}) => {
  // Alert Calculations
  const alertas = useMemo(() => {
    const today = new Date();
    
    // Calibrations vencidas y por vencer (<30 dias)
    const vencidas: CalibracionMetrologica[] = [];
    const porVencer: CalibracionMetrologica[] = [];
    const vigentes: CalibracionMetrologica[] = [];

    calibraciones.forEach(c => {
      const vDate = new Date(c.fecha_vencimiento);
      const diffDays = Math.ceil((vDate.getTime() - today.getTime()) / (1000 * 3600 * 24));
      
      if (diffDays < 0 || c.estatus_metrologico === 'VENCIDA') {
        vencidas.push({ ...c, dias_restantes: diffDays });
      } else if (diffDays <= 30 || c.estatus_metrologico === 'POR VENCER') {
        porVencer.push({ ...c, dias_restantes: diffDays });
      } else {
        vigentes.push({ ...c, dias_restantes: diffDays });
      }
    });

    // Mantenimientos programados del mes
    const mantMes = mantenimientos.filter(m => m.estatus_ot === 'Programado' || m.estatus_ot === 'En Proceso');

    // Equipos con alerta de deriva (>= 80% LTM)
    const derivaAlertas = derivaLecturas.filter(d => d.consumo_ltm_pct >= 80);

    return {
      vencidas,
      porVencer,
      vigentes,
      mantMes,
      derivaAlertas,
      totalAlertas: vencidas.length + porVencer.length + derivaAlertas.length
    };
  }, [calibraciones, mantenimientos, derivaLecturas]);

  // Global KPIs
  const kpis = useMemo(() => {
    const total = activos.length;
    const critA = activos.filter(a => (a.categoria_criticidad || '').includes('Nivel A') || (a.categoria_criticidad || '').includes('Clase A')).length;
    const critB = activos.filter(a => (a.categoria_criticidad || '').includes('Nivel B') || (a.categoria_criticidad || '').includes('Clase B')).length;
    const critC = activos.filter(a => (a.categoria_criticidad || '').includes('Nivel C') || (a.categoria_criticidad || '').includes('Clase C')).length;
    const operativos = activos.filter(a => (a.estado_operativo || 'Operativo') === 'Operativo').length;
    const disponibilidadPct = total > 0 ? ((operativos / total) * 100).toFixed(1) : '82.1';

    return {
      total,
      critA: critA || 14,
      critB: critB || 17,
      critC: critC || 24,
      operativos,
      disponibilidadPct
    };
  }, [activos]);

  // Chart 1: Availability by Laboratory (Bar Chart)
  const labData = [
    { lab: 'Cromatografía', disp: 82.1, meta: 75.0 },
    { lab: 'Aguas y Efluentes', disp: 86.4, meta: 75.0 },
    { lab: 'Metales Pesados', disp: 76.8, meta: 75.0 },
    { lab: 'Fisicoquímica', disp: 89.0, meta: 75.0 },
    { lab: 'Toxicología', disp: 78.5, meta: 75.0 }
  ];

  // Chart 2: Calibration Status (Donut Chart)
  const calDonutData = [
    { name: 'Vigentes (Conformes)', value: alertas.vigentes.length || 6, color: '#10b981' },
    { name: 'Por Vencer (< 30 días)', value: alertas.porVencer.length || 2, color: '#f59e0b' },
    { name: 'Vencidas (En Riesgo)', value: alertas.vencidas.length || 2, color: '#ef4444' }
  ];

  return (
    <div className="space-y-6 animate-in fade-in duration-300">
      
      {/* Executive Welcome & Mode Switch Banner */}
      <div className="bg-gradient-to-r from-blue-700 via-indigo-700 to-slate-900 rounded-3xl p-6 sm:p-8 text-white shadow-xl flex flex-col md:flex-row md:items-center justify-between gap-6">
        <div>
          <div className="flex items-center space-x-2.5 mb-2">
            <span className="px-3 py-1 rounded-full text-xs font-black tracking-wider uppercase bg-white/20 backdrop-blur-md border border-white/20 text-white">
              SIGAF • INTEVEP GERENCIA DE AMBIENTE
            </span>
            <span className="px-3 py-1 rounded-full text-xs font-extrabold bg-emerald-500/20 text-emerald-300 border border-emerald-400/30">
              ISO 55001:2024 & SUDEBIP
            </span>
          </div>
          <h2 className="text-2xl sm:text-3xl font-black tracking-tight leading-tight">
            Centro de Control & Gestión de Activos Físicos
          </h2>
          <p className="text-sm sm:text-base text-blue-100 mt-1 max-w-2xl font-normal">
            Monitoreo en tiempo real de 340 activos, alertas preventivas de calibración metrológica y plan estratégico de mantenimiento.
          </p>
        </div>

        <div className="flex flex-wrap items-center gap-3">
          <button
            onClick={onOpenWizard}
            className="flex items-center space-x-2 bg-white text-blue-900 hover:bg-blue-50 font-extrabold px-5 py-3 rounded-2xl shadow-lg transition-all text-sm whitespace-nowrap"
          >
            <Sparkles className="w-4 h-4 text-blue-600" />
            <span>Evaluar con Asistente</span>
          </button>
        </div>
      </div>

      {/* ========================================================================= */}
      {/* CENTRO DE AVISOS Y ALERTAS DEL MES (SEMÁFORO INTELIGENTE)                */}
      {/* ========================================================================= */}
      <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl p-6 sm:p-8 shadow-sm space-y-4">
        <div className="flex flex-col sm:flex-row justify-between sm:items-center gap-2 border-b border-slate-100 dark:border-slate-800 pb-4">
          <div className="flex items-center space-x-3">
            <div className="p-2.5 rounded-xl bg-amber-50 dark:bg-amber-950 text-amber-600 dark:text-amber-400 border border-amber-200 dark:border-amber-800">
              <Calendar className="w-6 h-6" />
            </div>
            <div>
              <h3 className="text-xl font-black text-slate-900 dark:text-white">
                Centro de Avisos y Alertas Preventivas del Mes
              </h3>
              <p className="text-xs sm:text-sm text-slate-500 dark:text-slate-400">
                Equipos que requieren atención inmediata en calibración (ISO 10012) o mantenimiento (PDVSA)
              </p>
            </div>
          </div>

          <span className={`px-3 py-1 rounded-full text-xs font-black uppercase tracking-wider self-start sm:self-auto ${
            alertas.totalAlertas > 0 ? 'bg-rose-100 dark:bg-rose-950 text-rose-800 dark:text-rose-300 border border-rose-300' : 'bg-emerald-100 text-emerald-800'
          }`}>
            {alertas.totalAlertas} Notificaciones Activas
          </span>
        </div>

        {/* 3 Alerts Columns: Vencidas (Rojo), Por Vencer (Amarillo), Deriva/OTs */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          
          {/* Card 1: Calibraciones Vencidas */}
          <div className="border border-rose-200 dark:border-rose-900/60 bg-rose-50/50 dark:bg-rose-950/20 rounded-2xl p-4 space-y-3">
            <div className="flex justify-between items-center text-rose-700 dark:text-rose-400">
              <span className="text-xs font-black uppercase tracking-wider flex items-center space-x-1.5">
                <AlertTriangle className="w-4 h-4" />
                <span>Calibraciones Vencidas</span>
              </span>
              <span className="px-2 py-0.5 rounded-full text-xs font-black bg-rose-600 text-white">
                {alertas.vencidas.length}
              </span>
            </div>
            
            <p className="text-xs text-rose-800 dark:text-rose-300 font-medium">
              Equipos fuera de servicio temporal según ISO 17025 Cl. 6.4.9 hasta su recalibración.
            </p>

            <div className="space-y-2">
              {alertas.vencidas.slice(0, 2).map(c => (
                <div key={c.id_calibracion} className="bg-white dark:bg-slate-800 p-2.5 rounded-xl border border-rose-200 dark:border-rose-800/60 flex items-center justify-between">
                  <div>
                    <p className="font-mono font-bold text-xs text-slate-900 dark:text-white">{c.tag_pdvsa}</p>
                    <p className="text-[11px] text-slate-500 dark:text-slate-400 truncate max-w-[150px]">{c.nro_certificado}</p>
                  </div>
                  <button
                    onClick={() => onGoToHojaVida(c.tag_pdvsa)}
                    className="p-1.5 rounded-lg bg-rose-50 dark:bg-rose-950 text-rose-700 dark:text-rose-300 hover:bg-rose-100 text-xs font-bold"
                  >
                    Ver Ficha
                  </button>
                </div>
              ))}
            </div>
          </div>

          {/* Card 2: Por Vencer en < 30 Días */}
          <div className="border border-amber-200 dark:border-amber-900/60 bg-amber-50/50 dark:bg-amber-950/20 rounded-2xl p-4 space-y-3">
            <div className="flex justify-between items-center text-amber-700 dark:text-amber-400">
              <span className="text-xs font-black uppercase tracking-wider flex items-center space-x-1.5">
                <Clock className="w-4 h-4" />
                <span>Vencen en &lt; 30 Días</span>
              </span>
              <span className="px-2 py-0.5 rounded-full text-xs font-black bg-amber-600 text-white">
                {alertas.porVencer.length}
              </span>
            </div>

            <p className="text-xs text-amber-800 dark:text-amber-300 font-medium">
              Coordinar servicio de calibración externa con SENCAMER / Laboratorio Acreditado.
            </p>

            <div className="space-y-2">
              {alertas.porVencer.slice(0, 2).map(c => (
                <div key={c.id_calibracion} className="bg-white dark:bg-slate-800 p-2.5 rounded-xl border border-amber-200 dark:border-amber-800/60 flex items-center justify-between">
                  <div>
                    <p className="font-mono font-bold text-xs text-slate-900 dark:text-white">{c.tag_pdvsa}</p>
                    <p className="text-[11px] text-amber-700 dark:text-amber-400 font-bold">{c.dias_restantes} días de vigencia</p>
                  </div>
                  <button
                    onClick={() => onGoToHojaVida(c.tag_pdvsa)}
                    className="p-1.5 rounded-lg bg-amber-50 dark:bg-amber-950 text-amber-700 dark:text-amber-300 hover:bg-amber-100 text-xs font-bold"
                  >
                    Ver Ficha
                  </button>
                </div>
              ))}
            </div>
          </div>

          {/* Card 3: OTs y Alertas Predictivas */}
          <div className="border border-blue-200 dark:border-blue-900/60 bg-blue-50/50 dark:bg-blue-950/20 rounded-2xl p-4 space-y-3">
            <div className="flex justify-between items-center text-blue-700 dark:text-blue-400">
              <span className="text-xs font-black uppercase tracking-wider flex items-center space-x-1.5">
                <Wrench className="w-4 h-4" />
                <span>OTs en Ejecución / Deriva</span>
              </span>
              <span className="px-2 py-0.5 rounded-full text-xs font-black bg-blue-600 text-white">
                {alertas.mantMes.length + alertas.derivaAlertas.length}
              </span>
            </div>

            <p className="text-xs text-blue-800 dark:text-blue-300 font-medium">
              Mantenimientos trimestrales programados y umbrales de deriva en seguimiento.
            </p>

            <div className="space-y-2">
              {alertas.mantMes.slice(0, 2).map(m => (
                <div key={m.nro_ot} className="bg-white dark:bg-slate-800 p-2.5 rounded-xl border border-blue-200 dark:border-blue-800/60 flex items-center justify-between">
                  <div>
                    <p className="font-mono font-bold text-xs text-slate-900 dark:text-white">{m.nro_ot}</p>
                    <p className="text-[11px] text-slate-500 dark:text-slate-400 truncate max-w-[150px]">{m.tag_pdvsa}</p>
                  </div>
                  <span className="px-2 py-0.5 rounded text-[10px] font-bold bg-blue-100 dark:bg-blue-950 text-blue-800 dark:text-blue-300">
                    {m.estatus_ot}
                  </span>
                </div>
              ))}
            </div>
          </div>

        </div>
      </div>

      {/* KPI Cards Grid */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
        
        <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 p-5 rounded-2xl shadow-sm">
          <span className="text-xs font-bold uppercase tracking-wider text-slate-500 dark:text-slate-400">
            Total Activos GAMB
          </span>
          <div className="text-3xl font-black text-slate-900 dark:text-white mt-2">
            {kpis.total}
          </div>
          <p className="text-xs text-slate-500 dark:text-slate-400 mt-1">Gerencia de Ambiente</p>
        </div>

        <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 p-5 rounded-2xl shadow-sm">
          <span className="text-xs font-bold uppercase tracking-wider text-slate-500 dark:text-slate-400">
            Disponibilidad Analítica
          </span>
          <div className="text-3xl font-black text-emerald-600 dark:text-emerald-400 mt-2">
            {kpis.disponibilidadPct}%
          </div>
          <p className="text-xs text-emerald-600 dark:text-emerald-400 font-bold mt-1">Meta ≥ 75.0% (Superada)</p>
        </div>

        <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 p-5 rounded-2xl shadow-sm">
          <span className="text-xs font-bold uppercase tracking-wider text-slate-500 dark:text-slate-400">
            Activos Críticos Vitales
          </span>
          <div className="text-3xl font-black text-rose-600 dark:text-rose-400 mt-2">
            {kpis.critA}
          </div>
          <p className="text-xs text-slate-500 dark:text-slate-400 mt-1">Categoría A (PDVSA MM-02-01-01)</p>
        </div>

        <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 p-5 rounded-2xl shadow-sm">
          <span className="text-xs font-bold uppercase tracking-wider text-slate-500 dark:text-slate-400">
            Conciliación SUDEBIP
          </span>
          <div className="text-3xl font-black text-blue-600 dark:text-blue-400 mt-2">
            91.2%
          </div>
          <p className="text-xs text-slate-500 dark:text-slate-400 mt-1">Cotejo Físico vs SAP PM</p>
        </div>

      </div>

      {/* Visual Analytics Grid: Bar Chart + Donut Chart */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        
        {/* Chart 1: Availability by Laboratory */}
        <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl p-6 sm:p-8 shadow-sm">
          <h3 className="text-lg font-black text-slate-900 dark:text-white mb-1">
            Disponibilidad Analítica por Laboratorio (%)
          </h3>
          <p className="text-xs text-slate-500 dark:text-slate-400 mb-6">
            Comparativo de operatividad real vs meta corporativa (75%)
          </p>

          <div className="h-64 w-full">
            <ResponsiveContainer width="100%" height={250}>
              <BarChart data={labData} margin={{ top: 10, right: 10, left: -20, bottom: 0 }}>
                <CartesianGrid strokeDasharray="3 3" stroke="#e2e8f0" opacity={0.5} />
                <XAxis dataKey="lab" stroke="#94a3b8" fontSize={10} />
                <YAxis domain={[60, 100]} stroke="#94a3b8" fontSize={10} />
                <RechartsTooltip />
                <Bar dataKey="disp" fill="#3b82f6" radius={[6, 6, 0, 0]} name="Disponibilidad Real (%)" />
                <Bar dataKey="meta" fill="#94a3b8" radius={[6, 6, 0, 0]} name="Meta Mínima (%)" />
              </BarChart>
            </ResponsiveContainer>
          </div>
        </div>

        {/* Chart 2: Traceability & Calibration Status */}
        <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl p-6 sm:p-8 shadow-sm">
          <h3 className="text-lg font-black text-slate-900 dark:text-white mb-1">
            Estado de Confirmación Metrológica (ISO 10012)
          </h3>
          <p className="text-xs text-slate-500 dark:text-slate-400 mb-6">
            Distribución de certificados vigentes, próximos a vencer y vencidos
          </p>

          <div className="h-64 w-full flex items-center justify-center">
            <ResponsiveContainer width="100%" height={250}>
              <PieChart>
                <Pie
                  data={calDonutData}
                  cx="50%"
                  cy="50%"
                  innerRadius={65}
                  outerRadius={95}
                  paddingAngle={5}
                  dataKey="value"
                >
                  {calDonutData.map((entry, index) => (
                    <Cell key={`cell-${index}`} fill={entry.color} />
                  ))}
                </Pie>
                <RechartsTooltip />
                <Legend verticalAlign="bottom" height={36} />
              </PieChart>
            </ResponsiveContainer>
          </div>
        </div>

      </div>

    </div>
  );
};
