import React, { useState, useMemo } from 'react';
import { 
  X, CheckCircle2, ChevronRight, ChevronLeft, AlertTriangle, 
  ShieldCheck, Activity, Clock, GitFork, Sparkles, Save, HelpCircle, UserCheck
} from 'lucide-react';
import { ActivoFisico, UserRole } from '../types';
import { 
  calculateConsecuencia, calculateCriticidad, getCategoriaCriticidad, 
  calculateIobs, getMatrizCruceDecision 
} from '../utils/calculations';

interface EvaluationWizardModalProps {
  isOpen: boolean;
  onClose: () => void;
  activos: ActivoFisico[];
  onSaveActivo: (activo: ActivoFisico) => void;
  userRole: UserRole;
}

export const EvaluationWizardModal: React.FC<EvaluationWizardModalProps> = ({
  isOpen,
  onClose,
  activos,
  onSaveActivo,
  userRole
}) => {
  const [step, setStep] = useState<1 | 2 | 3 | 4>(1);

  // Asset selection / new data
  const [mode, setMode] = useState<'select' | 'new'>('select');
  const [selectedTag, setSelectedTag] = useState<string>(activos[0]?.tag_pdvsa || '');
  
  // Custom new asset data if mode === 'new'
  const [newAssetData, setNewAssetData] = useState({
    nombre: '',
    tag_pdvsa: '',
    codigo_sudebip: '',
    laboratorio: 'Aire (Calidad de Aire)',
    marca: '',
    modelo: ''
  });

  // Criticality Form State
  const [critScores, setCritScores] = useState({
    ff: 3, // 1-4
    io: 5, // 1, 5, 10
    fo: 2, // 1, 2, 4
    cm: 2, // 1, 2, 3
    sha: 4 // 1, 4, 8
  });

  // Obsolescence Form State
  const [obsScores, setObsScores] = useState({
    eol: 2, // 1-3
    rep: 2, // 1-3
    met: 1, // 1-3
    ant: 2  // 1-3
  });

  // Decision State
  const [responsableDE, setResponsableDE] = useState('Responsable de Laboratorio');
  const [fechaDE, setFechaDE] = useState(new Date(Date.now() + 180 * 24 * 60 * 60 * 1000).toISOString().slice(0, 10));

  // Current selected asset object
  const targetAsset = useMemo(() => {
    if (mode === 'new') {
      return {
        tag_pdvsa: newAssetData.tag_pdvsa || 'TAG-NUEVO-01',
        codigo_sudebip: newAssetData.codigo_sudebip || '18010-0001',
        nombre: newAssetData.nombre || 'Nuevo Equipo',
        laboratorio: newAssetData.laboratorio,
        marca: newAssetData.marca,
        modelo: newAssetData.modelo,
        pareto_20: true,
        estado_operativo: 'Operativo'
      } as ActivoFisico;
    }
    return activos.find(a => a.tag_pdvsa === selectedTag) || activos[0];
  }, [mode, selectedTag, newAssetData, activos]);

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

  // Real-time Decision Matrix Cross
  const cruceCalc = useMemo(() => {
    // Standard risk level from consequence or medium (4)
    const nr = criticidadCalc.categoria.includes('Nivel A') ? 7 : (criticidadCalc.categoria.includes('Nivel B') ? 4 : 2);
    return getMatrizCruceDecision(nr, obsolescenciaCalc.iobs);
  }, [criticidadCalc.categoria, obsolescenciaCalc.iobs]);

  if (!isOpen) return null;

  const handleFinish = () => {
    if (!targetAsset) return;

    const updated: ActivoFisico = {
      ...targetAsset,
      pareto_20: true,
      categoria_criticidad: criticidadCalc.categoria,
      iobs: obsolescenciaCalc.iobs,
      estatus_obsolescencia: obsolescenciaCalc.estatus,
      resultado_cruce: cruceCalc.resultadoCruce,
      nivel_riesgo: criticidadCalc.categoria.includes('Nivel A') ? 7 : 4,
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
        decision_estrategica_final: cruceCalc.decisionSugerida,
        responsable_de: responsableDE,
        fecha_de: fechaDE,
        decision_operativa: 'Monitoreo preventivo y calibración según ISO 10012',
        responsable_do: 'Analista de Gestión de Calidad',
        fecha_do: fechaDE
      }
    };

    onSaveActivo(updated);
    onClose();
    alert(`✅ ¡Evaluación completada con éxito! El activo ${updated.tag_pdvsa} ha sido clasificado como ${criticidadCalc.categoria} con resultado: ${cruceCalc.resultadoCruce}.`);
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm p-4 overflow-y-auto">
      <div className="bg-white border border-slate-200 w-full max-w-3xl rounded-2xl shadow-2xl overflow-hidden my-8 animate-in fade-in zoom-in-95 duration-200 flex flex-col max-h-[92vh]">
        
        {/* Wizard Header */}
        <div className="px-6 py-5 bg-slate-50 border-b border-slate-200 flex justify-between items-center flex-shrink-0">
          <div className="flex items-center space-x-3">
            <div className="p-2.5 bg-blue-100 text-blue-700 rounded-xl">
              <Sparkles className="w-6 h-6" />
            </div>
            <div>
              <h3 className="text-xl font-black text-slate-900">
                Asistente de Evaluación Guiada (Paso a Paso)
              </h3>
              <p className="text-xs sm:text-sm text-slate-500 font-medium">
                Metodología oficial de evaluación: PDVSA MM-02-01-01 & ISO 55001:2024
              </p>
            </div>
          </div>

          <button
            onClick={onClose}
            className="p-2 rounded-xl text-slate-400 hover:text-slate-700 hover:bg-slate-100 transition-colors"
          >
            <X className="w-6 h-6" />
          </button>
        </div>

        {/* Wizard Progress Steps Bar */}
        <div className="bg-white px-6 py-4 border-b border-slate-200 flex items-center justify-between overflow-x-auto flex-shrink-0 text-xs sm:text-sm">
          
          <button
            onClick={() => setStep(1)}
            className={`flex items-center space-x-2 font-bold transition-colors whitespace-nowrap ${
              step === 1 ? 'text-blue-600' : 'text-slate-400 hover:text-slate-700'
            }`}
          >
            <span className={`w-7 h-7 rounded-full flex items-center justify-center text-xs font-black ${
              step === 1 ? 'bg-blue-600 text-white' : 'bg-slate-100 text-slate-600'
            }`}>
              1
            </span>
            <span>1. Seleccionar Activo</span>
          </button>

          <ChevronRight className="w-4 h-4 text-slate-300 mx-2 flex-shrink-0" />

          <button
            onClick={() => setStep(2)}
            className={`flex items-center space-x-2 font-bold transition-colors whitespace-nowrap ${
              step === 2 ? 'text-blue-600' : 'text-slate-400 hover:text-slate-700'
            }`}
          >
            <span className={`w-7 h-7 rounded-full flex items-center justify-center text-xs font-black ${
              step === 2 ? 'bg-blue-600 text-white' : 'bg-slate-100 text-slate-600'
            }`}>
              2
            </span>
            <span>2. ¿Es Crítico? (Criticidad)</span>
          </button>

          <ChevronRight className="w-4 h-4 text-slate-300 mx-2 flex-shrink-0" />

          <button
            onClick={() => setStep(3)}
            className={`flex items-center space-x-2 font-bold transition-colors whitespace-nowrap ${
              step === 3 ? 'text-blue-600' : 'text-slate-400 hover:text-slate-700'
            }`}
          >
            <span className={`w-7 h-7 rounded-full flex items-center justify-center text-xs font-black ${
              step === 3 ? 'bg-blue-600 text-white' : 'bg-slate-100 text-slate-600'
            }`}>
              3
            </span>
            <span>3. ¿Está Obsoleto? (Iobs)</span>
          </button>

          <ChevronRight className="w-4 h-4 text-slate-300 mx-2 flex-shrink-0" />

          <button
            onClick={() => setStep(4)}
            className={`flex items-center space-x-2 font-bold transition-colors whitespace-nowrap ${
              step === 4 ? 'text-blue-600' : 'text-slate-400 hover:text-slate-700'
            }`}
          >
            <span className={`w-7 h-7 rounded-full flex items-center justify-center text-xs font-black ${
              step === 4 ? 'bg-blue-600 text-white' : 'bg-slate-100 text-slate-600'
            }`}>
              4
            </span>
            <span>4. Dictamen Automático</span>
          </button>

        </div>

        {/* Wizard Body Container */}
        <div className="p-6 sm:p-8 space-y-6 overflow-y-auto flex-1 text-slate-800">
          
          {/* STEP 1: ASSET SELECTION */}
          {step === 1 && (
            <div className="space-y-6 animate-in fade-in">
              <div className="bg-blue-50 border border-blue-200 rounded-2xl p-5 text-blue-900 space-y-1">
                <h4 className="font-bold text-base sm:text-lg flex items-center">
                  <ShieldCheck className="w-5 h-5 mr-2 text-blue-700" />
                  Paso 1: ¿Qué equipo o activo vamos a evaluar?
                </h4>
                <p className="text-sm text-blue-800">
                  Puedes seleccionar un activo que ya exista en el inventario de 334 equipos o registrar uno completamente nuevo.
                </p>
              </div>

              <div className="flex space-x-4 border-b border-slate-200 pb-3">
                <button
                  type="button"
                  onClick={() => setMode('select')}
                  className={`px-4 py-2 font-bold text-sm sm:text-base rounded-xl transition-all ${
                    mode === 'select' ? 'bg-blue-600 text-white' : 'bg-slate-100 text-slate-700 hover:bg-slate-200'
                  }`}
                >
                  Seleccionar del Inventario Existente ({activos.length})
                </button>
                <button
                  type="button"
                  onClick={() => setMode('new')}
                  className={`px-4 py-2 font-bold text-sm sm:text-base rounded-xl transition-all ${
                    mode === 'new' ? 'bg-blue-600 text-white' : 'bg-slate-100 text-slate-700 hover:bg-slate-200'
                  }`}
                >
                  + Registrar Nuevo Activo
                </button>
              </div>

              {mode === 'select' ? (
                <div className="space-y-4">
                  <div>
                    <label className="block text-sm font-bold text-slate-800 mb-1.5">
                      Buscar y Seleccionar Activo a Evaluar:
                    </label>
                    <select
                      value={selectedTag}
                      onChange={(e) => setSelectedTag(e.target.value)}
                      className="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-3 text-sm sm:text-base text-slate-900 font-bold focus:outline-none focus:border-blue-600"
                    >
                      {activos.map(a => (
                        <option key={a.tag_pdvsa} value={a.tag_pdvsa}>
                          {a.tag_pdvsa} — {a.nombre} [{a.laboratorio}]
                        </option>
                      ))}
                    </select>
                  </div>

                  {targetAsset && (
                    <div className="p-5 bg-slate-50 rounded-2xl border border-slate-200 grid grid-cols-2 sm:grid-cols-4 gap-4 text-xs sm:text-sm">
                      <div>
                        <span className="text-slate-500 font-semibold block uppercase tracking-wider text-[11px]">Código SUDEBIP</span>
                        <span className="font-bold text-emerald-800 font-mono text-sm">{targetAsset.codigo_sudebip || 'S/C'}</span>
                      </div>
                      <div>
                        <span className="text-slate-500 font-semibold block uppercase tracking-wider text-[11px]">Laboratorio</span>
                        <span className="font-bold text-slate-800 text-sm">{targetAsset.laboratorio}</span>
                      </div>
                      <div>
                        <span className="text-slate-500 font-semibold block uppercase tracking-wider text-[11px]">Marca / Modelo</span>
                        <span className="font-bold text-slate-800 text-sm">{targetAsset.marca} {targetAsset.modelo}</span>
                      </div>
                      <div>
                        <span className="text-slate-500 font-semibold block uppercase tracking-wider text-[11px]">Estado Actual</span>
                        <span className="font-bold text-blue-700 text-sm">{targetAsset.categoria_criticidad || 'Pendiente de Evaluación'}</span>
                      </div>
                    </div>
                  )}
                </div>
              ) : (
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                  <div>
                    <label className="block text-sm font-bold text-slate-800 mb-1">Nombre del Equipo *</label>
                    <input
                      type="text"
                      placeholder="Ej. Cromatógrafo de Gases"
                      value={newAssetData.nombre}
                      onChange={(e) => setNewAssetData({ ...newAssetData, nombre: e.target.value })}
                      className="w-full bg-slate-50 border border-slate-300 rounded-xl p-2.5 text-sm"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-bold text-slate-800 mb-1">TAG PDVSA *</label>
                    <input
                      type="text"
                      placeholder="Ej. INT-GAMB-AGUA-CRO01"
                      value={newAssetData.tag_pdvsa}
                      onChange={(e) => setNewAssetData({ ...newAssetData, tag_pdvsa: e.target.value })}
                      className="w-full bg-slate-50 border border-slate-300 rounded-xl p-2.5 text-sm font-mono"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-bold text-slate-800 mb-1">Código SUDEBIP</label>
                    <input
                      type="text"
                      placeholder="Ej. 18010-0001"
                      value={newAssetData.codigo_sudebip}
                      onChange={(e) => setNewAssetData({ ...newAssetData, codigo_sudebip: e.target.value })}
                      className="w-full bg-slate-50 border border-slate-300 rounded-xl p-2.5 text-sm font-mono"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-bold text-slate-800 mb-1">Laboratorio</label>
                    <input
                      type="text"
                      placeholder="Ej. Calidad de Agua"
                      value={newAssetData.laboratorio}
                      onChange={(e) => setNewAssetData({ ...newAssetData, laboratorio: e.target.value })}
                      className="w-full bg-slate-50 border border-slate-300 rounded-xl p-2.5 text-sm"
                    />
                  </div>
                </div>
              )}
            </div>
          )}

          {/* STEP 2: CRITICALITY EVALUATION (5 QUESTIONS) */}
          {step === 2 && (
            <div className="space-y-6 animate-in fade-in">
              <div className="bg-amber-50 border border-amber-200 rounded-2xl p-5 text-amber-950 space-y-1">
                <h4 className="font-bold text-base sm:text-lg flex items-center text-amber-900">
                  <Activity className="w-5 h-5 mr-2 text-amber-700" />
                  Paso 2: Evaluación de Criticidad (Norma PDVSA MM-02-01-01)
                </h4>
                <p className="text-sm text-amber-800">
                  Responde estas 5 preguntas prácticas. La herramienta calculará automáticamente el Índice de Criticidad (IC) y clasificará el activo en Clase A, B o C.
                </p>
              </div>

              {/* 5 Questions */}
              <div className="space-y-5">
                
                {/* Q1: FF */}
                <div className="p-4 rounded-xl bg-slate-50 border border-slate-200 space-y-2">
                  <label className="block text-sm font-bold text-slate-900">
                    1. ¿Con qué frecuencia falla este equipo durante el año? (Frecuencia de Falla - FF)
                  </label>
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-2 text-sm">
                    {[
                      { val: 4, label: 'Alta: Más de 2 fallas al año' },
                      { val: 3, label: 'Media: Entre 1 y 2 fallas al año' },
                      { val: 2, label: 'Baja: Entre 0.5 y 1 falla al año' },
                      { val: 1, label: 'Excelente: Menos de 0.5 fallas al año' }
                    ].map(opt => (
                      <button
                        key={opt.val}
                        type="button"
                        onClick={() => setCritScores({ ...critScores, ff: opt.val })}
                        className={`p-3 rounded-xl border text-left font-medium transition-all ${
                          critScores.ff === opt.val
                            ? 'bg-blue-600 text-white border-blue-700 shadow-sm'
                            : 'bg-white border-slate-300 text-slate-700 hover:border-blue-400'
                        }`}
                      >
                        {opt.label}
                      </button>
                    ))}
                  </div>
                </div>

                {/* Q2: IO */}
                <div className="p-4 rounded-xl bg-slate-50 border border-slate-200 space-y-2">
                  <label className="block text-sm font-bold text-slate-900">
                    2. Si el equipo falla, ¿cuál es el impacto en la operación del laboratorio? (Impacto Operacional - IO)
                  </label>
                  <div className="grid grid-cols-1 sm:grid-cols-3 gap-2 text-sm">
                    {[
                      { val: 10, label: 'Parada Total: El laboratorio se detiene por completo' },
                      { val: 5, label: 'Parada Parcial: Se reduce la capacidad analítica' },
                      { val: 1, label: 'Sin Impacto: No afecta las entregas del laboratorio' }
                    ].map(opt => (
                      <button
                        key={opt.val}
                        type="button"
                        onClick={() => setCritScores({ ...critScores, io: opt.val })}
                        className={`p-3 rounded-xl border text-left font-medium transition-all ${
                          critScores.io === opt.val
                            ? 'bg-blue-600 text-white border-blue-700 shadow-sm'
                            : 'bg-white border-slate-300 text-slate-700 hover:border-blue-400'
                        }`}
                      >
                        {opt.label}
                      </button>
                    ))}
                  </div>
                </div>

                {/* Q3: FO */}
                <div className="p-4 rounded-xl bg-slate-50 border border-slate-200 space-y-2">
                  <label className="block text-sm font-bold text-slate-900">
                    3. ¿Existe otro equipo o laboratorio que pueda respaldar este análisis? (Flexibilidad Operacional - FO)
                  </label>
                  <div className="grid grid-cols-1 sm:grid-cols-3 gap-2 text-sm">
                    {[
                      { val: 4, label: 'Sin Respaldo (0%): Es el único equipo disponible' },
                      { val: 2, label: 'Respaldo Parcial: Hay opción pero con demora o limitaciones' },
                      { val: 1, label: 'Respaldo Total (100%): Tenemos equipo gemelo de respaldo' }
                    ].map(opt => (
                      <button
                        key={opt.val}
                        type="button"
                        onClick={() => setCritScores({ ...critScores, fo: opt.val })}
                        className={`p-3 rounded-xl border text-left font-medium transition-all ${
                          critScores.fo === opt.val
                            ? 'bg-blue-600 text-white border-blue-700 shadow-sm'
                            : 'bg-white border-slate-300 text-slate-700 hover:border-blue-400'
                        }`}
                      >
                        {opt.label}
                      </button>
                    ))}
                  </div>
                </div>

                {/* Q4: CM */}
                <div className="p-4 rounded-xl bg-slate-50 border border-slate-200 space-y-2">
                  <label className="block text-sm font-bold text-slate-900">
                    4. ¿Qué tan costoso es reparar o reponer este equipo? (Costo de Mantenimiento - CM)
                  </label>
                  <div className="grid grid-cols-1 sm:grid-cols-3 gap-2 text-sm">
                    {[
                      { val: 3, label: 'Elevado: Repuestos importados o > 10.000 USD' },
                      { val: 2, label: 'Moderado: Costo intermedio reparable' },
                      { val: 1, label: 'Bajo: Consumibles rutinarios < 1.000 USD' }
                    ].map(opt => (
                      <button
                        key={opt.val}
                        type="button"
                        onClick={() => setCritScores({ ...critScores, cm: opt.val })}
                        className={`p-3 rounded-xl border text-left font-medium transition-all ${
                          critScores.cm === opt.val
                            ? 'bg-blue-600 text-white border-blue-700 shadow-sm'
                            : 'bg-white border-slate-300 text-slate-700 hover:border-blue-400'
                        }`}
                      >
                        {opt.label}
                      </button>
                    ))}
                  </div>
                </div>

                {/* Q5: SHA */}
                <div className="p-4 rounded-xl bg-slate-50 border border-slate-200 space-y-2">
                  <label className="block text-sm font-bold text-slate-900">
                    5. Si falla, ¿genera riesgos de fuga de gases, sustancias tóxicas o daño ambiental? (Impacto SHA)
                  </label>
                  <div className="grid grid-cols-1 sm:grid-cols-3 gap-2 text-sm">
                    {[
                      { val: 8, label: 'Severo: Riesgo ambiental grave o para el personal' },
                      { val: 4, label: 'Mitigable: Incidente menor o controlable' },
                      { val: 1, label: 'Sin Afectación: Cero impacto de seguridad o ambiental' }
                    ].map(opt => (
                      <button
                        key={opt.val}
                        type="button"
                        onClick={() => setCritScores({ ...critScores, sha: opt.val })}
                        className={`p-3 rounded-xl border text-left font-medium transition-all ${
                          critScores.sha === opt.val
                            ? 'bg-blue-600 text-white border-blue-700 shadow-sm'
                            : 'bg-white border-slate-300 text-slate-700 hover:border-blue-400'
                        }`}
                      >
                        {opt.label}
                      </button>
                    ))}
                  </div>
                </div>

              </div>

              {/* Dynamic Calculation Result Banner */}
              <div className="p-5 rounded-2xl bg-slate-900 text-white flex flex-col sm:flex-row justify-between items-center gap-4">
                <div>
                  <span className="text-xs text-slate-400 uppercase tracking-wider block font-bold">Cálculo en Tiempo Real PDVSA MM-02-01-01</span>
                  <div className="text-base sm:text-lg font-bold mt-1">
                    Consecuencia: <span className="font-mono text-blue-400">{consecuenciaCalc}</span> • Índice de Criticidad (IC): <span className="font-mono text-amber-400 text-xl">{criticidadCalc.ic}</span>
                  </div>
                </div>

                <div className={`px-4 py-2 rounded-xl text-sm sm:text-base font-black uppercase tracking-wider ${
                  criticidadCalc.categoria.includes('Nivel A') ? 'bg-red-600 text-white' :
                  criticidadCalc.categoria.includes('Nivel B') ? 'bg-amber-500 text-white' :
                  'bg-emerald-600 text-white'
                }`}>
                  {criticidadCalc.categoria}
                </div>
              </div>
            </div>
          )}

          {/* STEP 3: OBSOLESCENCE EVALUATION (4 QUESTIONS) */}
          {step === 3 && (
            <div className="space-y-6 animate-in fade-in">
              <div className="bg-orange-50 border border-orange-200 rounded-2xl p-5 text-orange-950 space-y-1">
                <h4 className="font-bold text-base sm:text-lg flex items-center text-orange-900">
                  <Clock className="w-5 h-5 mr-2 text-orange-700" />
                  Paso 3: Evaluación de Obsolescencia Tecnológica (ISO 55001)
                </h4>
                <p className="text-sm text-orange-800">
                  Aquí evaluamos si el activo ya cumplió su vida útil de diseño y si el fabricante aún le da soporte tecnológico.
                </p>
              </div>

              {/* 4 Questions */}
              <div className="space-y-5">
                
                {/* Q1: EOL */}
                <div className="p-4 rounded-xl bg-slate-50 border border-slate-200 space-y-2">
                  <label className="block text-sm font-bold text-slate-900">
                    1. ¿El fabricante aún da soporte técnico oficial a este modelo? (Soporte Tecnológico - EOL)
                  </label>
                  <div className="grid grid-cols-1 sm:grid-cols-3 gap-2 text-sm">
                    {[
                      { val: 3, label: 'Descontinuado: Sin soporte OEM ni actualizaciones' },
                      { val: 2, label: 'Soporte Limitado: Anunciado en fase de retiro' },
                      { val: 1, label: 'Producción Activa: Soporte total y repuestos garantizados' }
                    ].map(opt => (
                      <button
                        key={opt.val}
                        type="button"
                        onClick={() => setObsScores({ ...obsScores, eol: opt.val })}
                        className={`p-3 rounded-xl border text-left font-medium transition-all ${
                          obsScores.eol === opt.val
                            ? 'bg-blue-600 text-white border-blue-700 shadow-sm'
                            : 'bg-white border-slate-300 text-slate-700 hover:border-blue-400'
                        }`}
                      >
                        {opt.label}
                      </button>
                    ))}
                  </div>
                </div>

                {/* Q2: REP */}
                <div className="p-4 rounded-xl bg-slate-50 border border-slate-200 space-y-2">
                  <label className="block text-sm font-bold text-slate-900">
                    2. ¿Se consiguen repuestos con facilidad en el mercado? (Disponibilidad de Repuestos - REP)
                  </label>
                  <div className="grid grid-cols-1 sm:grid-cols-3 gap-2 text-sm">
                    {[
                      { val: 3, label: 'Crítico: Ya no se fabrican o no hay repuestos' },
                      { val: 2, label: 'Dificultad Alta: Importación demorada y costosa' },
                      { val: 1, label: 'Alta Disponibilidad: Se consiguen localmente sin demora' }
                    ].map(opt => (
                      <button
                        key={opt.val}
                        type="button"
                        onClick={() => setObsScores({ ...obsScores, rep: opt.val })}
                        className={`p-3 rounded-xl border text-left font-medium transition-all ${
                          obsScores.rep === opt.val
                            ? 'bg-blue-600 text-white border-blue-700 shadow-sm'
                            : 'bg-white border-slate-300 text-slate-700 hover:border-blue-400'
                        }`}
                      >
                        {opt.label}
                      </button>
                    ))}
                  </div>
                </div>

                {/* Q3: MET */}
                <div className="p-4 rounded-xl bg-slate-50 border border-slate-200 space-y-2">
                  <label className="block text-sm font-bold text-slate-900">
                    3. ¿Cómo está su calibración y precisión metrológica? (Condición Metrológica - ISO 10012)
                  </label>
                  <div className="grid grid-cols-1 sm:grid-cols-3 gap-2 text-sm">
                    {[
                      { val: 3, label: 'Fuera de Tolerancia: Descalibrado o deriva no corregible' },
                      { val: 2, label: 'Ajuste Frecuente: Pierde calibración a menudo' },
                      { val: 1, label: 'Calibrado: Certificado vigente y dentro de norma' }
                    ].map(opt => (
                      <button
                        key={opt.val}
                        type="button"
                        onClick={() => setObsScores({ ...obsScores, met: opt.val })}
                        className={`p-3 rounded-xl border text-left font-medium transition-all ${
                          obsScores.met === opt.val
                            ? 'bg-blue-600 text-white border-blue-700 shadow-sm'
                            : 'bg-white border-slate-300 text-slate-700 hover:border-blue-400'
                        }`}
                      >
                        {opt.label}
                      </button>
                    ))}
                  </div>
                </div>

                {/* Q4: ANT */}
                <div className="p-4 rounded-xl bg-slate-50 border border-slate-200 space-y-2">
                  <label className="block text-sm font-bold text-slate-900">
                    4. ¿Cuántos años de vida útil ha consumido el equipo? (Antigüedad - ANT)
                  </label>
                  <div className="grid grid-cols-1 sm:grid-cols-3 gap-2 text-sm">
                    {[
                      { val: 3, label: 'Superó Vida Útil: Ha consumido 100% o más de su vida de diseño' },
                      { val: 2, label: 'Envejecido: Entre el 50% y el 99% de vida consumida' },
                      { val: 1, label: 'Óptimo / Joven: Menos del 50% de vida consumida' }
                    ].map(opt => (
                      <button
                        key={opt.val}
                        type="button"
                        onClick={() => setObsScores({ ...obsScores, ant: opt.val })}
                        className={`p-3 rounded-xl border text-left font-medium transition-all ${
                          obsScores.ant === opt.val
                            ? 'bg-blue-600 text-white border-blue-700 shadow-sm'
                            : 'bg-white border-slate-300 text-slate-700 hover:border-blue-400'
                        }`}
                      >
                        {opt.label}
                      </button>
                    ))}
                  </div>
                </div>

              </div>

              {/* Dynamic Obsolescence Result */}
              <div className="p-5 rounded-2xl bg-slate-900 text-white flex flex-col sm:flex-row justify-between items-center gap-4">
                <div>
                  <span className="text-xs text-slate-400 uppercase tracking-wider block font-bold">Fórmula ISO 55001: [(EOL + REP + MET + ANT) / 12] x 100%</span>
                  <div className="text-base sm:text-lg font-bold mt-1">
                    Puntos Acumulados: <span className="font-mono text-blue-400">{obsolescenciaCalc.suma} / 12</span> • Índice (Iobs): <span className="font-mono text-orange-400 text-xl">{obsolescenciaCalc.iobs}%</span>
                  </div>
                </div>

                <div className={`px-4 py-2 rounded-xl text-sm sm:text-base font-black uppercase tracking-wider ${
                  obsolescenciaCalc.estatus === 'Obsolescencia Crítica' ? 'bg-red-600 text-white' :
                  obsolescenciaCalc.estatus === 'Obsolescencia Media' ? 'bg-amber-500 text-white' :
                  'bg-emerald-600 text-white'
                }`}>
                  {obsolescenciaCalc.estatus}
                </div>
              </div>
            </div>
          )}

          {/* STEP 4: SYSTEM VERDICT & STRATEGIC DECISION */}
          {step === 4 && (
            <div className="space-y-6 animate-in fade-in">
              <div className="bg-purple-50 border border-purple-200 rounded-2xl p-5 text-purple-950 space-y-1">
                <h4 className="font-bold text-base sm:text-lg flex items-center text-purple-900">
                  <GitFork className="w-5 h-5 mr-2 text-purple-700" />
                  Paso 4: ¡Dictamen Automático y Decisión Estratégica (SAMP)!
                </h4>
                <p className="text-sm text-purple-800">
                  La herramienta cruzó automáticamente la <strong>Criticidad</strong> con la <strong>Obsolescencia</strong> y dictamina la siguiente decisión para este activo:
                </p>
              </div>

              {/* Final Verdict Card */}
              <div className="p-6 rounded-2xl bg-white border-2 border-slate-300 shadow-md space-y-4">
                
                <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-3 border-b border-slate-100 pb-4">
                  <div>
                    <span className="text-xs font-bold text-slate-400 uppercase tracking-wider">Activo Evaluado</span>
                    <h5 className="text-xl font-black text-slate-900">{targetAsset.nombre}</h5>
                    <span className="font-mono text-xs font-bold text-blue-700 bg-blue-50 px-2.5 py-0.5 rounded border border-blue-200 mt-1 inline-block">
                      {targetAsset.tag_pdvsa} • SUDEBIP: {targetAsset.codigo_sudebip}
                    </span>
                  </div>

                  <span className={`px-4 py-2 rounded-xl text-sm font-black uppercase tracking-wider ${cruceCalc.badgeColor}`}>
                    {cruceCalc.resultadoCruce}
                  </span>
                </div>

                <div className="p-4 rounded-xl bg-slate-50 border border-slate-200 space-y-2">
                  <span className="text-xs font-bold text-slate-500 uppercase tracking-wider block">Decisión Estratégica Recomendada por la Norma:</span>
                  <p className="text-base sm:text-lg font-black text-slate-900 leading-snug">
                    {cruceCalc.decisionSugerida}
                  </p>
                </div>

                {/* Responsible & Target Date Assignment */}
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 pt-2">
                  <div>
                    <label className="block text-sm font-bold text-slate-800 mb-1 flex items-center">
                      <UserCheck className="w-4 h-4 mr-1 text-purple-700" />
                      Responsable de la Ejecución:
                    </label>
                    <input
                      type="text"
                      value={responsableDE}
                      onChange={(e) => setResponsableDE(e.target.value)}
                      className="w-full bg-slate-50 border border-slate-300 rounded-xl px-3.5 py-2.5 text-sm font-semibold text-slate-900"
                    />
                  </div>

                  <div>
                    <label className="block text-sm font-bold text-slate-800 mb-1">
                      Fecha Estimada de Cumplimiento:
                    </label>
                    <input
                      type="date"
                      value={fechaDE}
                      onChange={(e) => setFechaDE(e.target.value)}
                      className="w-full bg-slate-50 border border-slate-300 rounded-xl px-3.5 py-2.5 text-sm font-mono text-slate-900"
                    />
                  </div>
                </div>

              </div>

            </div>
          )}

        </div>

        {/* Wizard Footer Navigation Controls */}
        <div className="p-4 sm:p-5 bg-slate-50 border-t border-slate-200 flex justify-between items-center flex-shrink-0">
          <button
            type="button"
            disabled={step === 1}
            onClick={() => setStep((s) => (s > 1 ? (s - 1 as any) : s))}
            className="px-5 py-2.5 rounded-xl border border-slate-300 text-slate-700 hover:bg-white font-bold text-sm sm:text-base disabled:opacity-30 disabled:cursor-not-allowed flex items-center space-x-1"
          >
            <ChevronLeft className="w-5 h-5" />
            <span>Anterior</span>
          </button>

          <span className="text-xs sm:text-sm font-bold text-slate-500">
            Paso {step} de 4
          </span>

          {step < 4 ? (
            <button
              type="button"
              onClick={() => setStep((s) => (s < 4 ? (s + 1 as any) : s))}
              className="px-6 py-2.5 rounded-xl bg-blue-600 hover:bg-blue-700 text-white font-bold text-sm sm:text-base flex items-center space-x-1 shadow-md transition-all"
            >
              <span>Siguiente</span>
              <ChevronRight className="w-5 h-5" />
            </button>
          ) : (
            <button
              type="button"
              onClick={handleFinish}
              className="px-7 py-2.5 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white font-black text-sm sm:text-base flex items-center space-x-2 shadow-lg transition-all"
            >
              <Save className="w-5 h-5" />
              <span>Guardar y Aplicar al Inventario</span>
            </button>
          )}
        </div>

      </div>
    </div>
  );
};

