import React, { useState, useMemo } from 'react';
import { 
  Award, TrendingUp, CheckCircle2, AlertTriangle, FileText, 
  DollarSign, ShieldAlert, Users, Target, ArrowUpRight, BarChart3, PieChart as PieChartIcon
} from 'lucide-react';
import { 
  ResponsiveContainer, BarChart, Bar, XAxis, YAxis, 
  Tooltip as RechartsTooltip, CartesianGrid, Legend, PieChart, Pie, Cell 
} from 'recharts';
import { KpiSGA, AcuerdoDireccion, CierreBrecha } from '../types';

interface GobiernoSGAViewProps {
  kpis: KpiSGA[];
  acuerdos: AcuerdoDireccion[];
  brechas: CierreBrecha[];
}

export const GobiernoSGAView: React.FC<GobiernoSGAViewProps> = ({
  kpis,
  acuerdos,
  brechas
}) => {
  const [subTab, setSubTab] = useState<'kpis' | 'actas' | 'brechas'>('kpis');

  // Chart Data for 9 KPIs
  const chartData = useMemo(() => {
    return kpis.map((k) => {
      let metaNum = 100;
      if (k.meta.includes('90')) metaNum = 90;
      else if (k.meta.includes('85')) metaNum = 85;
      else if (k.meta.includes('75')) metaNum = 75;
      else if (k.meta.includes('40')) metaNum = 40;
      else if (k.meta.includes('1.0')) metaNum = 100;

      let realNum = 0;
      if (k.numero === 9) {
        realNum = Math.round((k.valor_real_q3 / 1.0) * 100);
      } else if (k.valor_real_q3 <= 1.5) {
        realNum = +(k.valor_real_q3 * 100).toFixed(1);
      } else {
        realNum = +k.valor_real_q3.toFixed(1);
      }

      const shortNames: Record<number, string> = {
        1: 'Codificados',
        2: 'Hojas Vida',
        3: 'Procedimental',
        4: 'Disponibilidad DA',
        5: 'Obsolescencia',
        6: 'Calibración & Mant.',
        7: 'SUDEBIP/SAP',
        8: 'PEGA Anual',
        9: 'Madurez IAM'
      };

      const semaforo = k.estatus_semaforo || (
        k.numero === 1 || k.numero === 2 || k.numero === 7 ? 'EN REVISIÓN' :
        k.numero === 5 ? (k.valor_real_q3 <= 0.40 ? 'CONFORME' : 'NO CONFORME') :
        k.numero === 9 ? (k.valor_real_q3 >= 1.0 ? 'CONFORME' : 'EN REVISIÓN') :
        (k.valor_real_q3 >= 0.75 ? 'CONFORME' : 'EN REVISIÓN')
      );

      return {
        id: `KPI #${k.numero}`,
        name: shortNames[k.numero] || `KPI #${k.numero}`,
        fullName: k.indicador,
        meta: metaNum,
        real: realNum,
        realTexto: k.valor_real_texto || `${realNum}%`,
        metaTexto: k.meta,
        dimension: k.dimension || 'Operativa',
        semaforo
      };
    });
  }, [kpis]);

  // Conformity distribution
  const conformidadData = useMemo(() => {
    let conformes = 0;
    let revision = 0;
    let noConformes = 0;

    chartData.forEach(d => {
      if (d.semaforo.includes('CONFORME')) conformes++;
      else if (d.semaforo.includes('REVISIÓN') || d.semaforo.includes('REVISION')) revision++;
      else noConformes++;
    });

    return [
      { name: 'Conformes', value: conformes, color: '#10b981' },
      { name: 'En Revisión', value: revision, color: '#f59e0b' },
      { name: 'No Conformes', value: noConformes, color: '#ef4444' }
    ].filter(d => d.value > 0);
  }, [chartData]);

  // Dimension average
  const dimensionData = useMemo(() => {
    const dims: Record<string, { total: number; count: number }> = {};
    chartData.forEach(d => {
      const dim = d.dimension || 'General';
      if (!dims[dim]) dims[dim] = { total: 0, count: 0 };
      dims[dim].total += d.real;
      dims[dim].count += 1;
    });

    return Object.entries(dims).map(([dim, val]) => ({
      dimension: dim,
      promedio: +(val.total / val.count).toFixed(1)
    }));
  }, [chartData]);

  return (
    <div className="space-y-6 animate-in fade-in duration-300">
      
      {/* Header Banner */}
      <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-2xl p-6 sm:p-8 shadow-sm flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <div className="flex items-center space-x-2.5 mb-2">
            <span className="p-2 bg-emerald-50 dark:bg-emerald-950 text-emerald-700 dark:text-emerald-300 rounded-xl border border-emerald-200 dark:border-emerald-800">
              <Award className="w-5 h-5" />
            </span>
            <span className="text-xs sm:text-sm font-bold tracking-wide uppercase text-emerald-700 dark:text-emerald-400">
              Nivel Macro • Gobierno Estratégico
            </span>
            <span className="px-2.5 py-0.5 rounded-full text-xs font-semibold bg-blue-50 dark:bg-blue-950 text-blue-700 dark:text-blue-300 border border-blue-200 dark:border-blue-800">
              ISO 55001:2024 Cl. 9 & 10
            </span>
          </div>
          <h2 className="text-2xl sm:text-3xl font-black text-slate-900 dark:text-white tracking-tight">
            Gobierno del Sistema de Gestión de Activos (SGA)
          </h2>
          <p className="text-sm sm:text-base text-slate-600 dark:text-slate-400 mt-1 max-w-3xl">
            Tablero de indicadores de desempeño, acuerdos y asignación presupuestaria de la Alta Dirección, y matriz de cierre de brechas.
          </p>
        </div>

        {/* Sub-tab navigation */}
        <div className="flex bg-slate-100 dark:bg-slate-800 p-1 rounded-xl self-start md:self-auto">
          <button
            onClick={() => setSubTab('kpis')}
            className={`px-4 py-2 rounded-lg text-xs sm:text-sm font-bold transition-all ${
              subTab === 'kpis' ? 'bg-white dark:bg-slate-900 text-blue-600 dark:text-blue-400 shadow-sm' : 'text-slate-600 dark:text-slate-400 hover:text-slate-900 dark:hover:text-white'
            }`}
          >
            Tablero 9 KPIs (FO-017)
          </button>
          <button
            onClick={() => setSubTab('actas')}
            className={`px-4 py-2 rounded-lg text-xs sm:text-sm font-bold transition-all ${
              subTab === 'actas' ? 'bg-white dark:bg-slate-900 text-blue-600 dark:text-blue-400 shadow-sm' : 'text-slate-600 dark:text-slate-400 hover:text-slate-900 dark:hover:text-white'
            }`}
          >
            Revisión Dirección (FO-019)
          </button>
          <button
            onClick={() => setSubTab('brechas')}
            className={`px-4 py-2 rounded-lg text-xs sm:text-sm font-bold transition-all ${
              subTab === 'brechas' ? 'bg-white dark:bg-slate-900 text-blue-600 dark:text-blue-400 shadow-sm' : 'text-slate-600 dark:text-slate-400 hover:text-slate-900 dark:hover:text-white'
            }`}
          >
            Cierre de Brechas (FO-030)
          </button>
        </div>
      </div>

      {/* SUB-TAB 1: 9 KPIS (FO-017) */}
      {subTab === 'kpis' && (
        <div className="space-y-6">
          
          {/* 1. SECCIÓN: KPIS EN PEQUEÑO (TARJETAS COMPACTAS DE RESUMEN) */}
          <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl p-5 sm:p-6 shadow-sm">
            <div className="flex flex-col sm:flex-row justify-between sm:items-center mb-5 gap-2">
              <div>
                <div className="flex items-center space-x-2 mb-1">
                  <span className="font-mono text-xs font-bold px-2 py-0.5 rounded bg-blue-100 dark:bg-blue-950 text-blue-800 dark:text-blue-300 border border-blue-200 dark:border-blue-800">
                    AMB-GEN-SGA-FO-017
                  </span>
                  <span className="text-xs font-bold text-slate-500 dark:text-slate-400">
                    Procedimiento AMB-GEN-SGA-PG-005
                  </span>
                </div>
                <h3 className="text-lg sm:text-xl font-black text-slate-900 dark:text-white">
                  Resumen Ejecutivo • 9 Indicadores Clave de Desempeño (KPIs)
                </h3>
              </div>
              <span className="px-3 py-1 bg-emerald-50 dark:bg-emerald-950 text-emerald-700 dark:text-emerald-300 rounded-full text-xs font-extrabold border border-emerald-200 dark:border-emerald-800 self-start sm:self-auto">
                Disponibilidad Global: 82.1% (Meta ≥ 75.0%)
              </span>
            </div>

            {/* Grid de KPIs Compactos ("en pequeño") */}
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-3">
              {chartData.map((kpi, idx) => {
                const isConforme = kpi.semaforo.includes('CONFORME');
                const isRevision = kpi.semaforo.includes('REVISIÓN') || kpi.semaforo.includes('REVISION');
                const progressPct = Math.min(100, Math.max(0, kpi.meta > 0 ? (kpi.real / kpi.meta) * 100 : 0));

                return (
                  <div 
                    key={idx} 
                    className="border border-slate-200 dark:border-slate-800 rounded-2xl p-3.5 bg-slate-50/70 dark:bg-slate-800/40 hover:border-blue-400 dark:hover:border-blue-500 transition-all shadow-xs flex flex-col justify-between space-y-2"
                  >
                    <div>
                      {/* Top Badges */}
                      <div className="flex justify-between items-center mb-1.5">
                        <span className="text-[11px] font-bold text-blue-700 dark:text-blue-400 bg-blue-50 dark:bg-blue-950 px-2 py-0.5 rounded-md border border-blue-200 dark:border-blue-800">
                          {kpi.id} • {kpi.dimension}
                        </span>
                        <span className={`text-[10px] font-extrabold px-2 py-0.5 rounded-full uppercase tracking-wider ${
                          isConforme 
                            ? 'bg-emerald-100 dark:bg-emerald-950 text-emerald-800 dark:text-emerald-300 border border-emerald-300 dark:border-emerald-700' 
                            : (isRevision 
                                ? 'bg-amber-100 dark:bg-amber-950 text-amber-800 dark:text-amber-300 border border-amber-300 dark:border-amber-700'
                                : 'bg-rose-100 dark:bg-rose-950 text-rose-800 dark:text-rose-300 border border-rose-300 dark:border-rose-700')
                        }`}>
                          {kpi.semaforo}
                        </span>
                      </div>

                      {/* Indicator Title */}
                      <h4 className="font-bold text-slate-900 dark:text-white text-xs sm:text-sm leading-snug line-clamp-2">
                        {kpi.fullName}
                      </h4>
                    </div>

                    {/* Values & Progress Bar */}
                    <div className="pt-2 border-t border-slate-200 dark:border-slate-700/60 space-y-1.5">
                      <div className="flex items-baseline justify-between">
                        <span className="text-[11px] text-slate-500 dark:text-slate-400 font-medium">
                          Meta: <strong className="text-slate-700 dark:text-slate-300">{kpi.metaTexto}</strong>
                        </span>
                        <span className={`text-base sm:text-lg font-black ${
                          isConforme 
                            ? 'text-emerald-600 dark:text-emerald-400' 
                            : (isRevision ? 'text-amber-600 dark:text-amber-400' : 'text-rose-600 dark:text-rose-400')
                        }`}>
                          {kpi.realTexto}
                        </span>
                      </div>

                      {/* Mini visual progress bar */}
                      <div className="w-full bg-slate-200 dark:bg-slate-700 h-1.5 rounded-full overflow-hidden">
                        <div 
                          className={`h-full rounded-full transition-all duration-500 ${
                            isConforme ? 'bg-emerald-500' : (isRevision ? 'bg-amber-500' : 'bg-rose-500')
                          }`}
                          style={{ width: `${progressPct}%` }}
                        />
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>
          </div>

          {/* 2. SECCIÓN: GRÁFICAS DE RESUMEN ("ABAJO LA GRÁFICA") */}
          <div className="space-y-6">
            
            {/* Gráfica 1: Comparativa Meta vs Real Q3 (Barras por Indicador) */}
            <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl p-5 sm:p-7 shadow-sm space-y-4">
              <div className="flex flex-col sm:flex-row justify-between sm:items-center gap-2">
                <div className="flex items-center space-x-2">
                  <div className="p-2 bg-indigo-50 dark:bg-indigo-950 text-indigo-600 dark:text-indigo-400 rounded-xl">
                    <BarChart3 className="w-5 h-5" />
                  </div>
                  <div>
                    <h4 className="text-base sm:text-lg font-black text-slate-900 dark:text-white">
                      Comparativa de Desempeño: Meta vs Valor Real Q3 (%)
                    </h4>
                    <p className="text-xs text-slate-500 dark:text-slate-400">
                      Evaluación de los 9 indicadores del SGA bajo norma ISO 55001 y procedimiento AMB-GEN-SGA-PG-005
                    </p>
                  </div>
                </div>
                <div className="flex items-center space-x-3 text-xs font-bold text-slate-600 dark:text-slate-300">
                  <span className="flex items-center">
                    <span className="w-3 h-3 rounded bg-slate-400 mr-1.5"></span> Meta Planificada
                  </span>
                  <span className="flex items-center">
                    <span className="w-3 h-3 rounded bg-emerald-500 mr-1.5"></span> Real Q3 Alcanzado
                  </span>
                </div>
              </div>

              <div className="h-72 sm:h-80 w-full pt-2">
                <ResponsiveContainer width="100%" height="100%">
                  <BarChart data={chartData} margin={{ top: 10, right: 10, left: -15, bottom: 25 }}>
                    <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#e2e8f0" />
                    <XAxis 
                      dataKey="name" 
                      angle={-25} 
                      textAnchor="end" 
                      interval={0} 
                      tick={{ fontSize: 11, fill: '#64748b', fontWeight: 600 }}
                    />
                    <YAxis 
                      domain={[0, 120]} 
                      tick={{ fontSize: 11, fill: '#64748b' }} 
                      unit="%" 
                    />
                    <RechartsTooltip 
                      content={({ active, payload }) => {
                        if (active && payload && payload.length) {
                          const data = payload[0].payload;
                          return (
                            <div className="bg-slate-900 text-white p-3.5 rounded-xl shadow-xl border border-slate-700 text-xs space-y-1.5 max-w-xs">
                              <p className="font-extrabold text-sm text-blue-300">{data.id}: {data.fullName}</p>
                              <p className="text-slate-300">Dimensión: <strong className="text-white">{data.dimension}</strong></p>
                              <div className="flex justify-between gap-4 pt-1 border-t border-slate-700">
                                <span>Meta: <strong className="text-slate-200">{data.metaTexto}</strong></span>
                                <span>Real Q3: <strong className="text-emerald-400">{data.realTexto}</strong></span>
                              </div>
                              <p className="text-[11px] font-bold text-amber-300 pt-0.5">Estatus: {data.semaforo}</p>
                            </div>
                          );
                        }
                        return null;
                      }}
                    />
                    <Bar dataKey="meta" name="Meta" fill="#94a3b8" radius={[4, 4, 0, 0]} maxBarSize={30} />
                    <Bar 
                      dataKey="real" 
                      name="Valor Real Q3" 
                      radius={[4, 4, 0, 0]} 
                      maxBarSize={30}
                    >
                      {chartData.map((entry, index) => {
                        const isConforme = entry.semaforo.includes('CONFORME');
                        const isRevision = entry.semaforo.includes('REVISIÓN') || entry.semaforo.includes('REVISION');
                        const fill = isConforme ? '#10b981' : (isRevision ? '#f59e0b' : '#ef4444');
                        return <Cell key={`cell-${index}`} fill={fill} />;
                      })}
                    </Bar>
                  </BarChart>
                </ResponsiveContainer>
              </div>
            </div>

            {/* Fila de Gráficas Secundarias: Conformidad + Dimensiones */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              
              {/* Gráfica 2: Estado de Conformidad General (Donut Chart) */}
              <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl p-5 sm:p-6 shadow-sm space-y-4">
                <div className="flex items-center space-x-2">
                  <div className="p-2 bg-emerald-50 dark:bg-emerald-950 text-emerald-600 dark:text-emerald-400 rounded-xl">
                    <PieChartIcon className="w-5 h-5" />
                  </div>
                  <div>
                    <h4 className="text-base font-black text-slate-900 dark:text-white">
                      Distribución de Conformidad del SGA
                    </h4>
                    <p className="text-xs text-slate-500 dark:text-slate-400">
                      Proporción de KPIs conformes y bajo plan de acción
                    </p>
                  </div>
                </div>

                <div className="h-56 w-full flex items-center justify-center">
                  <ResponsiveContainer width="100%" height="100%">
                    <PieChart>
                      <Pie
                        data={conformidadData}
                        cx="50%"
                        cy="50%"
                        innerRadius={55}
                        outerRadius={80}
                        paddingAngle={4}
                        dataKey="value"
                      >
                        {conformidadData.map((entry, index) => (
                          <Cell key={`cell-${index}`} fill={entry.color} />
                        ))}
                      </Pie>
                      <RechartsTooltip />
                      <Legend 
                        verticalAlign="bottom" 
                        iconType="circle"
                        formatter={(val, entry: any) => (
                          <span className="text-xs font-bold text-slate-700 dark:text-slate-300">
                            {val} ({entry.payload.value} KPIs)
                          </span>
                        )}
                      />
                    </PieChart>
                  </ResponsiveContainer>
                </div>

                <div className="grid grid-cols-3 gap-2 pt-2 border-t border-slate-100 dark:border-slate-800 text-center text-xs">
                  <div className="bg-emerald-50 dark:bg-emerald-950/40 p-2 rounded-xl">
                    <span className="text-emerald-700 dark:text-emerald-300 font-bold block">Conformes</span>
                    <span className="text-lg font-black text-emerald-800 dark:text-emerald-200">6 (66.7%)</span>
                  </div>
                  <div className="bg-amber-50 dark:bg-amber-950/40 p-2 rounded-xl">
                    <span className="text-amber-700 dark:text-amber-300 font-bold block">En Revisión</span>
                    <span className="text-lg font-black text-amber-800 dark:text-amber-200">3 (33.3%)</span>
                  </div>
                  <div className="bg-blue-50 dark:bg-blue-950/40 p-2 rounded-xl">
                    <span className="text-blue-700 dark:text-blue-300 font-bold block">Total KPIs</span>
                    <span className="text-lg font-black text-blue-800 dark:text-blue-200">9 (100%)</span>
                  </div>
                </div>
              </div>

              {/* Gráfica 3: Promedio de Cumplimiento por Dimensión */}
              <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl p-5 sm:p-6 shadow-sm space-y-4">
                <div className="flex items-center space-x-2">
                  <div className="p-2 bg-purple-50 dark:bg-purple-950 text-purple-600 dark:text-purple-400 rounded-xl">
                    <Target className="w-5 h-5" />
                  </div>
                  <div>
                    <h4 className="text-base font-black text-slate-900 dark:text-white">
                      Desempeño Promedio por Dimensión del SGA
                    </h4>
                    <p className="text-xs text-slate-500 dark:text-slate-400">
                      Promedio de cumplimiento por área estratégica ISO 55001
                    </p>
                  </div>
                </div>

                <div className="h-56 w-full pt-2">
                  <ResponsiveContainer width="100%" height="100%">
                    <BarChart
                      layout="vertical"
                      data={dimensionData}
                      margin={{ top: 5, right: 30, left: 15, bottom: 5 }}
                    >
                      <CartesianGrid strokeDasharray="3 3" horizontal={false} stroke="#e2e8f0" />
                      <XAxis type="number" domain={[0, 120]} tick={{ fontSize: 10, fill: '#64748b' }} unit="%" />
                      <YAxis dataKey="dimension" type="category" tick={{ fontSize: 11, fill: '#64748b', fontWeight: 600 }} width={90} />
                      <RechartsTooltip 
                        formatter={(value: any) => [`${value}%`, 'Cumplimiento Promedio']}
                      />
                      <Bar dataKey="promedio" fill="#6366f1" radius={[0, 6, 6, 0]} maxBarSize={22} />
                    </BarChart>
                  </ResponsiveContainer>
                </div>

                <div className="bg-slate-50 dark:bg-slate-800/60 p-3 rounded-2xl border border-slate-200 dark:border-slate-800 text-xs text-slate-600 dark:text-slate-300 flex items-center space-x-2">
                  <CheckCircle2 className="w-4 h-4 text-emerald-600 shrink-0" />
                  <span>
                    Las dimensiones <strong>Sostenibilidad</strong> y <strong>Madurez</strong> superan ampliamente el umbral exigido por la norma ISO 55001.
                  </span>
                </div>
              </div>

            </div>

          </div>

        </div>
      )}

      {/* SUB-TAB 2: ACTAS REVISIÓN DIRECCIÓN (FO-019) */}
      {subTab === 'actas' && (
        <div className="space-y-6">
          <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl p-6 sm:p-8 shadow-sm">
            <div className="flex flex-col sm:flex-row justify-between sm:items-center mb-6 gap-2">
              <div>
                <h3 className="text-xl font-black text-slate-900 dark:text-white">
                  Acta de Revisión por la Dirección (AMB-GEN-SGA-FO-019)
                </h3>
                <p className="text-xs sm:text-sm text-slate-500 dark:text-slate-400">
                  Dictamen Global: El SGA se declara Conveniente, Adecuado y Eficaz conforme a ISO 55001:2024
                </p>
              </div>

              <div className="flex items-center space-x-2 bg-emerald-50 dark:bg-emerald-950/60 text-emerald-800 dark:text-emerald-300 px-4 py-2 rounded-xl border border-emerald-200 dark:border-emerald-800">
                <DollarSign className="w-5 h-5 text-emerald-600" />
                <span className="text-sm font-extrabold">$53,200 USD Aprobados</span>
              </div>
            </div>

            <div className="overflow-x-auto">
              <table className="w-full text-left text-sm">
                <thead className="bg-slate-50 dark:bg-slate-800/60 text-slate-600 dark:text-slate-300 font-bold uppercase text-[11px] tracking-wider border-b border-slate-200 dark:border-slate-800">
                  <tr>
                    <th className="py-3 px-4">Código</th>
                    <th className="py-3 px-4">Cláusula ISO 55001</th>
                    <th className="py-3 px-4">Acuerdo / Decisión Adoptada</th>
                    <th className="py-3 px-4">Responsable</th>
                    <th className="py-3 px-4">Fecha Límite</th>
                    <th className="py-3 px-4">Recursos Aprobados</th>
                    <th className="py-3 px-4">Mecanismo de Verificación</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-100 dark:divide-slate-800">
                  {acuerdos.map((ac) => (
                    <tr key={ac.codigo} className="hover:bg-slate-50 dark:hover:bg-slate-800/40 transition-colors">
                      <td className="py-3.5 px-4 font-mono font-bold text-blue-600 dark:text-blue-400">{ac.codigo}</td>
                      <td className="py-3.5 px-4 font-semibold text-slate-700 dark:text-slate-300">{ac.requisito_iso}</td>
                      <td className="py-3.5 px-4 font-bold text-slate-900 dark:text-white max-w-sm">{ac.acuerdo_adoptado}</td>
                      <td className="py-3.5 px-4 text-xs font-medium text-slate-600 dark:text-slate-400">{ac.responsable}</td>
                      <td className="py-3.5 px-4 font-mono text-xs text-slate-800 dark:text-slate-200">{ac.fecha_limite}</td>
                      <td className="py-3.5 px-4 font-bold text-emerald-600 dark:text-emerald-400">{ac.recursos_aprobados}</td>
                      <td className="py-3.5 px-4 text-xs text-slate-500 dark:text-slate-400">{ac.mecanismo_verificacion}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      )}

      {/* SUB-TAB 3: CIERRE DE BRECHAS (FO-030) */}
      {subTab === 'brechas' && (
        <div className="space-y-6">
          <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl p-6 sm:p-8 shadow-sm">
            <div className="flex flex-col sm:flex-row justify-between sm:items-center mb-6 gap-2">
              <div>
                <h3 className="text-xl font-black text-slate-900 dark:text-white">
                  Plan de Cierre de Brechas y Mejora Continua (AMB-GEN-SGA-FO-030)
                </h3>
                <p className="text-xs sm:text-sm text-slate-500 dark:text-slate-400">
                  Matriz Operativa de Acciones Correctivas y Predictivas (ISO 55001 Cl. 10.1, 10.2, 10.3)
                </p>
              </div>

              <div className="flex items-center space-x-2 text-xs font-bold">
                <span className="px-3 py-1 bg-amber-50 dark:bg-amber-950 text-amber-700 dark:text-amber-300 rounded-full border border-amber-200 dark:border-amber-800">
                  7 Brechas Prioritarias Gestionadas
                </span>
              </div>
            </div>

            <div className="overflow-x-auto">
              <table className="w-full text-left text-sm">
                <thead className="bg-slate-50 dark:bg-slate-800/60 text-slate-600 dark:text-slate-300 font-bold uppercase text-[11px] tracking-wider border-b border-slate-200 dark:border-slate-800">
                  <tr>
                    <th className="py-3 px-4">Cód.</th>
                    <th className="py-3 px-4">Cláusula & Origen</th>
                    <th className="py-3 px-4">Laboratorio</th>
                    <th className="py-3 px-4">Hallazgo / Desviación</th>
                    <th className="py-3 px-4">Tipo Acción</th>
                    <th className="py-3 px-4">Acción Correctiva / Preventiva</th>
                    <th className="py-3 px-4">Responsable</th>
                    <th className="py-3 px-4">Recursos</th>
                    <th className="py-3 px-4">Estatus</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-100 dark:divide-slate-800">
                  {brechas.map((b) => (
                    <tr key={b.cod_brecha} className="hover:bg-slate-50 dark:hover:bg-slate-800/40 transition-colors">
                      <td className="py-3.5 px-4 font-mono font-bold text-indigo-600 dark:text-indigo-400 whitespace-nowrap">{b.cod_brecha}</td>
                      <td className="py-3.5 px-4">
                        <div className="font-semibold text-slate-800 dark:text-slate-200 text-xs">{b.clausula_iso}</div>
                        <div className="text-[11px] text-slate-500 dark:text-slate-400">{b.origen_brecha}</div>
                      </td>
                      <td className="py-3.5 px-4 text-xs font-medium text-slate-700 dark:text-slate-300 whitespace-nowrap">{b.laboratorio}</td>
                      <td className="py-3.5 px-4 font-bold text-slate-900 dark:text-white max-w-xs text-xs">{b.descripcion}</td>
                      <td className="py-3.5 px-4 whitespace-nowrap">
                        <span className={`px-2 py-0.5 rounded-full text-[11px] font-bold ${
                          b.tipo_accion.includes('Predictiva') 
                            ? 'bg-rose-100 text-rose-800 dark:bg-rose-950 dark:text-rose-300 border border-rose-300' 
                            : (b.tipo_accion.includes('Correctiva') 
                                ? 'bg-amber-100 text-amber-800 dark:bg-amber-950 dark:text-amber-300 border border-amber-300' 
                                : 'bg-blue-100 text-blue-800 dark:bg-blue-950 dark:text-blue-300 border border-blue-300')
                        }`}>
                          {b.tipo_accion}
                        </span>
                      </td>
                      <td className="py-3.5 px-4 text-xs text-slate-700 dark:text-slate-300 max-w-xs">{b.accion_propuesta || b.causa_raiz_5p}</td>
                      <td className="py-3.5 px-4 text-xs font-medium text-slate-600 dark:text-slate-400 whitespace-nowrap">{b.responsable || 'Comité SGA'}</td>
                      <td className="py-3.5 px-4 font-mono text-xs font-bold text-emerald-600 dark:text-emerald-400 whitespace-nowrap">
                        {b.recursos_usd ? `$${b.recursos_usd.toLocaleString()} USD` : 'N/A'}
                      </td>
                      <td className="py-3.5 px-4 whitespace-nowrap">
                        <span className={`px-2 py-0.5 rounded-full text-[11px] font-bold ${
                          b.estatus === 'Cerrado Eficaz' || b.estatus === 'Cerrada'
                            ? 'bg-emerald-100 text-emerald-800 dark:bg-emerald-950 dark:text-emerald-300 border border-emerald-300'
                            : (b.estatus === 'En Proceso'
                                ? 'bg-blue-100 text-blue-800 dark:bg-blue-950 dark:text-blue-300 border border-blue-300'
                                : 'bg-slate-100 text-slate-700 dark:bg-slate-800 dark:text-slate-300 border border-slate-300')
                        }`}>
                          {b.estatus || 'En Proceso'}
                        </span>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      )}

    </div>
  );
};

