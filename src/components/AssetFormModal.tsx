import React, { useState, useEffect, useMemo } from 'react';
import { 
  X, Save, AlertTriangle, ShieldCheck, Activity, Settings, 
  FileText, Clock, Plus, Trash2, Calendar, Wrench, CheckCircle2, GitFork
} from 'lucide-react';
import { ActivoFisico, SudebipItem, HistorialFalla } from '../types';
import { 
  calculateConsecuencia, calculateCriticidad, getCategoriaCriticidad, 
  calculateIobs, getMatrizCruceDecision 
} from '../utils/calculations';

interface AssetFormModalProps {
  isOpen: boolean;
  onClose: () => void;
  activo: ActivoFisico | null;
  onSave: (activo: ActivoFisico) => void;
  catalogoSudebip: SudebipItem[];
}

export const AssetFormModal: React.FC<AssetFormModalProps> = ({
  isOpen,
  onClose,
  activo,
  onSave,
  catalogoSudebip
}) => {
  const [activeTab, setActiveTab] = useState<'general' | 'metrologia' | 'criticidad' | 'obsolescencia' | 'decisiones' | 'fallas'>('general');

  // Form State
  const [formData, setFormData] = useState<ActivoFisico>({
    tag_pdvsa: '',
    codigo_sudebip: '',
    codigo_sap: '',
    nombre: '',
    marca: '',
    modelo: '',
    serial: '',
    laboratorio: 'Aire (Calidad de Aire)',
    criticidad_analista: 'Alta',
    tipo_equipo: 'Instrumento de Medición',
    pareto_20: false,
    estado_operativo: 'Operativo',
    es_equipo_analitico: true,
    rango_medicion: '',
    resolucion: '',
    frecuencia_calibracion: 'Anual',
    fecha_ultima_calibracion: '',
    fecha_proxima_calibracion: '',
    fecha_puesta_marcha: '',
    vida_util_fabricante_anos: 10,
    capex_costo_adquisicion: 0,
    tco_costo_total: 0
  });

  // Criticality scoring state
  const [critScores, setCritScores] = useState({
    ff: 3,
    io: 5,
    fo: 2,
    cm: 2,
    sha: 4
  });

  // Obsolescence scoring state
  const [obsScores, setObsScores] = useState({
    eol: 2,
    rep: 2,
    met: 1,
    ant: 2
  });

  // Decisions state
  const [decData, setDecData] = useState({
    nivelRiesgo: 4,
    decisionEstrategicaFinal: '',
    responsableDE: 'Responsable de Laboratorio',
    fechaDE: '',
    decisionOperativa: '',
    responsableDO: 'Analista de Gestión de Calidad',
    fechaDO: ''
  });

  // Failure logs
  const [fallas, setFallas] = useState<HistorialFalla[]>([]);
  const [newFalla, setNewFalla] = useState<HistorialFalla>({
    fecha_evento: new Date().toISOString().slice(0, 10),
    tipo_evento: 'Mantenimiento Correctivo',
    descripcion: '',
    tiempo_fuera_servicio_horas: 0,
    tecnico_responsable: '',
    estado: 'Completado'
  });

  // Initialize data on open
  useEffect(() => {
    if (activo) {
      setFormData({ ...activo });

      if (activo.jerarquizacion) {
        setCritScores({
          ff: Number(activo.jerarquizacion.ff) || 3,
          io: Number(activo.jerarquizacion.io) || 5,
          fo: Number(activo.jerarquizacion.fo) || 2,
          cm: Number(activo.jerarquizacion.cm) || 2,
          sha: Number(activo.jerarquizacion.sha) || 4
        });
      }

      if (activo.obsolescencia) {
        setObsScores({
          eol: Number(activo.obsolescencia.eol) || 2,
          rep: Number(activo.obsolescencia.rep) || 2,
          met: Number(activo.obsolescencia.met) || 1,
          ant: Number(activo.obsolescencia.ant) || 2
        });
      }

      if (activo.decision) {
        setDecData({
          nivelRiesgo: Number(activo.nivel_riesgo) || 4,
          decisionEstrategicaFinal: activo.decision.decision_estrategica_final || '',
          responsableDE: activo.decision.responsable_de || 'Responsable de Laboratorio',
          fechaDE: activo.decision.fecha_de || '',
          decisionOperativa: activo.decision.decision_operativa || '',
          responsableDO: activo.decision.responsable_do || 'Analista de Gestión de Calidad',
          fechaDO: activo.decision.fecha_do || ''
        });
      }

      setFallas(activo.historial_fallas || []);
    } else {
      setFormData({
        tag_pdvsa: 'INT-GAMB-NUEVO-01',
        codigo_sudebip: '18010-0001',
        codigo_sap: '',
        nombre: '',
        marca: '',
        modelo: '',
        serial: '',
        laboratorio: 'Aire (Calidad de Aire)',
        criticidad_analista: 'Media',
        tipo_equipo: 'Instrumento de Medición',
        pareto_20: true,
        estado_operativo: 'Operativo',
        es_equipo_analitico: true,
        rango_medicion: '',
        resolucion: '',
        frecuencia_calibracion: 'Anual',
        fecha_puesta_marcha: '2020-01-01',
        vida_util_fabricante_anos: 10
      });
      setCritScores({ ff: 2, io: 5, fo: 2, cm: 1, sha: 1 });
      setObsScores({ eol: 1, rep: 1, met: 1, ant: 1 });
      setFallas([]);
    }
  }, [activo, isOpen]);

  // Real-time Criticality Calculation
  const consecuenciaCalc = useMemo(() => {
    return calculateConsecuencia(critScores.io, critScores.fo, critScores.cm, critScores.sha);
  }, [critScores]);

  const criticidadCalc = useMemo(() => {
    const ic = calculateCriticidad(critScores.ff, consecuenciaCalc);
    const cat = getCategoriaCriticidad(ic);
    return { ic, ...cat };
  }, [critScores.ff, consecuenciaCalc]);

  // Real-time Obsolescence Calculation
  const obsolescenciaCalc = useMemo(() => {
    return calculateIobs(obsScores.eol, obsScores.rep, obsScores.met, obsScores.ant);
  }, [obsScores]);

  // Real-time Multicriteria Cross
  const cruceCalc = useMemo(() => {
    return getMatrizCruceDecision(decData.nivelRiesgo, obsolescenciaCalc.iobs);
  }, [decData.nivelRiesgo, obsolescenciaCalc.iobs]);

  if (!isOpen) return null;

  const handleAddFalla = () => {
    if (!newFalla.descripcion) {
      alert('Por favor introduzca la descripción de la falla.');
      return;
    }
    const updated = [newFalla, ...fallas];
    setFallas(updated);
    setNewFalla({
      fecha_evento: new Date().toISOString().slice(0, 10),
      tipo_evento: 'Mantenimiento Correctivo',
      descripcion: '',
      tiempo_fuera_servicio_horas: 0,
      tecnico_responsable: '',
      estado: 'Completado'
    });
  };

  const handleRemoveFalla = (index: number) => {
    setFallas(fallas.filter((_, i) => i !== index));
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();

    if (!formData.tag_pdvsa || !formData.nombre) {
      alert('El TAG PDVSA y el Nombre del Activo son obligatorios.');
      return;
    }

    const payload: ActivoFisico = {
      ...formData,
      categoria_criticidad: criticidadCalc.categoria,
      iobs: obsolescenciaCalc.iobs,
      estatus_obsolescencia: obsolescenciaCalc.estatus,
      nivel_riesgo: decData.nivelRiesgo,
      resultado_cruce: cruceCalc.resultadoCruce,
      jerarquizacion: {
        ff: critScores.ff,
        io: critScores.io,
        fo: critScores.fo,
        cm: critScores.cm,
        sha: critScores.sha,
        consecuencia: consecuenciaCalc,
        ic: criticidadCalc.ic,
        categoria_criticidad: criticidadCalc.categoria,
        estatus_seleccion: criticidadCalc.estatusSeleccion,
        criterio_accion: criticidadCalc.criterioAccion
      },
      obsolescencia: {
        eol: obsScores.eol,
        rep: obsScores.rep,
        met: obsScores.met,
        ant: obsScores.ant,
        suma_puntos: obsolescenciaCalc.suma,
        iobs: obsolescenciaCalc.iobs,
        estatus_obsolescencia: obsolescenciaCalc.estatus
      },
      decision: {
        cruce_resultado: cruceCalc.resultadoCruce,
        decision_sugerida_riesgo: cruceCalc.decisionSugerida,
        decision_estrategica_final: decData.decisionEstrategicaFinal || cruceCalc.decisionSugerida,
        responsable_de: decData.responsableDE,
        fecha_de: decData.fechaDE,
        decision_operativa: decData.decisionOperativa,
        responsable_do: decData.responsableDO,
        fecha_do: decData.fechaDO
      },
      historial_fallas: fallas
    };

    onSave(payload);
    onClose();
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm p-4 overflow-y-auto">
      <div className="bg-white border border-slate-200 w-full max-w-4xl rounded-2xl shadow-2xl overflow-hidden my-8 animate-in fade-in zoom-in-95 duration-200 flex flex-col max-h-[90vh]">
        
        {/* Modal Header - Light Theme High Contrast */}
        <div className="px-6 py-5 bg-slate-50 border-b border-slate-200 flex justify-between items-center flex-shrink-0">
          <div>
            <div className="flex items-center space-x-2.5 flex-wrap gap-y-1">
              <h3 className="font-extrabold text-xl text-slate-900">
                {activo ? 'Ficha Técnica del Activo' : 'Registro de Nuevo Activo'}
              </h3>
              <span className="font-mono text-xs sm:text-sm font-bold px-2.5 py-0.5 rounded-lg bg-blue-50 text-blue-800 border border-blue-200">
                {formData.tag_pdvsa || 'Nuevo TAG'}
              </span>
            </div>
            <p className="text-xs sm:text-sm text-slate-500 mt-1 font-medium">
              Convergencia SUDEBIP / ISO 55001 / ISO 10012 / PDVSA MM-02-01-01
            </p>
          </div>

          <button 
            onClick={onClose}
            className="text-slate-400 hover:text-slate-700 p-2 rounded-lg hover:bg-slate-100 transition-colors"
          >
            <X className="w-6 h-6" />
          </button>
        </div>

        {/* Modal Navigation Tabs - Responsive pill tabs with larger fonts */}
        <div className="flex border-b border-slate-200 bg-slate-50/50 px-6 gap-2 overflow-x-auto flex-shrink-0 py-2">
          <button
            type="button"
            onClick={() => setActiveTab('general')}
            className={`py-2 px-3 text-xs sm:text-sm font-bold flex items-center space-x-1.5 rounded-xl transition-all whitespace-nowrap ${
              activeTab === 'general' ? 'bg-blue-600 text-white shadow-sm' : 'text-slate-600 hover:text-slate-900 hover:bg-slate-100'
            }`}
          >
            <FileText className="w-4 h-4" />
            <span>I. Identificación & SUDEBIP</span>
          </button>

          <button
            type="button"
            onClick={() => setActiveTab('metrologia')}
            className={`py-2 px-3 text-xs sm:text-sm font-bold flex items-center space-x-1.5 rounded-xl transition-all whitespace-nowrap ${
              activeTab === 'metrologia' ? 'bg-blue-600 text-white shadow-sm' : 'text-slate-600 hover:text-slate-900 hover:bg-slate-100'
            }`}
          >
            <Settings className="w-4 h-4" />
            <span>II. Metrología (ISO 10012)</span>
          </button>

          <button
            type="button"
            onClick={() => setActiveTab('criticidad')}
            className={`py-2 px-3 text-xs sm:text-sm font-bold flex items-center space-x-1.5 rounded-xl transition-all whitespace-nowrap ${
              activeTab === 'criticidad' ? 'bg-blue-600 text-white shadow-sm' : 'text-slate-600 hover:text-slate-900 hover:bg-slate-100'
            }`}
          >
            <Activity className="w-4 h-4" />
            <span>III. Criticidad PDVSA</span>
          </button>

          <button
            type="button"
            onClick={() => setActiveTab('obsolescencia')}
            className={`py-2 px-3 text-xs sm:text-sm font-bold flex items-center space-x-1.5 rounded-xl transition-all whitespace-nowrap ${
              activeTab === 'obsolescencia' ? 'bg-blue-600 text-white shadow-sm' : 'text-slate-600 hover:text-slate-900 hover:bg-slate-100'
            }`}
          >
            <Clock className="w-4 h-4" />
            <span>IV. Obsolescencia (Iobs)</span>
          </button>

          <button
            type="button"
            onClick={() => setActiveTab('decisiones')}
            className={`py-2 px-3 text-xs sm:text-sm font-bold flex items-center space-x-1.5 rounded-xl transition-all whitespace-nowrap ${
              activeTab === 'decisiones' ? 'bg-blue-600 text-white shadow-sm' : 'text-slate-600 hover:text-slate-900 hover:bg-slate-100'
            }`}
          >
            <GitFork className="w-4 h-4" />
            <span>V. Decisiones SAMP</span>
          </button>

          <button
            type="button"
            onClick={() => setActiveTab('fallas')}
            className={`py-2 px-3 text-xs sm:text-sm font-bold flex items-center space-x-1.5 rounded-xl transition-all whitespace-nowrap ${
              activeTab === 'fallas' ? 'bg-blue-600 text-white shadow-sm' : 'text-slate-600 hover:text-slate-900 hover:bg-slate-100'
            }`}
          >
            <Wrench className="w-4 h-4" />
            <span>VI. Bitácora ({fallas.length})</span>
          </button>
        </div>

        {/* Modal Body / Scrollable Form */}
        <form onSubmit={handleSubmit} className="p-6 space-y-6 overflow-y-auto flex-1 text-slate-800">
          
          {/* TAB 1: IDENTIFICACIÓN */}
          {activeTab === 'general' && (
            <div className="space-y-4">
              <h4 className="text-sm font-bold uppercase tracking-wider text-blue-700 border-b border-slate-200 pb-2">
                Convergencia de Codificación y Datos Técnicos
              </h4>

              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div>
                  <label className="block text-sm font-bold text-slate-800 mb-1.5">
                    Código Taxonomía PDVSA <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="text"
                    required
                    value={formData.tag_pdvsa}
                    onChange={(e) => setFormData({ ...formData, tag_pdvsa: e.target.value })}
                    placeholder="Ej. INT-GAMB-AIRE-ANA01"
                    className="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-sm sm:text-base text-slate-900 focus:outline-none focus:border-blue-600 focus:bg-white font-mono"
                  />
                  <span className="text-xs text-slate-500 mt-1 block">Norma PDVSA MM-01-01-07</span>
                </div>

                <div>
                  <label className="block text-sm font-bold text-slate-800 mb-1.5">
                    Código Catálogo SUDEBIP
                  </label>
                  <input
                    type="text"
                    value={formData.codigo_sudebip}
                    onChange={(e) => setFormData({ ...formData, codigo_sudebip: e.target.value })}
                    placeholder="Ej. 18010-0009-1"
                    className="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-sm sm:text-base text-slate-900 focus:outline-none focus:border-blue-600 focus:bg-white font-mono"
                  />
                  <span className="text-xs text-slate-500 mt-1 block">Ley Orgánica de Bienes Públicos</span>
                </div>

                <div>
                  <label className="block text-sm font-bold text-slate-800 mb-1.5">
                    Código SAP Finanzas
                  </label>
                  <input
                    type="text"
                    value={formData.codigo_sap}
                    onChange={(e) => setFormData({ ...formData, codigo_sap: e.target.value })}
                    placeholder="Ej. 199711198"
                    className="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-sm sm:text-base text-slate-900 focus:outline-none focus:border-blue-600 focus:bg-white font-mono"
                  />
                  <span className="text-xs text-slate-500 mt-1 block">Asignado por Finanzas</span>
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-bold text-slate-800 mb-1.5">
                    Nombre del Activo / Equipo <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="text"
                    required
                    value={formData.nombre}
                    onChange={(e) => setFormData({ ...formData, nombre: e.target.value })}
                    placeholder="Ej. ANALIZADOR DE O3"
                    className="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-sm sm:text-base text-slate-900 focus:outline-none focus:border-blue-600 focus:bg-white font-bold"
                  />
                </div>

                <div>
                  <label className="block text-sm font-bold text-slate-800 mb-1.5">
                    Laboratorio Perteneciente
                  </label>
                  <input
                    type="text"
                    value={formData.laboratorio}
                    onChange={(e) => setFormData({ ...formData, laboratorio: e.target.value })}
                    placeholder="Ej. Aire (Calidad de Aire)"
                    className="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-sm sm:text-base text-slate-900 focus:outline-none focus:border-blue-600 focus:bg-white font-medium"
                  />
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div>
                  <label className="block text-sm font-bold text-slate-800 mb-1.5">Marca</label>
                  <input
                    type="text"
                    value={formData.marca}
                    onChange={(e) => setFormData({ ...formData, marca: e.target.value })}
                    placeholder="Ej. THERMO"
                    className="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-sm sm:text-base text-slate-900 focus:outline-none focus:border-blue-600 focus:bg-white"
                  />
                </div>

                <div>
                  <label className="block text-sm font-bold text-slate-800 mb-1.5">Modelo</label>
                  <input
                    type="text"
                    value={formData.modelo}
                    onChange={(e) => setFormData({ ...formData, modelo: e.target.value })}
                    placeholder="Ej. 49C"
                    className="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-sm sm:text-base text-slate-900 focus:outline-none focus:border-blue-600 focus:bg-white"
                  />
                </div>

                <div>
                  <label className="block text-sm font-bold text-slate-800 mb-1.5">Número de Serial</label>
                  <input
                    type="text"
                    value={formData.serial}
                    onChange={(e) => setFormData({ ...formData, serial: e.target.value })}
                    placeholder="Ej. 49C-59563323"
                    className="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-sm sm:text-base text-slate-900 focus:outline-none focus:border-blue-600 focus:bg-white font-mono"
                  />
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-3 gap-4 pt-2">
                <div>
                  <label className="block text-sm font-bold text-slate-800 mb-1.5">Estado Operativo</label>
                  <select
                    value={formData.estado_operativo}
                    onChange={(e: any) => setFormData({ ...formData, estado_operativo: e.target.value })}
                    className="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-sm sm:text-base text-slate-900 focus:outline-none focus:border-blue-600 focus:bg-white font-medium"
                  >
                    <option value="Operativo">Operativo</option>
                    <option value="En Reparación">En Reparación</option>
                    <option value="Fuera de Servicio">Fuera de Servicio</option>
                    <option value="Desincorporado">Desincorporado (SUDEBIP)</option>
                  </select>
                </div>

                <div>
                  <label className="block text-sm font-bold text-slate-800 mb-1.5">Selección Pareto 20% (Muestra Vital)</label>
                  <select
                    value={formData.pareto_20 ? 'SI' : 'NO'}
                    onChange={(e) => setFormData({ ...formData, pareto_20: e.target.value === 'SI' })}
                    className="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-sm sm:text-base text-slate-900 focus:outline-none focus:border-blue-600 focus:bg-white font-medium"
                  >
                    <option value="SI">Sí (Evaluación Detallada ISO 55001)</option>
                    <option value="NO">No (Mantenimiento Rutinario)</option>
                  </select>
                </div>

                <div>
                  <label className="block text-sm font-bold text-slate-800 mb-1.5">Clasificación Funcional</label>
                  <input
                    type="text"
                    value={formData.tipo_equipo}
                    onChange={(e) => setFormData({ ...formData, tipo_equipo: e.target.value })}
                    placeholder="Ej. Instrumento de Medición"
                    className="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-sm sm:text-base text-slate-900 focus:outline-none focus:border-blue-600 focus:bg-white"
                  />
                </div>
              </div>
            </div>
          )}

          {/* TAB 2: METROLOGÍA ISO 10012 */}
          {activeTab === 'metrologia' && (
            <div className="space-y-4">
              <h4 className="text-sm font-bold uppercase tracking-wider text-blue-700 border-b border-slate-200 pb-2">
                Aseguramiento Metrológico de Equipos Analíticos (ISO 10012 / ISO 17025)
              </h4>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-bold text-slate-800 mb-1.5">Rango de Medición</label>
                  <input
                    type="text"
                    value={formData.rango_medicion || ''}
                    onChange={(e) => setFormData({ ...formData, rango_medicion: e.target.value })}
                    placeholder="Ej. 0.05 a 100 ppm"
                    className="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-sm sm:text-base text-slate-900 focus:outline-none focus:border-blue-600 focus:bg-white"
                  />
                </div>

                <div>
                  <label className="block text-sm font-bold text-slate-800 mb-1.5">Resolución / Tolerancia</label>
                  <input
                    type="text"
                    value={formData.resolucion || ''}
                    onChange={(e) => setFormData({ ...formData, resolucion: e.target.value })}
                    placeholder="Ej. 0.001 ppm"
                    className="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-sm sm:text-base text-slate-900 focus:outline-none focus:border-blue-600 focus:bg-white"
                  />
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div>
                  <label className="block text-sm font-bold text-slate-800 mb-1.5">Frecuencia de Calibración</label>
                  <select
                    value={formData.frecuencia_calibracion || 'Anual'}
                    onChange={(e) => setFormData({ ...formData, frecuencia_calibracion: e.target.value })}
                    className="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-sm sm:text-base text-slate-900 focus:outline-none focus:border-blue-600 focus:bg-white font-medium"
                  >
                    <option value="Trimestral">Trimestral</option>
                    <option value="Semestral">Semestral</option>
                    <option value="Anual">Anual</option>
                    <option value="Bianual">Bianual</option>
                    <option value="No Aplica">No Aplica</option>
                  </select>
                </div>

                <div>
                  <label className="block text-sm font-bold text-slate-800 mb-1.5">Fecha Última Calibración</label>
                  <input
                    type="date"
                    value={formData.fecha_ultima_calibracion || ''}
                    onChange={(e) => setFormData({ ...formData, fecha_ultima_calibracion: e.target.value })}
                    className="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-sm sm:text-base text-slate-900 focus:outline-none focus:border-blue-600 focus:bg-white"
                  />
                </div>

                <div>
                  <label className="block text-sm font-bold text-slate-800 mb-1.5">Fecha Próximo Vencimiento</label>
                  <input
                    type="date"
                    value={formData.fecha_proxima_calibracion || ''}
                    onChange={(e) => setFormData({ ...formData, fecha_proxima_calibracion: e.target.value })}
                    className="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-sm sm:text-base text-slate-900 focus:outline-none focus:border-blue-600 focus:bg-white"
                  />
                </div>
              </div>

              <div className="p-4 rounded-xl bg-blue-50 border border-blue-200 text-xs sm:text-sm text-blue-900 space-y-1">
                <p className="font-bold">Norma ISO 10012: Sistemas de Gestión de las Mediciones</p>
                <p>
                  Los equipos analíticos de medición utilizados en ensayos de laboratorio ambiental deben contar con trazabilidad metrológica y calibración vigente antes de emitir dictámenes oficiales de calidad ambiental.
                </p>
              </div>
            </div>
          )}

          {/* TAB 3: CRITICIDAD PDVSA MM-02-01-01 */}
          {activeTab === 'criticidad' && (
            <div className="space-y-5">
              <h4 className="text-sm font-bold uppercase tracking-wider text-blue-700 border-b border-slate-200 pb-2">
                Evaluación y Jerarquización de Criticidad (PDVSA MM-02-01-01)
              </h4>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                
                {/* FF */}
                <div>
                  <label className="block text-sm font-bold text-slate-800 mb-1.5">
                    Frecuencia de Falla (FF)
                  </label>
                  <select
                    value={critScores.ff}
                    onChange={(e) => setCritScores({ ...critScores, ff: Number(e.target.value) })}
                    className="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-sm sm:text-base text-slate-900 focus:outline-none focus:border-blue-600 focus:bg-white font-medium"
                  >
                    <option value={4}>4 - Alta (&gt; 2 fallas/año)</option>
                    <option value={3}>3 - Media (1 a 2 fallas/año)</option>
                    <option value={2}>2 - Baja (0.5 a 1 fallas/año)</option>
                    <option value={1}>1 - Excelente (&lt; 0.5 fallas/año)</option>
                  </select>
                </div>

                {/* IO */}
                <div>
                  <label className="block text-sm font-bold text-slate-800 mb-1.5">
                    Impacto Operacional (IO)
                  </label>
                  <select
                    value={critScores.io}
                    onChange={(e) => setCritScores({ ...critScores, io: Number(e.target.value) })}
                    className="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-sm sm:text-base text-slate-900 focus:outline-none focus:border-blue-600 focus:bg-white font-medium"
                  >
                    <option value={10}>10 - Parada Total de Operación / Laboratorio</option>
                    <option value={5}>5 - Parada Parcial / Reducción de Capacidad</option>
                    <option value={1}>1 - Sin Impacto Operacional Directo</option>
                  </select>
                </div>

                {/* FO */}
                <div>
                  <label className="block text-sm font-bold text-slate-800 mb-1.5">
                    Flexibilidad Operacional (FO)
                  </label>
                  <select
                    value={critScores.fo}
                    onChange={(e) => setCritScores({ ...critScores, fo: Number(e.target.value) })}
                    className="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-sm sm:text-base text-slate-900 focus:outline-none focus:border-blue-600 focus:bg-white font-medium"
                  >
                    <option value={4}>4 - Sin Respaldo (0% redundancia)</option>
                    <option value={2}>2 - Respaldo Parcial o Condicionado</option>
                    <option value={1}>1 - Respaldo Total (100% redundancia)</option>
                  </select>
                </div>

                {/* CM */}
                <div>
                  <label className="block text-sm font-bold text-slate-800 mb-1.5">
                    Costo de Mantenimiento (CM)
                  </label>
                  <select
                    value={critScores.cm}
                    onChange={(e) => setCritScores({ ...critScores, cm: Number(e.target.value) })}
                    className="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-sm sm:text-base text-slate-900 focus:outline-none focus:border-blue-600 focus:bg-white font-medium"
                  >
                    <option value={3}>3 - Elevado (&gt; 10.000 USD / repuestos importados)</option>
                    <option value={2}>2 - Moderado</option>
                    <option value={1}>1 - Bajo (&lt; 1.000 USD / consumibles)</option>
                  </select>
                </div>

                {/* SHA */}
                <div className="md:col-span-2">
                  <label className="block text-sm font-bold text-slate-800 mb-1.5">
                    Impacto en Seguridad, Higiene y Ambiente (SHA)
                  </label>
                  <select
                    value={critScores.sha}
                    onChange={(e) => setCritScores({ ...critScores, sha: Number(e.target.value) })}
                    className="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-sm sm:text-base text-slate-900 focus:outline-none focus:border-blue-600 focus:bg-white font-medium"
                  >
                    <option value={8}>8 - Severo (Emisiones tóxicas, riesgo de fatalidad o derrame mayor)</option>
                    <option value={4}>4 - Mitigable / Lesión Menor</option>
                    <option value={1}>1 - Sin Afectación SHA</option>
                  </select>
                </div>

              </div>

              {/* Calculated Criticality Box */}
              <div className="p-5 rounded-2xl bg-slate-50 border border-slate-200 flex flex-col md:flex-row justify-between items-center gap-4">
                <div className="space-y-1 text-center md:text-left">
                  <div className="text-xs sm:text-sm text-slate-600 font-medium">
                    Consecuencia: <strong className="text-slate-900 font-mono font-bold">{consecuenciaCalc}</strong> [(IO x FO) + CM + SHA] • Índice Criticidad: <strong className="text-blue-700 font-mono font-black text-lg">{criticidadCalc.ic}</strong>
                  </div>
                  <div className="text-xs sm:text-sm text-slate-700 font-semibold">
                    {criticidadCalc.criterioAccion}
                  </div>
                </div>

                <span className={`px-4 py-2 rounded-xl text-xs sm:text-sm font-black uppercase tracking-wider ${
                  criticidadCalc.categoria.includes('Nivel A') ? 'bg-red-100 text-red-800 border border-red-300' :
                  criticidadCalc.categoria.includes('Nivel B') ? 'bg-amber-100 text-amber-800 border border-amber-300' :
                  'bg-emerald-100 text-emerald-800 border border-emerald-300'
                }`}>
                  {criticidadCalc.categoria}
                </span>
              </div>
            </div>
          )}

          {/* TAB 4: OBSOLESCENCIA PONDERADA (Iobs) */}
          {activeTab === 'obsolescencia' && (
            <div className="space-y-5">
              <h4 className="text-sm font-bold uppercase tracking-wider text-blue-700 border-b border-slate-200 pb-2">
                Índice de Obsolescencia Ponderado (Iobs - ISO 55001)
              </h4>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                
                {/* EOL */}
                <div>
                  <label className="block text-sm font-bold text-slate-800 mb-1.5">
                    Soporte Tecnológico / Fabricante (EOL)
                  </label>
                  <select
                    value={obsScores.eol}
                    onChange={(e) => setObsScores({ ...obsScores, eol: Number(e.target.value) })}
                    className="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-sm sm:text-base text-slate-900 focus:outline-none focus:border-blue-600 focus:bg-white font-medium"
                  >
                    <option value={3}>3 - Descontinuado (Sin soporte OEM ni firmware)</option>
                    <option value={2}>2 - Soporte Limitado / En fase de retiro</option>
                    <option value={1}>1 - En Producción Activa y Soporte Total</option>
                  </select>
                </div>

                {/* REP */}
                <div>
                  <label className="block text-sm font-bold text-slate-800 mb-1.5">
                    Disponibilidad de Repuestos (REP)
                  </label>
                  <select
                    value={obsScores.rep}
                    onChange={(e) => setObsScores({ ...obsScores, rep: Number(e.target.value) })}
                    className="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-sm sm:text-base text-slate-900 focus:outline-none focus:border-blue-600 focus:bg-white font-medium"
                  >
                    <option value={3}>3 - Crítica / No disponibles en el mercado</option>
                    <option value={2}>2 - Dificultad de Procura / Importación demorada</option>
                    <option value={1}>1 - Alta Disponibilidad Local</option>
                  </select>
                </div>

                {/* MET */}
                <div>
                  <label className="block text-sm font-bold text-slate-800 mb-1.5">
                    Condición Metrológica (MET - ISO 10012)
                  </label>
                  <select
                    value={obsScores.met}
                    onChange={(e) => setObsScores({ ...obsScores, met: Number(e.target.value) })}
                    className="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-sm sm:text-base text-slate-900 focus:outline-none focus:border-blue-600 focus:bg-white font-medium"
                  >
                    <option value={3}>3 - Fuera de Especificación / Deriva no corregible</option>
                    <option value={2}>2 - Ajuste frecuente necesario</option>
                    <option value={1}>1 - Calibrado y Dentro de Especificación</option>
                  </select>
                </div>

                {/* ANT */}
                <div>
                  <label className="block text-sm font-bold text-slate-800 mb-1.5">
                    Antigüedad y Vida Útil Transcurrida (ANT)
                  </label>
                  <select
                    value={obsScores.ant}
                    onChange={(e) => setObsScores({ ...obsScores, ant: Number(e.target.value) })}
                    className="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-sm sm:text-base text-slate-900 focus:outline-none focus:border-blue-600 focus:bg-white font-medium"
                  >
                    <option value={3}>3 - &ge; 100% Vida Útil Transcurrida</option>
                    <option value={2}>2 - 50% a 99% Vida Útil Transcurrida</option>
                    <option value={1}>1 - &lt; 50% Vida Útil Transcurrida</option>
                  </select>
                </div>

              </div>

              {/* Calculated Obsolescence Box */}
              <div className="p-5 rounded-2xl bg-slate-50 border border-slate-200 flex flex-col md:flex-row justify-between items-center gap-4">
                <div className="space-y-1 text-center md:text-left">
                  <div className="text-xs sm:text-sm text-slate-600 font-medium">
                    Suma Puntos: <strong className="text-slate-900 font-mono font-bold">{obsolescenciaCalc.suma} / 12</strong> • Fórmula: [(EOL+REP+MET+ANT)/12] x 100%
                  </div>
                  <div className="text-base sm:text-lg font-black text-orange-600">
                    Índice de Obsolescencia: {obsolescenciaCalc.iobs}%
                  </div>
                </div>

                <span className={`px-4 py-2 rounded-xl text-xs sm:text-sm font-black uppercase tracking-wider ${
                  obsolescenciaCalc.estatus === 'Obsolescencia Crítica' ? 'bg-red-100 text-red-800 border border-red-300' :
                  obsolescenciaCalc.estatus === 'Obsolescencia Media' ? 'bg-orange-100 text-orange-800 border border-orange-300' :
                  'bg-emerald-100 text-emerald-800 border border-emerald-300'
                }`}>
                  {obsolescenciaCalc.estatus}
                </span>
              </div>
            </div>
          )}

          {/* TAB 5: DECISIONES SAMP */}
          {activeTab === 'decisiones' && (
            <div className="space-y-5">
              <h4 className="text-sm font-bold uppercase tracking-wider text-blue-700 border-b border-slate-200 pb-2">
                Matriz de Cruce Multicriterio y Plan de Decisiones Estratégicas (SAMP)
              </h4>

              <div className="p-5 rounded-2xl bg-slate-50 border border-slate-200 space-y-3">
                <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-2">
                  <div>
                    <span className="text-xs sm:text-sm text-slate-500 font-medium">Resultado Automático de Cruce (NR x % Iobs):</span>
                    <h5 className="text-lg sm:text-xl font-black text-slate-900">{cruceCalc.resultadoCruce}</h5>
                  </div>
                  <span className={`px-3.5 py-1.5 rounded-full text-xs sm:text-sm font-bold ${cruceCalc.badgeColor}`}>
                    {cruceCalc.prioridad}
                  </span>
                </div>
                <p className="text-sm sm:text-base text-slate-700 font-medium">
                  <strong>Recomendación Oficial:</strong> {cruceCalc.decisionSugerida}
                </p>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-bold text-slate-800 mb-1.5">
                    Nivel de Riesgo Operacional (NR: 1 a 9)
                  </label>
                  <input
                    type="number"
                    min={1}
                    max={9}
                    value={decData.nivelRiesgo}
                    onChange={(e) => setDecData({ ...decData, nivelRiesgo: Number(e.target.value) })}
                    className="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-sm sm:text-base text-slate-900 focus:outline-none focus:border-blue-600 focus:bg-white font-mono"
                  />
                  <span className="text-xs text-slate-500 mt-1 block">ISO 31000: Probabilidad x Impacto</span>
                </div>

                <div>
                  <label className="block text-sm font-bold text-slate-800 mb-1.5">
                    Decisión Estratégica Final (SAMP)
                  </label>
                  <input
                    type="text"
                    value={decData.decisionEstrategicaFinal}
                    onChange={(e) => setDecData({ ...decData, decisionEstrategicaFinal: e.target.value })}
                    placeholder="Ej. Inclusión en Plan de Renovación Tecnológica"
                    className="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-sm sm:text-base text-slate-900 focus:outline-none focus:border-blue-600 focus:bg-white font-medium"
                  />
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-bold text-slate-800 mb-1.5">Responsable DE</label>
                  <input
                    type="text"
                    value={decData.responsableDE}
                    onChange={(e) => setDecData({ ...decData, responsableDE: e.target.value })}
                    className="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-sm sm:text-base text-slate-900 focus:outline-none focus:border-blue-600 focus:bg-white"
                  />
                </div>

                <div>
                  <label className="block text-sm font-bold text-slate-800 mb-1.5">Fecha Estimada DE</label>
                  <input
                    type="date"
                    value={decData.fechaDE}
                    onChange={(e) => setDecData({ ...decData, fechaDE: e.target.value })}
                    className="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-sm sm:text-base text-slate-900 focus:outline-none focus:border-blue-600 focus:bg-white"
                  />
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-3 gap-4 pt-3 border-t border-slate-200">
                <div className="md:col-span-1">
                  <label className="block text-sm font-bold text-slate-800 mb-1.5">Decisión Operativa (DO)</label>
                  <input
                    type="text"
                    value={decData.decisionOperativa}
                    onChange={(e) => setDecData({ ...decData, decisionOperativa: e.target.value })}
                    placeholder="Ej. Mantenimiento Preventivo Reforzado"
                    className="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-sm sm:text-base text-slate-900 focus:outline-none focus:border-blue-600 focus:bg-white"
                  />
                </div>

                <div>
                  <label className="block text-sm font-bold text-slate-800 mb-1.5">Responsable DO</label>
                  <input
                    type="text"
                    value={decData.responsableDO}
                    onChange={(e) => setDecData({ ...decData, responsableDO: e.target.value })}
                    className="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-sm sm:text-base text-slate-900 focus:outline-none focus:border-blue-600 focus:bg-white"
                  />
                </div>

                <div>
                  <label className="block text-sm font-bold text-slate-800 mb-1.5">Fecha Estimada DO</label>
                  <input
                    type="date"
                    value={decData.fechaDO}
                    onChange={(e) => setDecData({ ...decData, fechaDO: e.target.value })}
                    className="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-sm sm:text-base text-slate-900 focus:outline-none focus:border-blue-600 focus:bg-white"
                  />
                </div>
              </div>
            </div>
          )}

          {/* TAB 6: BITÁCORA DE FALLAS */}
          {activeTab === 'fallas' && (
            <div className="space-y-5">
              <h4 className="text-sm font-bold uppercase tracking-wider text-blue-700 border-b border-slate-200 pb-2">
                Historial de Fallas e Intervenciones Técnicas
              </h4>

              {/* Add Falla Form */}
              <div className="p-5 rounded-2xl bg-slate-50 border border-slate-200 space-y-3.5">
                <span className="text-sm font-bold text-slate-900 block">Registrar Nuevo Evento en Bitácora</span>
                <div className="grid grid-cols-1 sm:grid-cols-4 gap-3.5">
                  <div>
                    <label className="block text-xs font-bold text-slate-700 mb-1">Fecha</label>
                    <input
                      type="date"
                      value={newFalla.fecha_evento}
                      onChange={(e) => setNewFalla({ ...newFalla, fecha_evento: e.target.value })}
                      className="w-full bg-white border border-slate-300 rounded-xl px-3 py-2 text-xs sm:text-sm text-slate-900 focus:outline-none focus:border-blue-600"
                    />
                  </div>

                  <div>
                    <label className="block text-xs font-bold text-slate-700 mb-1">Tipo de Evento</label>
                    <select
                      value={newFalla.tipo_evento}
                      onChange={(e) => setNewFalla({ ...newFalla, tipo_evento: e.target.value })}
                      className="w-full bg-white border border-slate-300 rounded-xl px-3 py-2 text-xs sm:text-sm text-slate-900 focus:outline-none focus:border-blue-600 font-medium"
                    >
                      <option value="Mantenimiento Correctivo">Mantenimiento Correctivo</option>
                      <option value="Falla Funcional">Falla Funcional</option>
                      <option value="Calibración Desviada">Calibración Desviada</option>
                      <option value="Mantenimiento Preventivo">Mantenimiento Preventivo</option>
                    </select>
                  </div>

                  <div>
                    <label className="block text-xs font-bold text-slate-700 mb-1">Horas Fuera de Servicio</label>
                    <input
                      type="number"
                      min={0}
                      value={newFalla.tiempo_fuera_servicio_horas}
                      onChange={(e) => setNewFalla({ ...newFalla, tiempo_fuera_servicio_horas: Number(e.target.value) })}
                      className="w-full bg-white border border-slate-300 rounded-xl px-3 py-2 text-xs sm:text-sm text-slate-900 focus:outline-none focus:border-blue-600 font-mono"
                    />
                  </div>

                  <div>
                    <label className="block text-xs font-bold text-slate-700 mb-1">Técnico / Responsable</label>
                    <input
                      type="text"
                      placeholder="Ej. Ing. J. Pérez"
                      value={newFalla.tecnico_responsable || ''}
                      onChange={(e) => setNewFalla({ ...newFalla, tecnico_responsable: e.target.value })}
                      className="w-full bg-white border border-slate-300 rounded-xl px-3 py-2 text-xs sm:text-sm text-slate-900 focus:outline-none focus:border-blue-600"
                    />
                  </div>
                </div>

                <div>
                  <label className="block text-xs font-bold text-slate-700 mb-1">Descripción del Evento y Causa Raíz</label>
                  <input
                    type="text"
                    placeholder="Ej. Falla en lámpara UV, pérdida de señal fotométrica. Sustitución de repuesto."
                    value={newFalla.descripcion}
                    onChange={(e) => setNewFalla({ ...newFalla, descripcion: e.target.value })}
                    className="w-full bg-white border border-slate-300 rounded-xl px-3.5 py-2.5 text-xs sm:text-sm text-slate-900 focus:outline-none focus:border-blue-600"
                  />
                </div>

                <div className="flex justify-end pt-1">
                  <button
                    type="button"
                    onClick={handleAddFalla}
                    className="px-5 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-xl text-xs sm:text-sm font-bold flex items-center transition-colors shadow-sm"
                  >
                    <Plus className="w-4 h-4 mr-1.5" />
                    Agregar Falla a la Bitácora
                  </button>
                </div>
              </div>

              {/* Fallas List */}
              <div className="space-y-2.5">
                {fallas.length === 0 ? (
                  <p className="text-sm text-slate-400 text-center py-6">No hay fallas registradas en la bitácora de este equipo.</p>
                ) : (
                  fallas.map((f, idx) => (
                    <div key={idx} className="p-4 bg-slate-50 rounded-xl border border-slate-200 flex justify-between items-start text-xs sm:text-sm">
                      <div className="space-y-1">
                        <div className="flex items-center space-x-2.5 flex-wrap">
                          <span className="font-bold text-red-700">{f.tipo_evento}</span>
                          <span className="text-slate-500 font-mono">• {f.fecha_evento}</span>
                          <span className="text-amber-700 font-mono font-bold">• {f.tiempo_fuera_servicio_horas} hrs paro</span>
                        </div>
                        <p className="text-slate-800 font-medium">{f.descripcion}</p>
                        {f.tecnico_responsable && (
                          <span className="text-slate-500 text-xs block">Técnico: {f.tecnico_responsable}</span>
                        )}
                      </div>

                      <button
                        type="button"
                        onClick={() => handleRemoveFalla(idx)}
                        className="text-slate-400 hover:text-red-600 p-1.5 rounded-lg hover:bg-white transition-colors"
                        title="Eliminar registro"
                      >
                        <Trash2 className="w-5 h-5" />
                      </button>
                    </div>
                  ))
                )}
              </div>
            </div>
          )}

          {/* Modal Actions */}
          <div className="pt-4 border-t border-slate-200 flex justify-between items-center flex-shrink-0">
            <button
              type="button"
              onClick={onClose}
              className="px-5 py-2.5 text-sm sm:text-base bg-slate-100 hover:bg-slate-200 text-slate-700 font-semibold rounded-xl transition-colors"
            >
              Cancelar
            </button>

            <button
              type="submit"
              className="px-7 py-2.5 text-sm sm:text-base bg-blue-600 hover:bg-blue-700 text-white font-bold rounded-xl shadow-md flex items-center transition-colors"
            >
              <Save className="w-5 h-5 mr-2" />
              Guardar Expediente del Activo
            </button>
          </div>

        </form>

      </div>
    </div>
  );
};
