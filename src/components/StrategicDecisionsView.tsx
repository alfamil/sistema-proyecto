import React, { useState, useMemo } from 'react';
import { 
  GitFork, AlertOctagon, CheckCircle, Clock, ShieldCheck, 
  FileText, Download, Filter, UserCheck, Calendar, ArrowRight,
  Search, Sparkles, Brain, Check, X, RotateCcw
} from 'lucide-react';
import { ActivoFisico } from '../types';
import { 
  CATALOGO_DECISIONES_ESTRATEGICAS, 
  getAsesorInteligenteDecision 
} from '../utils/calculations';

interface StrategicDecisionsViewProps {
  activos: ActivoFisico[];
  onSelectActivo: (activo: ActivoFisico) => void;
  onGoToHojaVida?: (tag: string) => void;
}

export const StrategicDecisionsView: React.FC<StrategicDecisionsViewProps> = ({
  activos,
  onSelectActivo,
  onGoToHojaVida
}) => {
  const [filterCruce, setFilterCruce] = useState<string>('ALL');
  const [filterLab, setFilterLab] = useState<string>('ALL');
  const [filterDecision, setFilterDecision] = useState<string>('ALL');
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedAIAsset, setSelectedAIAsset] = useState<ActivoFisico | null>(null);

  // Available laboratories
  const availableLabs = useMemo(() => {
    return Array.from(new Set(activos.map(a => a.laboratorio))).filter(Boolean).sort();
  }, [activos]);

  // Evaluated assets with decision data
  const decisionAssets = useMemo(() => {
    return activos.filter(a => a.pareto_20 || a.decision || (a.resultado_cruce && a.resultado_cruce !== 'No Evaluado'));
  }, [activos]);

  // Filtered by quadrant/search/lab/decision
  const filteredDecisions = useMemo(() => {
    return decisionAssets.filter(a => {
      const term = searchTerm.toLowerCase().trim();
      const matchSearch = !term || (
        a.nombre.toLowerCase().includes(term) ||
        a.tag_pdvsa.toLowerCase().includes(term) ||
        (a.codigo_sudebip && a.codigo_sudebip.toLowerCase().includes(term)) ||
        (a.codigo_sap && a.codigo_sap.toLowerCase().includes(term)) ||
        (a.marca && a.marca.toLowerCase().includes(term)) ||
        (a.modelo && a.modelo.toLowerCase().includes(term))
      );

      const cruce = a.resultado_cruce || a.decision?.cruce_resultado || '';
      const matchCruce = filterCruce === 'ALL' || cruce.toUpperCase().includes(filterCruce.toUpperCase());

      const matchLab = filterLab === 'ALL' || a.laboratorio === filterLab;

      const decVal = a.decision?.decision_estrategica_final || a.decision?.decision_sugerida_riesgo || '';
      const matchDecision = filterDecision === 'ALL' || decVal.toUpperCase().includes(filterDecision.toUpperCase());

      return matchSearch && matchCruce && matchLab && matchDecision;
    });
  }, [decisionAssets, searchTerm, filterCruce, filterLab, filterDecision]);

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

      {/* Search and Filters Bar */}
      <div className="bg-white border border-slate-200 rounded-2xl p-4 sm:p-5 shadow-sm space-y-4">
        <div className="flex flex-col lg:flex-row items-stretch lg:items-center gap-3">
          
          {/* Text Search */}
          <div className="relative flex-1">
            <Search className="w-5 h-5 absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400" />
            <input
              type="text"
              placeholder="Buscar por TAG, Nombre, SUDEBIP, SAP, Marca o Modelo..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="w-full bg-slate-50 border border-slate-300 rounded-xl pl-11 pr-4 py-2.5 text-sm sm:text-base text-slate-900 placeholder-slate-400 focus:outline-none focus:border-blue-600 focus:bg-white font-medium"
            />
            {searchTerm && (
              <button 
                onClick={() => setSearchTerm('')} 
                className="absolute right-3 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600"
              >
                <X className="w-4 h-4" />
              </button>
            )}
          </div>

          {/* Laboratory Filter */}
          <div className="w-full lg:w-64">
            <select
              value={filterLab}
              onChange={(e) => setFilterLab(e.target.value)}
              className="w-full bg-slate-50 border border-slate-300 rounded-xl px-3.5 py-2.5 text-xs sm:text-sm text-slate-800 font-semibold focus:outline-none focus:border-blue-600 focus:bg-white"
            >
              <option value="ALL">🏢 Todos los Laboratorios ({activos.length})</option>
              {availableLabs.map((lab, i) => (
                <option key={i} value={lab}>{lab}</option>
              ))}
            </select>
          </div>

          {/* Decision Filter */}
          <div className="w-full lg:w-72">
            <select
              value={filterDecision}
              onChange={(e) => setFilterDecision(e.target.value)}
              className="w-full bg-slate-50 border border-slate-300 rounded-xl px-3.5 py-2.5 text-xs sm:text-sm text-slate-800 font-semibold focus:outline-none focus:border-blue-600 focus:bg-white"
            >
              <option value="ALL">📋 Todas las Decisiones</option>
              {CATALOGO_DECISIONES_ESTRATEGICAS.map((dec, i) => (
                <option key={i} value={dec}>{dec}</option>
              ))}
            </select>
          </div>

          {/* Reset Filters */}
          {(searchTerm || filterCruce !== 'ALL' || filterLab !== 'ALL' || filterDecision !== 'ALL') && (
            <button
              onClick={() => {
                setSearchTerm('');
                setFilterCruce('ALL');
                setFilterLab('ALL');
                setFilterDecision('ALL');
              }}
              className="flex items-center justify-center space-x-1.5 px-4 py-2.5 bg-slate-100 hover:bg-slate-200 text-slate-700 text-xs sm:text-sm font-bold rounded-xl transition-colors whitespace-nowrap"
              title="Restablecer filtros"
            >
              <RotateCcw className="w-4 h-4" />
              <span>Limpiar Filtros</span>
            </button>
          )}

        </div>
      </div>

      {/* Decisions Cards List - High Contrast Light Theme */}
      <div className="space-y-4">
        
        <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center px-1 gap-2">
          <h3 className="text-lg sm:text-xl font-bold text-slate-900">
            Consolidado de Planes y Decisiones Estratégicas ({filteredDecisions.length})
          </h3>
          <span className="text-xs sm:text-sm text-slate-500 font-medium">
            {filterCruce !== 'ALL' && `Filtrado por cuadrante: ${filterCruce}`}
          </span>
        </div>

        <div className="space-y-4">
          {filteredDecisions.length === 0 ? (
            <div className="bg-white border border-slate-200 rounded-2xl p-12 text-center text-slate-400 text-base">
              No hay activos que coincidan con los criterios de búsqueda y filtros seleccionados.
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

                    <div className="flex items-center space-x-2 sm:space-x-2.5 self-end md:self-auto flex-wrap">
                      <span className={`px-3.5 py-1.5 rounded-full text-xs sm:text-sm font-bold ${
                        isCritExt ? 'bg-red-100 text-red-800 border border-red-300' :
                        isAltoRiesgo ? 'bg-orange-100 text-orange-800 border border-orange-300' :
                        isObsAlta ? 'bg-amber-100 text-amber-800 border border-amber-300' :
                        'bg-blue-100 text-blue-800 border border-blue-300'
                      }`}>
                        {cruce}
                      </span>
                      
                      {/* AI Advisor Button */}
                      <button
                        onClick={() => setSelectedAIAsset(asset)}
                        className="inline-flex items-center space-x-1 px-3 py-1.5 bg-gradient-to-r from-purple-600 to-indigo-600 hover:from-purple-700 hover:to-indigo-700 text-white text-xs sm:text-sm rounded-xl transition-all font-bold shadow-sm"
                        title="Ver Diagnóstico y Recomendación de IA Experta"
                      >
                        <Sparkles className="w-3.5 h-3.5 text-amber-300" />
                        <span>Asesor IA</span>
                      </button>

                      {onGoToHojaVida && (
                        <button
                          onClick={() => onGoToHojaVida(asset.tag_pdvsa)}
                          className="px-3 py-1.5 bg-indigo-50 hover:bg-indigo-600 hover:text-white text-indigo-700 text-xs sm:text-sm rounded-xl transition-colors font-bold border border-indigo-200"
                          title="Ver Hoja de Vida Completa (AMB-GEN-SGA-PM-002)"
                        >
                          Hoja de Vida
                        </button>
                      )}
                      
                      <button
                        onClick={() => onSelectActivo(asset)}
                        className="px-3 py-1.5 bg-slate-100 hover:bg-blue-600 hover:text-white text-slate-700 text-xs sm:text-sm rounded-xl transition-colors font-bold border border-slate-200"
                        title="Editar Evaluación y Decisión SAMP"
                      >
                        Editar
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

      {/* AI Advisor Modal Dialog */}
      {selectedAIAsset && (() => {
        const aiAdvice = getAsesorInteligenteDecision(selectedAIAsset);
        return (
          <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-sm animate-in fade-in duration-200">
            <div className="bg-white rounded-3xl shadow-2xl max-w-2xl w-full overflow-hidden border border-slate-200 animate-in zoom-in-95 duration-200">
              
              {/* Modal Header */}
              <div className="bg-gradient-to-r from-purple-800 via-indigo-900 to-slate-900 p-6 text-white relative">
                <button
                  onClick={() => setSelectedAIAsset(null)}
                  className="absolute top-5 right-5 text-white/70 hover:text-white p-1 rounded-full hover:bg-white/10 transition-colors"
                >
                  <X className="w-5 h-5" />
                </button>
                <div className="flex items-center space-x-2 mb-2">
                  <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-bold bg-amber-400 text-purple-950">
                    <Sparkles className="w-3.5 h-3.5 mr-1" /> Asesor Inteligente IA
                  </span>
                  <span className="text-xs text-purple-200 font-medium">{aiAdvice.norma_referencia}</span>
                </div>
                <h3 className="text-xl sm:text-2xl font-black text-white">
                  Diagnóstico y Recomendación SAMP
                </h3>
                <p className="text-xs sm:text-sm text-purple-200 mt-1">
                  Activo: <strong className="text-white">{selectedAIAsset.nombre}</strong> ({selectedAIAsset.tag_pdvsa})
                </p>
              </div>

              {/* Modal Body */}
              <div className="p-6 space-y-5 max-h-[75vh] overflow-y-auto">
                
                {/* Multicriteria Scorecards */}
                <div className="grid grid-cols-2 sm:grid-cols-4 gap-2.5 bg-slate-50 p-3.5 rounded-2xl border border-slate-200 text-xs">
                  <div>
                    <span className="text-slate-500 font-semibold block">Criticidad PDVSA</span>
                    <span className="font-bold text-slate-900 text-sm mt-0.5 block">{selectedAIAsset.categoria_criticidad || 'Evaluado'}</span>
                  </div>
                  <div>
                    <span className="text-slate-500 font-semibold block">Obsolescencia</span>
                    <span className="font-bold text-orange-600 text-sm mt-0.5 block">{selectedAIAsset.iobs || '0'}%</span>
                  </div>
                  <div>
                    <span className="text-slate-500 font-semibold block">Nivel de Riesgo</span>
                    <span className="font-bold text-red-600 text-sm mt-0.5 block">NR {selectedAIAsset.nivel_riesgo || '4'}</span>
                  </div>
                  <div>
                    <span className="text-slate-500 font-semibold block">Cuadrante Cruce</span>
                    <span className="font-bold text-purple-700 text-sm mt-0.5 block">{aiAdvice.cuadrante}</span>
                  </div>
                </div>

                {/* AI Decisions Box */}
                <div className="space-y-3">
                  <div className="p-4 rounded-2xl bg-purple-50/80 border border-purple-200 space-y-1.5">
                    <span className="text-xs font-bold text-purple-900 uppercase tracking-wider block">
                      Decisión Estratégica Recomendada (SAMP)
                    </span>
                    <p className="text-base font-extrabold text-slate-900">
                      {aiAdvice.recomendacion}
                    </p>
                  </div>

                  <div className="p-4 rounded-2xl bg-blue-50/80 border border-blue-200 space-y-1.5">
                    <span className="text-xs font-bold text-blue-900 uppercase tracking-wider block">
                      Decisión Operativa Inmediata (O&M)
                    </span>
                    <p className="text-sm sm:text-base font-bold text-slate-900">
                      {aiAdvice.decision_operativa_sugerida}
                    </p>
                  </div>
                </div>

                {/* Technical Justification */}
                <div className="p-4 rounded-2xl bg-slate-50 border border-slate-200 space-y-2">
                  <div className="flex items-center space-x-2 text-slate-700 font-bold text-xs uppercase tracking-wider">
                    <Brain className="w-4 h-4 text-purple-600" />
                    <span>Justificación Técnica y Fundamentación Normativa</span>
                  </div>
                  <p className="text-xs sm:text-sm text-slate-700 leading-relaxed font-medium">
                    {aiAdvice.justificacion}
                  </p>
                </div>

              </div>

              {/* Modal Footer */}
              <div className="p-4 sm:p-5 bg-slate-50 border-t border-slate-200 flex flex-col sm:flex-row justify-end gap-2.5">
                <button
                  type="button"
                  onClick={() => setSelectedAIAsset(null)}
                  className="px-5 py-2.5 bg-white hover:bg-slate-100 text-slate-700 border border-slate-300 rounded-xl text-xs sm:text-sm font-bold transition-colors"
                >
                  Cerrar
                </button>
                <button
                  type="button"
                  onClick={() => {
                    const assetToEdit = { ...selectedAIAsset };
                    setSelectedAIAsset(null);
                    onSelectActivo(assetToEdit);
                  }}
                  className="px-5 py-2.5 bg-gradient-to-r from-purple-600 to-indigo-600 hover:from-purple-700 hover:to-indigo-700 text-white rounded-xl text-xs sm:text-sm font-bold shadow-md transition-all flex items-center justify-center space-x-1.5"
                >
                  <Sparkles className="w-4 h-4 text-amber-300" />
                  <span>Aplicar Recomendación en Expediente</span>
                </button>
              </div>

            </div>
          </div>
        );
      })()}

    </div>
  );
};
