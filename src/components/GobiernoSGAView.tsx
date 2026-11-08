import React, { useState } from 'react';
import { 
  Award, TrendingUp, CheckCircle2, AlertTriangle, FileText, 
  DollarSign, ShieldAlert, Users, Target, ArrowUpRight
} from 'lucide-react';
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
          <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl p-6 sm:p-8 shadow-sm">
            <div className="flex flex-col sm:flex-row justify-between sm:items-center mb-6 gap-2">
              <div>
                <h3 className="text-xl font-black text-slate-900 dark:text-white">
                  Tablero de Control • 9 Indicadores Clave de Desempeño del SGA
                </h3>
                <p className="text-xs sm:text-sm text-slate-500 dark:text-slate-400">
                  Evaluación Trimestral Q3 2026 • Gerencia de Ambiente (334 Activos)
                </p>
              </div>
              <span className="px-3 py-1 bg-emerald-50 dark:bg-emerald-950 text-emerald-700 dark:text-emerald-300 rounded-full text-xs font-extrabold border border-emerald-200 dark:border-emerald-800 self-start sm:self-auto">
                Disponibilidad Global: 82.1% (Meta ≥ 75%)
              </span>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
              {kpis.map((kpi) => {
                const isSuperado = (kpi.valor_real_q3 || 0) >= 0.75;

                return (
                  <div key={kpi.numero} className="border border-slate-200 dark:border-slate-800 rounded-2xl p-5 bg-slate-50/50 dark:bg-slate-800/40 flex flex-col justify-between hover:border-blue-400 transition-all">
                    <div>
                      <div className="flex justify-between items-start mb-2">
                        <span className="text-xs font-bold text-blue-700 dark:text-blue-400 bg-blue-50 dark:bg-blue-950 px-2.5 py-0.5 rounded-lg border border-blue-200 dark:border-blue-800">
                          KPI #{kpi.numero} • {kpi.dimension}
                        </span>
                        <span className="text-[11px] font-bold text-slate-500 dark:text-slate-400">
                          {kpi.frecuencia}
                        </span>
                      </div>
                      <h4 className="font-extrabold text-slate-900 dark:text-white text-base leading-snug">
                        {kpi.indicador}
                      </h4>
                      <p className="text-xs font-mono text-slate-500 dark:text-slate-400 mt-1">
                        Fórmula: {kpi.formula}
                      </p>
                    </div>

                    <div className="pt-4 border-t border-slate-200 dark:border-slate-700/60 mt-4 flex items-end justify-between">
                      <div>
                        <span className="text-[11px] font-bold uppercase text-slate-500 dark:text-slate-400">Meta</span>
                        <p className="text-xs font-bold text-slate-700 dark:text-slate-300">{kpi.meta}</p>
                      </div>
                      <div className="text-right">
                        <span className="text-[11px] font-bold uppercase text-slate-500 dark:text-slate-400">Valor Real Q3</span>
                        <p className={`text-xl font-black ${isSuperado ? 'text-emerald-600 dark:text-emerald-400' : 'text-amber-600 dark:text-amber-400'}`}>
                          {kpi.valor_real_texto || (typeof kpi.valor_real_q3 === 'number' && kpi.valor_real_q3 <= 1 ? `${(kpi.valor_real_q3 * 100).toFixed(1)}%` : kpi.valor_real_q3)}
                        </p>
                      </div>
                    </div>
                  </div>
                );
              })}
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
                    <th className="py-3 px-4">Origen</th>
                    <th className="py-3 px-4">Cláusula ISO</th>
                    <th className="py-3 px-4">Laboratorio</th>
                    <th className="py-3 px-4">Hallazgo / No Conformidad</th>
                    <th className="py-3 px-4">Tipo Acción</th>
                    <th className="py-3 px-4">Causa Raíz (5 Porqués)</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-100 dark:divide-slate-800">
                  {brechas.map((b) => (
                    <tr key={b.cod_brecha} className="hover:bg-slate-50 dark:hover:bg-slate-800/40 transition-colors">
                      <td className="py-3.5 px-4 font-mono font-bold text-indigo-600 dark:text-indigo-400">{b.cod_brecha}</td>
                      <td className="py-3.5 px-4 text-xs font-medium text-slate-600 dark:text-slate-400">{b.origen_brecha}</td>
                      <td className="py-3.5 px-4 font-semibold text-slate-800 dark:text-slate-200">{b.clausula_iso}</td>
                      <td className="py-3.5 px-4 text-xs text-slate-600 dark:text-slate-400">{b.laboratorio}</td>
                      <td className="py-3.5 px-4 font-bold text-slate-900 dark:text-white max-w-sm">{b.descripcion}</td>
                      <td className="py-3.5 px-4">
                        <span className={`px-2 py-0.5 rounded-full text-xs font-bold ${
                          b.tipo_accion.includes('Predictiva') 
                            ? 'bg-rose-100 text-rose-800 dark:bg-rose-950 dark:text-rose-300' 
                            : (b.tipo_accion.includes('Correctiva') 
                                ? 'bg-amber-100 text-amber-800 dark:bg-amber-950 dark:text-amber-300' 
                                : 'bg-blue-100 text-blue-800 dark:bg-blue-950 dark:text-blue-300')
                        }`}>
                          {b.tipo_accion}
                        </span>
                      </td>
                      <td className="py-3.5 px-4 text-xs text-slate-600 dark:text-slate-300 max-w-xs">{b.causa_raiz_5p}</td>
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

