import React, { useState, useMemo } from 'react';
import { 
  GitFork, AlertOctagon, CheckCircle, Clock, ShieldCheck, 
  FileText, Download, Filter, UserCheck, Calendar, ArrowRight
} from 'lucide-react';
import { ActivoFisico } from '../types';

interface StrategicDecisionsViewProps {
  activos: ActivoFisico[];
  onSelectActivo: (activo: ActivoFisico) => void;
}

export const StrategicDecisionsView: React.FC<StrategicDecisionsViewProps> = ({
  activos,
  onSelectActivo
}) => {
  const [filterCruce, setFilterCruce] = useState<string>('ALL');
  const [searchTerm, setSearchTerm] = useState('');

  // Evaluated assets with decision data
  const decisionAssets = useMemo(() => {
    return activos.filter(a => a.pareto_20 || a.decision || (a.resultado_cruce && a.resultado_cruce !== 'No Evaluado'));
  }, [activos]);

  // Filtered by quadrant/search
  const filteredDecisions = useMemo(() => {
    return decisionAssets.filter(a => {
      const matchSearch = !searchTerm || (
        a.nombre.toLowerCase().includes(searchTerm.toLowerCase()) ||
        a.tag_pdvsa.toLowerCase().includes(searchTerm.toLowerCase()) ||
        (a.codigo_sudebip && a.codigo_sudebip.toLowerCase().includes(searchTerm.toLowerCase()))
      );

      const cruce = a.resultado_cruce || a.decision?.cruce_resultado || '';
      const matchCruce = filterCruce === 'ALL' || cruce.toUpperCase().includes(filterCruce.toUpperCase());

      return matchSearch && matchCruce;
    });
  }, [decisionAssets, searchTerm, filterCruce]);

  // Counts by Quadrant
  const quadrantCounts = useMemo(() => {
    let criticoExtremo = 0;
    let altoRiesgo = 0;
    let obsolescenciaAlta = 0;
    let moderado = 0;
    let aceptable = 0;

    decisionAssets.forEach(a => {
      const c = (a.resultado_cruce || a.decision?.cruce_resultado || '').toUpperCase();
      if (c.includes('CRÍTICO EXTREMO')) criticoExtremo++;
      else if (c.includes('ALTO RIESGO')) altoRiesgo++;
      else if (c.includes('OBSOLESCENCIA ALTA')) obsolescenciaAlta++;
      else if (c.includes('MODERADO')) moderado++;
      else if (c.includes('ACEPTABLE')) aceptable++;
    });

    return { criticoExtremo, altoRiesgo, obsolescenciaAlta, moderado, aceptable };
  }, [decisionAssets]);

  const handleExportCSV = () => {
    const headers = [
      'N°', 'TAG PDVSA', 'Código SUDEBIP', 'Nombre del Activo', 'Laboratorio',
      'Criticidad PDVSA', 'Iobs (%)', 'Nivel Riesgo (NR)', 'Resultado Cruce',
      'Decisión Sugerida', 'Decisión Estratégica Final', 'Responsable DE', 'Fecha DE',
      'Decisión Operativa', 'Responsable DO', 'Fecha DO'
    ];

    const rows = filteredDecisions.map(a => [
      a.num || '',
      a.tag_pdvsa,
      a.codigo_sudebip || '',
      `"${a.nombre.replace(/"/g, '""')}"`,
      a.laboratorio,
      a.categoria_criticidad || '',
      a.iobs || '',
      a.nivel_riesgo || '',
      a.resultado_cruce || a.decision?.cruce_resultado || '',
      `"${(a.decision?.decision_sugerida_riesgo || '').replace(/"/g, '""')}"`,
      `"${(a.decision?.decision_estrategica_final || '').replace(/"/g, '""')}"`,
      a.decision?.responsable_de || '',
      a.decision?.fecha_de || '',
      `"${(a.decision?.decision_operativa || '').replace(/"/g, '""')}"`,
      a.decision?.responsable_do || '',
      a.decision?.fecha_do || ''
    ]);

    const csvContent = 'data:text/csv;charset=utf-8,\uFEFF' + [headers.join(','), ...rows.map(r => r.join(','))].join('\n');
    const encodedUri = encodeURI(csvContent);
    const link = document.createElement('a');
    link.setAttribute('href', encodedUri);
    link.setAttribute('download', `SAMP_ISO55001_Plan_Decisiones_${new Date().toISOString().slice(0, 10)}.csv`);
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  };

  return (
    <div className="space-y-6 sm:space-y-8 animate-in fade-in duration-300">
      
      {/* Title & Introduction Banner - Light Theme High Contrast */}
      <div className="bg-gradient-to-r from-purple-800 via-indigo-900 to-slate-900 rounded-2xl p-6 sm:p-8 shadow-md text-white relative overflow-hidden">
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-5">
          <div>
            <div className="flex items-center space-x-2 mb-2.5">
              <span className="inline-flex items-center px-3 py-1 rounded-full text-xs sm:text-sm font-bold bg-white/15 text-white backdrop-blur-sm border border-white/20">
                <GitFork className="w-4 h-4 mr-1.5" /> SAMP - Strategic Asset Management Plan
              </span>
              <span className="text-xs sm:text-sm text-purple-100 font-medium">ISO 55001:2024 Cláusula 6.2 & PDVSA MM-02-01-01</span>
            </div>
            <h2 className="text-2xl sm:text-4xl font-black text-white tracking-tight">
              Matriz de Cruce Multicriterio y Consolidación de Decisiones
            </h2>
            <p className="text-sm sm:text-base text-purple-100 mt-2 max-w-3xl leading-relaxed">
              Integración del <strong>Nivel de Riesgo Operacional (NR)</strong> con el <strong>Índice de Obsolescencia (Iobs)</strong> para dictaminar las decisiones de inversión de capital (CAPEX), mantenimiento correctivo/preventivo (OPEX) y desincorporación formal SUDEBIP.
            </p>
          </div>

          <button
            onClick={handleExportCSV}
            className="flex items-center space-x-2 bg-white hover:bg-slate-100 text-purple-900 font-bold px-6 py-3.5 rounded-xl shadow-lg transition-all text-sm sm:text-base whitespace-nowrap self-start md:self-auto"
          >
            <Download className="w-5 h-5 text-purple-700" />
            <span>Exportar Plan de Decisiones (CSV)</span>
          </button>
        </div>
      </div>

      {/* Quadrants Selection Grid - Responsive and Clear */}
      <div className="grid grid-cols-2 md:grid-cols-5 gap-3 sm:gap-4">
        
        {/* Crítico Extremo */}
        <button
          onClick={() => setFilterCruce(filterCruce === 'CRÍTICO EXTREMO' ? 'ALL' : 'CRÍTICO EXTREMO')}
          className={`p-4 sm:p-5 rounded-2xl border text-left transition-all ${
            filterCruce === 'CRÍTICO EXTREMO'
              ? 'bg-red-600 text-white border-red-700 shadow-md ring-2 ring-red-400'
              : 'bg-white border-slate-200 hover:border-red-400 shadow-sm text-slate-800'
          }`}
        >
          <div className="flex justify-between items-center text-xs sm:text-sm mb-1.5">
            <span className={`font-bold ${filterCruce === 'CRÍTICO EXTREMO' ? 'text-white' : 'text-red-700'}`}>Crítico Extremo</span>
            <AlertOctagon className="w-5 h-5" />
          </div>
          <div className="text-2xl sm:text-3xl font-black">{quadrantCounts.criticoExtremo}</div>
          <div className={`text-xs mt-1 leading-tight ${filterCruce === 'CRÍTICO EXTREMO' ? 'text-red-100' : 'text-slate-500'}`}>NR Alto $\ge 6$ + Iobs &gt; 66.7%</div>
          <div className={`text-xs sm:text-sm font-bold mt-2.5 ${filterCruce === 'CRÍTICO EXTREMO' ? 'text-white underline' : 'text-red-700'}`}>Sustitución Inmediata</div>
        </button>

        {/* Alto Riesgo Operacional */}
        <button
          onClick={() => setFilterCruce(filterCruce === 'ALTO RIESGO' ? 'ALL' : 'ALTO RIESGO')}
          className={`p-4 sm:p-5 rounded-2xl border text-left transition-all ${
            filterCruce === 'ALTO RIESGO'
              ? 'bg-orange-600 text-white border-orange-700 shadow-md ring-2 ring-orange-400'
              : 'bg-white border-slate-200 hover:border-orange-400 shadow-sm text-slate-800'
          }`}
        >
          <div className="flex justify-between items-center text-xs sm:text-sm mb-1.5">
            <span className={`font-bold ${filterCruce === 'ALTO RIESGO' ? 'text-white' : 'text-orange-700'}`}>Alto Riesgo</span>
            <Clock className="w-5 h-5" />
          </div>
          <div className="text-2xl sm:text-3xl font-black">{quadrantCounts.altoRiesgo}</div>
          <div className={`text-xs mt-1 leading-tight ${filterCruce === 'ALTO RIESGO' ? 'text-orange-100' : 'text-slate-500'}`}>NR Alto $\ge 6$ + Iobs $\le$ 66.7%</div>
          <div className={`text-xs sm:text-sm font-bold mt-2.5 ${filterCruce === 'ALTO RIESGO' ? 'text-white underline' : 'text-orange-700'}`}>Mitigación / Predictivo</div>
        </button>

        {/* Obsolescencia Alta */}
        <button
          onClick={() => setFilterCruce(filterCruce === 'OBSOLESCENCIA ALTA' ? 'ALL' : 'OBSOLESCENCIA ALTA')}
          className={`p-4 sm:p-5 rounded-2xl border text-left transition-all ${
            filterCruce === 'OBSOLESCENCIA ALTA'
              ? 'bg-amber-500 text-white border-amber-600 shadow-md ring-2 ring-amber-300'
              : 'bg-white border-slate-200 hover:border-amber-400 shadow-sm text-slate-800'
          }`}
        >
          <div className="flex justify-between items-center text-xs sm:text-sm mb-1.5">
            <span className={`font-bold ${filterCruce === 'OBSOLESCENCIA ALTA' ? 'text-white' : 'text-amber-700'}`}>Obsolescencia Alta</span>
            <ShieldCheck className="w-5 h-5" />
          </div>
          <div className="text-2xl sm:text-3xl font-black">{quadrantCounts.obsolescenciaAlta}</div>
          <div className={`text-xs mt-1 leading-tight ${filterCruce === 'OBSOLESCENCIA ALTA' ? 'text-amber-100' : 'text-slate-500'}`}>NR Bajo &lt; 6 + Iobs &gt; 66.7%</div>
          <div className={`text-xs sm:text-sm font-bold mt-2.5 ${filterCruce === 'OBSOLESCENCIA ALTA' ? 'text-white underline' : 'text-amber-700'}`}>Reemplazo / SUDEBIP</div>
        </button>

        {/* Moderado Controlable */}
        <button
          onClick={() => setFilterCruce(filterCruce === 'MODERADO' ? 'ALL' : 'MODERADO')}
          className={`p-4 sm:p-5 rounded-2xl border text-left transition-all ${
            filterCruce === 'MODERADO'
              ? 'bg-blue-600 text-white border-blue-700 shadow-md ring-2 ring-blue-400'
              : 'bg-white border-slate-200 hover:border-blue-400 shadow-sm text-slate-800'
          }`}
        >
          <div className="flex justify-between items-center text-xs sm:text-sm mb-1.5">
            <span className={`font-bold ${filterCruce === 'MODERADO' ? 'text-white' : 'text-blue-700'}`}>Moderado</span>
            <FileText className="w-5 h-5" />
          </div>
          <div className="text-2xl sm:text-3xl font-black">{quadrantCounts.moderado}</div>
          <div className={`text-xs mt-1 leading-tight ${filterCruce === 'MODERADO' ? 'text-blue-100' : 'text-slate-500'}`}>NR Medio + Iobs Moderado</div>
          <div className={`text-xs sm:text-sm font-bold mt-2.5 ${filterCruce === 'MODERADO' ? 'text-white underline' : 'text-blue-700'}`}>Monitoreo Metrológico</div>
        </button>

        {/* Aceptable */}
        <button
          onClick={() => setFilterCruce(filterCruce === 'ACEPTABLE' ? 'ALL' : 'ACEPTABLE')}
          className={`p-4 sm:p-5 rounded-2xl border text-left transition-all ${
            filterCruce === 'ACEPTABLE'
              ? 'bg-emerald-600 text-white border-emerald-700 shadow-md ring-2 ring-emerald-400'
              : 'bg-white border-slate-200 hover:border-emerald-400 shadow-sm text-slate-800'
          }`}
        >
          <div className="flex justify-between items-center text-xs sm:text-sm mb-1.5">
            <span className={`font-bold ${filterCruce === 'ACEPTABLE' ? 'text-white' : 'text-emerald-700'}`}>Aceptable</span>
            <CheckCircle className="w-5 h-5" />
          </div>
          <div className="text-2xl sm:text-3xl font-black">{quadrantCounts.aceptable}</div>
          <div className={`text-xs mt-1 leading-tight ${filterCruce === 'ACEPTABLE' ? 'text-emerald-100' : 'text-slate-500'}`}>NR Bajo $\le 2$ + Iobs &lt; 50%</div>
          <div className={`text-xs sm:text-sm font-bold mt-2.5 ${filterCruce === 'ACEPTABLE' ? 'text-white underline' : 'text-emerald-700'}`}>Operación Estándar</div>
        </button>

      </div>

      {/* Decisions Cards List - High Contrast Light Theme */}
      <div className="space-y-4">
        
        <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center px-1 gap-2">
          <h3 className="text-lg sm:text-xl font-bold text-slate-900">
            Consolidado de Planes y Decisiones Estratégicas ({filteredDecisions.length})
          </h3>
          <span className="text-xs sm:text-sm text-slate-500 font-medium">
            {filterCruce !== 'ALL' && `Filtrado por: ${filterCruce}`}
          </span>
        </div>

        <div className="space-y-4">
          {filteredDecisions.length === 0 ? (
            <div className="bg-white border border-slate-200 rounded-2xl p-12 text-center text-slate-400 text-base">
              No hay activos que coincidan con el cuadrante seleccionado.
            </div>
          ) : (
            filteredDecisions.map((asset, i) => {
              const cruce = asset.resultado_cruce || asset.decision?.cruce_resultado || 'No Evaluado';
              const isCritExt = cruce.includes('CRÍTICO EXTREMO');
              const isAltoRiesgo = cruce.includes('ALTO RIESGO');
              const isObsAlta = cruce.includes('OBSOLESCENCIA ALTA');

              const dec = asset.decision;

              return (
                <div 
                  key={i}
                  className="bg-white border border-slate-200 rounded-2xl p-6 shadow-sm hover:border-slate-300 transition-all space-y-4"
                >
                  {/* Header */}
                  <div className="flex flex-col md:flex-row md:items-center justify-between gap-3 border-b border-slate-100 pb-4">
                    <div>
                      <div className="flex items-center space-x-2.5 flex-wrap gap-y-1">
                        <span className="font-bold text-slate-900 text-base sm:text-lg">{asset.nombre}</span>
                        <span className="text-xs font-mono font-bold text-blue-800 bg-blue-50 px-2 py-0.5 rounded border border-blue-200">
                          {asset.tag_pdvsa}
                        </span>
                        <span className="text-xs font-mono font-bold text-emerald-800 bg-emerald-50 px-2 py-0.5 rounded border border-emerald-200">
                          SUDEBIP: {asset.codigo_sudebip || 'S/C'}
                        </span>
                        {asset.codigo_sap && asset.codigo_sap !== 'Sin Información' && (
                          <span className="text-xs font-mono text-slate-600 bg-slate-100 px-2 py-0.5 rounded border border-slate-200">
                            SAP: {asset.codigo_sap}
                          </span>
                        )}
                      </div>
                      <p className="text-xs sm:text-sm text-slate-500 mt-1 font-medium">
                        Laboratorio: <strong className="text-slate-800">{asset.laboratorio}</strong> • Marca: {asset.marca} • Modelo: {asset.modelo}
                      </p>
                    </div>

                    <div className="flex items-center space-x-3 self-end md:self-auto">
                      <span className={`px-3.5 py-1.5 rounded-full text-xs sm:text-sm font-bold ${
                        isCritExt ? 'bg-red-100 text-red-800 border border-red-300' :
                        isAltoRiesgo ? 'bg-orange-100 text-orange-800 border border-orange-300' :
                        isObsAlta ? 'bg-amber-100 text-amber-800 border border-amber-300' :
                        'bg-blue-100 text-blue-800 border border-blue-300'
                      }`}>
                        {cruce}
                      </span>
                      <button
                        onClick={() => onSelectActivo(asset)}
                        className="px-4 py-1.5 bg-slate-100 hover:bg-blue-600 hover:text-white text-slate-700 text-xs sm:text-sm rounded-xl transition-colors font-bold border border-slate-200"
                      >
                        Ver Ficha
                      </button>
                    </div>
                  </div>

                  {/* Multicriteria Grid Values */}
                  <div className="grid grid-cols-2 sm:grid-cols-4 gap-3 bg-slate-50 p-4 rounded-xl border border-slate-200 text-xs sm:text-sm">
                    <div>
                      <span className="text-slate-500 uppercase tracking-wider text-xs block font-semibold">Criticidad PDVSA</span>
                      <span className="font-bold text-slate-900 mt-0.5 block">{asset.categoria_criticidad || 'No Evaluado'}</span>
                    </div>
                    <div>
                      <span className="text-slate-500 uppercase tracking-wider text-xs block font-semibold">Índice Obsolescencia</span>
                      <span className="font-bold text-orange-600 mt-0.5 block">{asset.iobs || 'N/D'}% ({asset.estatus_obsolescencia})</span>
                    </div>
                    <div>
                      <span className="text-slate-500 uppercase tracking-wider text-xs block font-semibold">Nivel de Riesgo (NR)</span>
                      <span className="font-bold text-slate-900 mt-0.5 block">{asset.nivel_riesgo || 'N/D'} ({asset.clasificacion_riesgo})</span>
                    </div>
                    <div>
                      <span className="text-slate-500 uppercase tracking-wider text-xs block font-semibold">Oportunidad</span>
                      <span className="font-bold text-emerald-700 mt-0.5 block">{asset.prioridad_oportunidad || 'N/D'}</span>
                    </div>
                  </div>

                  {/* Strategic & Operational Decisions Block */}
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    
                    {/* Decisión Estratégica (DE) */}
                    <div className="p-5 rounded-2xl bg-purple-50/70 border border-purple-200 space-y-2.5">
                      <div className="flex items-center space-x-2 text-purple-900 font-bold text-xs sm:text-sm uppercase tracking-wider">
                        <GitFork className="w-4 h-4 text-purple-700" />
                        <span>Decisión Estratégica Final (SAMP)</span>
                      </div>
                      <p className="text-sm sm:text-base font-bold text-slate-900 leading-snug">
                        {dec?.decision_estrategica_final || dec?.decision_sugerida_riesgo || 'Pendiente de formalización'}
                      </p>
                      
                      <div className="flex flex-wrap items-center gap-x-4 gap-y-1 text-xs sm:text-sm text-slate-600 pt-2.5 border-t border-purple-200/60 font-medium">
                        <span className="flex items-center">
                          <UserCheck className="w-4 h-4 mr-1 text-purple-700" />
                          Responsable: <strong className="text-slate-900 ml-1">{dec?.responsable_de || 'Responsable de Laboratorio'}</strong>
                        </span>
                        {dec?.fecha_de && (
                          <span className="flex items-center">
                            <Calendar className="w-4 h-4 mr-1 text-purple-700" />
                            Cumplimiento: <strong className="text-slate-900 ml-1 font-mono">{dec.fecha_de}</strong>
                          </span>
                        )}
                      </div>
                    </div>

                    {/* Decisión Operativa (DO) */}
                    <div className="p-5 rounded-2xl bg-blue-50/70 border border-blue-200 space-y-2.5">
                      <div className="flex items-center space-x-2 text-blue-900 font-bold text-xs sm:text-sm uppercase tracking-wider">
                        <Clock className="w-4 h-4 text-blue-700" />
                        <span>Decisión Operativa Inmediata (O&M)</span>
                      </div>
                      <p className="text-sm sm:text-base font-bold text-slate-900 leading-snug">
                        {dec?.decision_operativa || 'Gestión por mantenimiento rutinario y verificación metrológica'}
                      </p>
                      
                      <div className="flex flex-wrap items-center gap-x-4 gap-y-1 text-xs sm:text-sm text-slate-600 pt-2.5 border-t border-blue-200/60 font-medium">
                        <span className="flex items-center">
                          <UserCheck className="w-4 h-4 mr-1 text-blue-700" />
                          Responsable: <strong className="text-slate-900 ml-1">{dec?.responsable_do || 'Analista de Gestión de Calidad'}</strong>
                        </span>
                        {dec?.fecha_do && (
                          <span className="flex items-center">
                            <Calendar className="w-4 h-4 mr-1 text-blue-700" />
                            Cumplimiento: <strong className="text-slate-900 ml-1 font-mono">{dec.fecha_do}</strong>
                          </span>
                        )}
                      </div>
                    </div>

                  </div>

                </div>
              );
            })
          )}
        </div>

      </div>

    </div>
  );
};
