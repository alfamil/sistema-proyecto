import React, { useMemo } from 'react';
import { 
  AlertTriangle, ShieldAlert, CheckCircle2, TrendingUp, 
  Activity, Gauge, Sparkles, Filter, ChevronRight, Clock, 
  HelpCircle, ArrowRight, PlayCircle, Layers, CheckCircle
} from 'lucide-react';
import { 
  ResponsiveContainer, BarChart, Bar, XAxis, YAxis, 
  Tooltip as RechartsTooltip, CartesianGrid, PieChart, Pie, Cell, Legend
} from 'recharts';
import { ActivoFisico } from '../types';

interface DashboardViewProps {
  activos: ActivoFisico[];
  onSelectActivo: (activo: ActivoFisico) => void;
  onGoToDecisions: () => void;
  onOpenWizard: () => void;
  onFilterByCriticidad: (nivel: string) => void;
  onFilterByObsolescencia: (nivel: string) => void;
}

export const DashboardView: React.FC<DashboardViewProps> = ({
  activos,
  onSelectActivo,
  onGoToDecisions,
  onOpenWizard,
  onFilterByCriticidad,
  onFilterByObsolescencia
}) => {
  // Metrics calculation
  const metrics = useMemo(() => {
    const total = activos.length;
    const paretoCount = activos.filter(a => a.pareto_20).length;
    const paretoPercent = total > 0 ? ((paretoCount / total) * 100).toFixed(1) : '0';

    const critA = activos.filter(a => (a.categoria_criticidad || '').includes('Nivel A')).length;
    const critB = activos.filter(a => (a.categoria_criticidad || '').includes('Nivel B')).length;
    const critC = activos.filter(a => (a.categoria_criticidad || '').includes('Nivel C')).length;
    const noCrit = total - (critA + critB + critC);

    const obsCritica = activos.filter(a => (a.estatus_obsolescencia || '').includes('Crítica')).length;
    const obsMedia = activos.filter(a => (a.estatus_obsolescencia || '').includes('Media')).length;
    const obsBaja = activos.filter(a => (a.estatus_obsolescencia || '').includes('Baja')).length;

    const criticoExtremo = activos.filter(a => (a.resultado_cruce || '').includes('CRÍTICO EXTREMO')).length;
    const altoRiesgo = activos.filter(a => (a.resultado_cruce || '').includes('ALTO RIESGO')).length;
    const obsolescenciaAlta = activos.filter(a => (a.resultado_cruce || '').includes('OBSOLESCENCIA ALTA')).length;

    // Obsolescence average for evaluated assets
    const evaluatedObs = activos.filter(a => a.iobs && a.iobs !== 'No calculado' && a.iobs !== 'NULL' && !isNaN(parseFloat(String(a.iobs))));
    const avgObs = evaluatedObs.length > 0
      ? (evaluatedObs.reduce((acc, curr) => acc + (parseFloat(String(curr.iobs)) || 0), 0) / evaluatedObs.length).toFixed(1)
      : '0';

    return {
      total,
      paretoCount,
      paretoPercent,
      critA,
      critB,
      critC,
      noCrit,
      obsCritica,
      obsMedia,
      obsBaja,
      criticoExtremo,
      altoRiesgo,
      obsolescenciaAlta,
      avgObs
    };
  }, [activos]);

  // Data for Criticality chart (Evaluated vs Total)
  const critChartData = useMemo(() => [
    { name: 'Clase A (Crítico)', cantidad: metrics.critA, fill: '#dc2626' },
    { name: 'Clase B (Semicrítico)', cantidad: metrics.critB, fill: '#f59e0b' },
    { name: 'Clase C (No Crítico)', cantidad: metrics.critC, fill: '#10b981' }
  ], [metrics]);

  // Data for Obsolescence chart
  const obsChartData = useMemo(() => [
    { name: 'Crítica (>66%)', value: metrics.obsCritica, color: '#dc2626' },
    { name: 'Media (50-66%)', value: metrics.obsMedia, color: '#f59e0b' },
    { name: 'Baja (<50%)', value: metrics.obsBaja, color: '#10b981' }
  ].filter(d => d.value > 0), [metrics]);

  // Urgent Assets requiring strategic action
  const urgentAssets = useMemo(() => {
    return activos
      .filter(a => 
        (a.resultado_cruce || '').includes('CRÍTICO EXTREMO') ||
        (a.resultado_cruce || '').includes('ALTO RIESGO') ||
        (a.resultado_cruce || '').includes('OBSOLESCENCIA ALTA')
      )
      .slice(0, 6);
  }, [activos]);

  return (
    <div className="space-y-6 sm:space-y-8 animate-in fade-in duration-300">
      
      {/* 1. GUÍA VISUAL UX: "¿CÓMO FUNCIONA ESTE SISTEMA?" */}
      <div className="bg-white border-2 border-blue-200 rounded-2xl p-6 shadow-sm space-y-4">
        <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-3">
          <div className="flex items-center space-x-2.5">
            <span className="p-2 bg-blue-100 text-blue-800 rounded-xl">
              <HelpCircle className="w-6 h-6" />
            </span>
            <div>
              <h3 className="text-lg sm:text-xl font-black text-slate-900">
                ¿Cómo funciona la herramienta? (El mismo flujo de tu Excel, ahora automatizado)
              </h3>
              <p className="text-xs sm:text-sm text-slate-500 font-medium">
                Sigue estos 4 pasos sencillos para entender los números y evaluar cualquier equipo del laboratorio:
              </p>
            </div>
          </div>

          <button
            onClick={onOpenWizard}
            className="flex items-center space-x-2 bg-blue-600 hover:bg-blue-700 text-white font-bold px-5 py-3 rounded-xl shadow-md transition-all text-sm sm:text-base whitespace-nowrap self-stretch sm:self-auto"
          >
            <PlayCircle className="w-5 h-5" />
            <span>✨ Iniciar Evaluación Guiada</span>
          </button>
        </div>

        {/* 4 Step Roadmap cards */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3 pt-2 text-xs sm:text-sm">
          
          <div className="p-3.5 bg-slate-50 rounded-xl border border-slate-200 space-y-1">
            <div className="flex items-center space-x-2 text-blue-700 font-black">
              <span className="w-5 h-5 rounded-full bg-blue-600 text-white flex items-center justify-center text-xs">1</span>
              <span>1. Inventario (334 Equipos)</span>
            </div>
            <p className="text-slate-600 text-xs leading-relaxed">
              Todos los equipos cargados con su código SUDEBIP nacional y su TAG PDVSA.
            </p>
          </div>

          <div className="p-3.5 bg-slate-50 rounded-xl border border-slate-200 space-y-1">
            <div className="flex items-center space-x-2 text-indigo-700 font-black">
              <span className="w-5 h-5 rounded-full bg-indigo-600 text-white flex items-center justify-center text-xs">2</span>
              <span>2. Pareto 20% (67 Clave)</span>
            </div>
            <p className="text-slate-600 text-xs leading-relaxed">
              Se seleccionan los equipos vitales que generan el 80% del impacto operativo en INTEVEP.
            </p>
          </div>

          <div className="p-3.5 bg-slate-50 rounded-xl border border-slate-200 space-y-1">
            <div className="flex items-center space-x-2 text-amber-700 font-black">
              <span className="w-5 h-5 rounded-full bg-amber-600 text-white flex items-center justify-center text-xs">3</span>
              <span>3. Evaluación de Criticidad</span>
            </div>
            <p className="text-slate-600 text-xs leading-relaxed">
              Respondes las 5 variables (FF, IO, FO, CM, SHA) y el sistema calcula si es Clase A, B o C.
            </p>
          </div>

          <div className="p-3.5 bg-slate-50 rounded-xl border border-slate-200 space-y-1">
            <div className="flex items-center space-x-2 text-emerald-700 font-black">
              <span className="w-5 h-5 rounded-full bg-emerald-600 text-white flex items-center justify-center text-xs">4</span>
              <span>4. Decisión Automática</span>
            </div>
            <p className="text-slate-600 text-xs leading-relaxed">
              El sistema cruza criticidad + obsolescencia y dictamina si requiere sustitución CAPEX o mantenimiento.
            </p>
          </div>

        </div>
      </div>

      {/* 2. KPI CARDS INTERACTIVAS - Click para filtrar */}
      <div className="grid grid-cols-2 lg:grid-cols-6 gap-3 sm:gap-4">
        
        {/* Total Activos */}
        <div className="bg-white border border-slate-200 rounded-2xl p-4 sm:p-5 shadow-sm flex flex-col justify-between">
          <div className="flex justify-between items-center text-slate-500 mb-2">
            <span className="text-xs sm:text-sm font-bold uppercase tracking-wider">Total Equipos</span>
            <Activity className="w-4 h-4 text-blue-600" />
          </div>
          <div className="text-2xl sm:text-3xl font-black text-slate-900">{metrics.total}</div>
          <div className="text-xs text-slate-500 font-medium mt-1">Cargados en inventario</div>
        </div>

        {/* Pareto 20% */}
        <div className="bg-white border border-slate-200 rounded-2xl p-4 sm:p-5 shadow-sm flex flex-col justify-between">
          <div className="flex justify-between items-center text-slate-500 mb-2">
            <span className="text-xs sm:text-sm font-bold uppercase tracking-wider">Muestra Pareto</span>
            <Gauge className="w-4 h-4 text-indigo-600" />
          </div>
          <div className="text-2xl sm:text-3xl font-black text-indigo-600">{metrics.paretoCount}</div>
          <div className="text-xs text-indigo-800 font-bold mt-1">Muestra vital evaluada</div>
        </div>

        {/* Críticos Clase A */}
        <div 
          onClick={() => onFilterByCriticidad('Nivel A')}
          className="bg-red-50 border border-red-200 rounded-2xl p-4 sm:p-5 shadow-sm flex flex-col justify-between cursor-pointer hover:border-red-400 transition-all group"
          title="Clic para ver los equipos Críticos Clase A"
        >
          <div className="flex justify-between items-center text-red-800 mb-2">
            <span className="text-xs sm:text-sm font-bold uppercase tracking-wider group-hover:underline">Críticos Clase A</span>
            <AlertTriangle className="w-4 h-4 text-red-600" />
          </div>
          <div className="text-2xl sm:text-3xl font-black text-red-700">{metrics.critA}</div>
          <div className="text-xs text-red-800 font-bold mt-1">Impacto Parada Total ➔</div>
        </div>

        {/* Semicríticos Clase B */}
        <div 
          onClick={() => onFilterByCriticidad('Nivel B')}
          className="bg-amber-50 border border-amber-200 rounded-2xl p-4 sm:p-5 shadow-sm flex flex-col justify-between cursor-pointer hover:border-amber-400 transition-all group"
          title="Clic para ver los equipos Semicríticos Clase B"
        >
          <div className="flex justify-between items-center text-amber-800 mb-2">
            <span className="text-xs sm:text-sm font-bold uppercase tracking-wider group-hover:underline">Semicríticos B</span>
            <Sparkles className="w-4 h-4 text-amber-600" />
          </div>
          <div className="text-2xl sm:text-3xl font-black text-amber-700">{metrics.critB}</div>
          <div className="text-xs text-amber-800 font-bold mt-1">Monitoreo Focalizado ➔</div>
        </div>

        {/* Obsolescencia Crítica */}
        <div 
          onClick={() => onFilterByObsolescencia('Crítica')}
          className="bg-orange-50 border border-orange-200 rounded-2xl p-4 sm:p-5 shadow-sm flex flex-col justify-between cursor-pointer hover:border-orange-400 transition-all group"
          title="Clic para ver los equipos con Obsolescencia Crítica"
        >
          <div className="flex justify-between items-center text-orange-800 mb-2">
            <span className="text-xs sm:text-sm font-bold uppercase tracking-wider group-hover:underline">Obsolescencia Crítica</span>
            <TrendingUp className="w-4 h-4 text-orange-600" />
          </div>
          <div className="text-2xl sm:text-3xl font-black text-orange-700">{metrics.obsCritica}</div>
          <div className="text-xs text-orange-800 font-bold mt-1">&gt; 66% vida vencida ➔</div>
        </div>

        {/* Crítico Extremo (Cruce) */}
        <div 
          onClick={onGoToDecisions}
          className="bg-purple-50 border border-purple-200 rounded-2xl p-4 sm:p-5 shadow-sm flex flex-col justify-between cursor-pointer hover:border-purple-400 transition-all group"
          title="Clic para ver el Plan de Decisiones Estratégicas"
        >
          <div className="flex justify-between items-center text-purple-800 mb-2">
            <span className="text-xs sm:text-sm font-bold uppercase tracking-wider group-hover:underline">Crítico Extremo</span>
            <ShieldAlert className="w-4 h-4 text-purple-600" />
          </div>
          <div className="text-2xl sm:text-3xl font-black text-purple-700">{metrics.criticoExtremo}</div>
          <div className="text-xs text-purple-800 font-bold mt-1">CAPEX Urgente ➔</div>
        </div>

      </div>

      {/* 3. GRÁFICOS EXPLICADOS CON TARJETAS VISUALES */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        
        {/* Gráfico 1: Criticidad PDVSA */}
        <div className="bg-white border border-slate-200 rounded-2xl p-6 shadow-sm space-y-4">
          <div className="flex justify-between items-start">
            <div>
              <h3 className="font-extrabold text-slate-900 text-lg sm:text-xl">
                ¿Cómo están distribuidos por Criticidad?
              </h3>
              <p className="text-xs sm:text-sm text-slate-500 mt-0.5">
                Evaluados bajo la Norma PDVSA MM-02-01-01 en función de frecuencia de fallas y consecuencia operativa.
              </p>
            </div>
          </div>

          {/* Recharts Bar */}
          <div className="h-60 w-full min-w-0">
            <ResponsiveContainer width="100%" height={240}>
              <BarChart data={critChartData} layout="vertical" margin={{ left: 10, right: 30, top: 10, bottom: 10 }}>
                <CartesianGrid strokeDasharray="3 3" horizontal={false} stroke="#e2e8f0" />
                <XAxis type="number" stroke="#64748b" />
                <YAxis dataKey="name" type="category" width={140} stroke="#334155" tick={{ fontSize: 13, fontWeight: 700 }} />
                <RechartsTooltip 
                  contentStyle={{ backgroundColor: '#ffffff', borderColor: '#cbd5e1', borderRadius: '10px', boxShadow: '0 4px 6px -1px rgb(0 0 0 / 0.1)', color: '#0f172a' }}
                  formatter={(val) => [`${val} equipos`, 'Cantidad']}
                />
                <Bar dataKey="cantidad" radius={[0, 8, 8, 0]}>
                  {critChartData.map((entry, index) => (
                    <Cell key={`cell-${index}`} fill={entry.fill} />
                  ))}
                </Bar>
              </BarChart>
            </ResponsiveContainer>
          </div>

          {/* Explicación en texto claro para el usuario */}
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-2.5 pt-3 border-t border-slate-100 text-xs sm:text-sm">
            <div className="p-3 rounded-xl bg-red-50 border border-red-200">
              <span className="font-black text-red-800 text-base block">{metrics.critA} Equipos</span>
              <strong className="text-red-900 block font-bold">Clase A (Crítico):</strong>
              <span className="text-slate-600 text-xs">Si fallan, paran el laboratorio o generan riesgo de seguridad/ambiental.</span>
            </div>

            <div className="p-3 rounded-xl bg-amber-50 border border-amber-200">
              <span className="font-black text-amber-800 text-base block">{metrics.critB} Equipos</span>
              <strong className="text-amber-900 block font-bold">Clase B (Semicrítico):</strong>
              <span className="text-slate-600 text-xs">Tienen impacto moderado o existe equipo de respaldo condicionado.</span>
            </div>

            <div className="p-3 rounded-xl bg-emerald-50 border border-emerald-200">
              <span className="font-black text-emerald-800 text-base block">{metrics.critC} Equipos</span>
              <strong className="text-emerald-900 block font-bold">Clase C (No Crítico):</strong>
              <span className="text-slate-600 text-xs">Equipos de apoyo o rutinarios sin afectación a la producción.</span>
            </div>
          </div>
        </div>

        {/* Gráfico 2: Obsolescencia ISO 55001 */}
        <div className="bg-white border border-slate-200 rounded-2xl p-6 shadow-sm space-y-4">
          <div className="flex justify-between items-start">
            <div>
              <h3 className="font-extrabold text-slate-900 text-lg sm:text-xl">
                ¿Qué equipos están tecnológicamente obsoletos?
              </h3>
              <p className="text-xs sm:text-sm text-slate-500 mt-0.5">
                Índice de Obsolescencia Ponderado (Iobs) según vida útil de diseño y disponibilidad de repuestos.
              </p>
            </div>
          </div>

          {/* Recharts Pie */}
          <div className="h-60 w-full min-w-0 flex items-center justify-center">
            {obsChartData.length > 0 ? (
              <ResponsiveContainer width="100%" height={240}>
                <PieChart>
                  <Pie
                    data={obsChartData}
                    cx="50%"
                    cy="50%"
                    innerRadius={55}
                    outerRadius={85}
                    paddingAngle={4}
                    dataKey="value"
                  >
                    {obsChartData.map((entry, index) => (
                      <Cell key={`cell-obs-${index}`} fill={entry.color} />
                    ))}
                  </Pie>
                  <RechartsTooltip 
                    contentStyle={{ backgroundColor: '#ffffff', borderColor: '#cbd5e1', borderRadius: '10px', boxShadow: '0 4px 6px -1px rgb(0 0 0 / 0.1)', color: '#0f172a' }}
                    formatter={(val) => [`${val} equipos`, 'Total']}
                  />
                  <Legend 
                    verticalAlign="bottom" 
                    height={36} 
                    iconType="circle"
                    formatter={(value) => <span className="text-xs sm:text-sm font-bold text-slate-700">{value}</span>}
                  />
                </PieChart>
              </ResponsiveContainer>
            ) : (
              <p className="text-slate-400 text-sm text-center py-20">No hay evaluaciones registradas.</p>
            )}
          </div>

          {/* Explicación en texto claro para el usuario */}
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-2.5 pt-3 border-t border-slate-100 text-xs sm:text-sm">
            <div className="p-3 rounded-xl bg-red-50 border border-red-200">
              <span className="font-black text-red-800 text-base block">{metrics.obsCritica} Equipos</span>
              <strong className="text-red-900 block font-bold">Obsolescencia Crítica:</strong>
              <span className="text-slate-600 text-xs">Superaron 100% su vida útil o están descontinuados sin repuestos OEM.</span>
            </div>

            <div className="p-3 rounded-xl bg-amber-50 border border-amber-200">
              <span className="font-black text-amber-800 text-base block">{metrics.obsMedia} Equipos</span>
              <strong className="text-amber-900 block font-bold">Obsolescencia Media:</strong>
              <span className="text-slate-600 text-xs">Envejecimiento intermedio (50% a 99% de vida consumida).</span>
            </div>

            <div className="p-3 rounded-xl bg-emerald-50 border border-emerald-200">
              <span className="font-black text-emerald-800 text-base block">{metrics.obsBaja} Equipos</span>
              <strong className="text-emerald-900 block font-bold">Obsolescencia Baja:</strong>
              <span className="text-slate-600 text-xs">Equipos modernos, en producción activa y con repuestos locales.</span>
            </div>
          </div>
        </div>

      </div>

      {/* 4. LISTADO DE EQUIPOS QUE DEMANDAN ACCIÓN URGENTE (CRÍTICO EXTREMO) */}
      <div className="bg-white border border-slate-200 rounded-2xl p-6 shadow-sm space-y-4">
        <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-2">
          <div>
            <h3 className="font-extrabold text-slate-900 text-lg sm:text-xl flex items-center">
              <AlertTriangle className="w-5 h-5 mr-2 text-red-600" />
              Equipos de Atención Urgente (Crítico Extremo & Alto Riesgo)
            </h3>
            <p className="text-xs sm:text-sm text-slate-500 mt-0.5">
              Son equipos que al mismo tiempo son muy críticos para el laboratorio y están en estado de obsolescencia:
            </p>
          </div>

          <button
            onClick={onGoToDecisions}
            className="text-xs sm:text-sm font-bold text-blue-700 hover:text-blue-900 flex items-center self-end sm:self-auto"
          >
            Ver plan completo de decisiones ➔
          </button>
        </div>

        <div className="divide-y divide-slate-100 overflow-x-auto">
          {urgentAssets.map((asset, i) => {
            const isCritExt = (asset.resultado_cruce || '').includes('CRÍTICO EXTREMO');
            return (
              <div 
                key={i} 
                onClick={() => onSelectActivo(asset)}
                className="py-4 flex flex-col sm:flex-row sm:items-center justify-between hover:bg-slate-50 px-3 rounded-xl cursor-pointer transition-colors gap-2"
              >
                <div className="space-y-1">
                  <div className="flex items-center space-x-2.5 flex-wrap gap-y-1">
                    <span className="font-bold text-slate-900 text-base">{asset.nombre}</span>
                    <span className="text-xs font-mono font-bold text-blue-800 bg-blue-50 px-2 py-0.5 rounded border border-blue-200">
                      TAG: {asset.tag_pdvsa}
                    </span>
                    <span className="text-xs font-mono font-bold text-emerald-800 bg-emerald-50 px-2 py-0.5 rounded border border-emerald-200">
                      SUDEBIP: {asset.codigo_sudebip}
                    </span>
                  </div>
                  <p className="text-xs sm:text-sm text-slate-500">
                    Laboratorio: <strong>{asset.laboratorio}</strong> • {asset.marca} {asset.modelo}
                  </p>
                </div>

                <div className="flex items-center space-x-3 self-end sm:self-center">
                  <div className="text-right">
                    <span className={`inline-block px-3 py-1 rounded-full text-xs font-bold ${
                      isCritExt ? 'bg-red-100 text-red-800 border border-red-300' : 'bg-amber-100 text-amber-800 border border-amber-300'
                    }`}>
                      {asset.resultado_cruce}
                    </span>
                    <div className="text-xs text-slate-500 font-medium mt-0.5">
                      Iobs: <strong>{asset.iobs}%</strong> • Criticidad: <strong>{asset.categoria_criticidad?.split(' ')[0] || 'N/D'}</strong>
                    </div>
                  </div>
                  <ChevronRight className="w-5 h-5 text-slate-400" />
                </div>
              </div>
            );
          })}
        </div>
      </div>

    </div>
  );
};
