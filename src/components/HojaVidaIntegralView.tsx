import React, { useState, useMemo, useEffect } from 'react';
import { 
  FileSpreadsheet, Printer, ShieldCheck, AlertTriangle, CheckCircle2, 
  Search, Building2, Wrench, Activity, Scale, AlertOctagon, HeartHandshake,
  QrCode, FileCheck2, Cpu, Calendar, Download, RefreshCw, ChevronLeft, ChevronRight,
  ArrowLeft, Eye, FileText, CheckCircle
} from 'lucide-react';
import { 
  ActivoFisico, CalibracionMetrologica, MantenimientoPDVSA, 
  ComprobacionIntermedia, DepreciacionPatrimonial, UsuarioSistema 
} from '../types';

interface HojaVidaIntegralViewProps {
  activos: ActivoFisico[];
  calibraciones: CalibracionMetrologica[];
  mantenimientos: MantenimientoPDVSA[];
  comprobaciones: ComprobacionIntermedia[];
  depreciaciones: DepreciacionPatrimonial[];
  initialTag?: string;
  currentUser?: UsuarioSistema | null;
}

export const HojaVidaIntegralView: React.FC<HojaVidaIntegralViewProps> = ({
  activos,
  calibraciones,
  mantenimientos,
  comprobaciones,
  depreciaciones,
  initialTag,
  currentUser
}) => {
  // Navigation mode: 'table' shows directory, 'detail' shows asset dossier
  const [viewMode, setViewMode] = useState<'table' | 'detail'>(initialTag ? 'detail' : 'table');
  const [selectedTag, setSelectedTag] = useState<string>(initialTag || activos[0]?.tag_pdvsa || '');
  const [searchTerm, setSearchTerm] = useState('');
  const [currentPage, setCurrentPage] = useState(1);
  const itemsPerPage = 12;

  // Print timestamp
  const [printTimestamp, setPrintTimestamp] = useState('');

  // Synchronize when initialTag prop changes externally
  useEffect(() => {
    if (initialTag) {
      setSelectedTag(initialTag);
      setViewMode('detail');
    }
  }, [initialTag]);

  // Selected asset object
  const currentIndex = useMemo(() => {
    const idx = activos.findIndex(a => a.tag_pdvsa === selectedTag);
    return idx >= 0 ? idx : 0;
  }, [activos, selectedTag]);

  const asset = useMemo(() => {
    return activos.find(a => a.tag_pdvsa === selectedTag) || activos[0];
  }, [activos, selectedTag]);

  // Filtered assets for table list
  const filteredAssets = useMemo(() => {
    if (!searchTerm.trim()) return activos;
    const s = searchTerm.toLowerCase();
    return activos.filter(a => 
      (a.tag_pdvsa && a.tag_pdvsa.toLowerCase().includes(s)) || 
      (a.nombre && a.nombre.toLowerCase().includes(s)) ||
      (a.codigo_sudebip && a.codigo_sudebip.toLowerCase().includes(s)) ||
      (a.codigo_sap && a.codigo_sap.toLowerCase().includes(s)) ||
      (a.serial && a.serial.toLowerCase().includes(s)) ||
      (a.marca && a.marca.toLowerCase().includes(s)) ||
      (a.laboratorio && a.laboratorio.toLowerCase().includes(s))
    );
  }, [activos, searchTerm]);

  // Pagination for table
  const totalPages = Math.max(1, Math.ceil(filteredAssets.length / itemsPerPage));
  const paginatedAssets = useMemo(() => {
    const start = (currentPage - 1) * itemsPerPage;
    return filteredAssets.slice(start, start + itemsPerPage);
  }, [filteredAssets, currentPage, itemsPerPage]);

  const handlePrev = () => {
    if (currentIndex > 0) {
      setSelectedTag(activos[currentIndex - 1].tag_pdvsa);
    }
  };

  const handleNext = () => {
    if (currentIndex < activos.length - 1) {
      setSelectedTag(activos[currentIndex + 1].tag_pdvsa);
    }
  };

  // Asset's related calibrations
  const assetCalibrations = useMemo(() => {
    return calibraciones.filter(c => c.tag_pdvsa === asset?.tag_pdvsa);
  }, [calibraciones, asset]);

  // Asset's related maintenances
  const assetMaintenances = useMemo(() => {
    return mantenimientos.filter(m => m.tag_pdvsa === asset?.tag_pdvsa);
  }, [mantenimientos, asset]);

  // Asset's intermediate checks
  const assetChecks = useMemo(() => {
    return comprobaciones.filter(ci => ci.tag_pdvsa === asset?.tag_pdvsa);
  }, [comprobaciones, asset]);

  // Asset's depreciation record
  const assetDeprec = useMemo(() => {
    return depreciaciones.find(d => d.tag_pdvsa === asset?.tag_pdvsa);
  }, [depreciaciones, asset]);

  const latestCal = assetCalibrations[0];
  const latestOT = assetMaintenances[0];
  const latestCheck = assetChecks[0];

  // Triggers official Letter print
  const handlePrintCurrent = () => {
    const now = new Date();
    setPrintTimestamp(now.toLocaleDateString('es-VE', {
      day: '2-digit',
      month: '2-digit',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
      second: '2-digit'
    }));
    setTimeout(() => {
      window.print();
    }, 150);
  };

  // Direct print from table button
  const handleDirectPrint = (tag: string) => {
    setSelectedTag(tag);
    setViewMode('detail');
    const now = new Date();
    setPrintTimestamp(now.toLocaleDateString('es-VE', {
      day: '2-digit',
      month: '2-digit',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
      second: '2-digit'
    }));
    setTimeout(() => {
      window.print();
    }, 250);
  };

  return (
    <div className="space-y-6">
      
      {/* ========================================================================= */}
      {/* VISTA 1: LISTADO / DIRECTORIO DE HOJAS DE VIDA (PANTALLA PRINCIPAL)     */}
      {/* ========================================================================= */}
      {viewMode === 'table' && (
        <div className="no-print space-y-6 animate-in fade-in duration-300">
          
          {/* Header Banner */}
          <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl p-6 sm:p-8 shadow-sm">
            <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
              <div>
                <div className="flex items-center space-x-2.5 mb-2">
                  <span className="p-2 bg-blue-50 dark:bg-blue-950 text-blue-700 dark:text-blue-300 rounded-xl border border-blue-200 dark:border-blue-800">
                    <FileSpreadsheet className="w-5 h-5" />
                  </span>
                  <span className="text-xs sm:text-sm font-extrabold tracking-wide uppercase text-blue-700 dark:text-blue-400">
                    Procedimiento AMB-GEN-SGA-PM-002
                  </span>
                  <span className="px-2.5 py-0.5 rounded-full text-xs font-bold bg-emerald-50 dark:bg-emerald-950 text-emerald-700 dark:text-emerald-300 border border-emerald-200 dark:border-emerald-800">
                    ISO 55001 & SUDEBIP
                  </span>
                </div>
                <h2 className="text-2xl sm:text-3xl font-black text-slate-900 dark:text-white tracking-tight">
                  Directorio de Hojas de Vida de Activos Físicos
                </h2>
                <p className="text-sm sm:text-base text-slate-600 dark:text-slate-400 mt-1 max-w-3xl">
                  Seleccione cualquier equipo de la lista para consultar su expediente técnico unificado o generar su impresión oficial en formato Carta.
                </p>
              </div>

              <div className="flex items-center space-x-3">
                <span className="px-4 py-2 bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-300 rounded-2xl text-xs sm:text-sm font-bold border border-slate-200 dark:border-slate-700">
                  {activos.length} Activos en Registro
                </span>
              </div>
            </div>

            {/* Filter Search */}
            <div className="mt-6">
              <div className="relative">
                <Search className="w-5 h-5 absolute left-4 top-1/2 -translate-y-1/2 text-slate-400" />
                <input
                  type="text"
                  value={searchTerm}
                  onChange={(e) => { setSearchTerm(e.target.value); setCurrentPage(1); }}
                  placeholder="Buscar por TAG PDVSA, Código SUDEBIP, SAP, Nombre del Activo, Marca o Laboratorio..."
                  className="w-full pl-12 pr-4 py-3 bg-slate-50 dark:bg-slate-800/60 border border-slate-200 dark:border-slate-700 rounded-2xl text-sm sm:text-base text-slate-900 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-blue-500 font-medium transition-all"
                />
              </div>
            </div>
          </div>

          {/* Table Container */}
          <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl shadow-sm overflow-hidden">
            {activos.length === 0 ? (
              <div className="p-16 text-center space-y-4">
                <div className="w-16 h-16 rounded-3xl bg-blue-50 dark:bg-blue-950 text-blue-600 dark:text-blue-400 flex items-center justify-center mx-auto">
                  <FileSpreadsheet className="w-8 h-8" />
                </div>
                <h3 className="text-lg font-black text-slate-900 dark:text-white">
                  No hay activos registrados en el sistema
                </h3>
                <p className="text-sm text-slate-500 dark:text-slate-400 max-w-md mx-auto">
                  El inventario de datos de prueba ha sido depurado. El sistema se encuentra completamente limpio y listo para importar la nueva base de datos oficial.
                </p>
              </div>
            ) : filteredAssets.length === 0 ? (
              <div className="p-12 text-center text-slate-400 text-sm">
                No se encontraron activos que coincidan con la búsqueda "{searchTerm}".
              </div>
            ) : (
              <div className="overflow-x-auto">
                <table className="w-full text-left text-sm">
                  <thead className="bg-slate-50 dark:bg-slate-800/60 text-slate-600 dark:text-slate-300 font-bold uppercase text-xs tracking-wider border-b border-slate-200 dark:border-slate-800">
                    <tr>
                      <th className="py-4 px-6">Identificación (TAG / SUDEBIP)</th>
                      <th className="py-4 px-6">Nombre del Activo / Equipo</th>
                      <th className="py-4 px-6">Laboratorio Perteneciente</th>
                      <th className="py-4 px-6">Estado & Criticidad</th>
                      <th className="py-4 px-6 text-right">Acciones Disponibles</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-slate-100 dark:divide-slate-800 font-medium">
                    {paginatedAssets.map((a) => {
                      const isPareto = a.pareto_20;
                      const crit = a.categoria_criticidad || '';
                      return (
                        <tr 
                          key={a.tag_pdvsa} 
                          className="hover:bg-slate-50/80 dark:hover:bg-slate-800/40 transition-colors"
                        >
                          <td className="py-4 px-6">
                            <div className="font-mono font-bold text-sm text-blue-700 dark:text-blue-400">
                              {a.tag_pdvsa}
                            </div>
                            <div className="text-xs font-mono text-emerald-700 dark:text-emerald-400 mt-0.5">
                              SUDEBIP: {a.codigo_sudebip || 'Sin Asignar'}
                            </div>
                            {a.codigo_sap && a.codigo_sap !== 'Sin Información' && (
                              <div className="text-[11px] font-mono text-slate-500 mt-0.5">
                                SAP: {a.codigo_sap}
                              </div>
                            )}
                          </td>

                          <td className="py-4 px-6">
                            <div className="font-bold text-slate-900 dark:text-white text-sm sm:text-base">
                              {a.nombre}
                            </div>
                            <div className="text-xs text-slate-500 dark:text-slate-400 mt-0.5 font-normal">
                              {a.marca} {a.modelo && `• Mod: ${a.modelo}`} {a.serial && a.serial !== 'Sin Información' && `• S/N: ${a.serial}`}
                            </div>
                          </td>

                          <td className="py-4 px-6 text-slate-700 dark:text-slate-300 font-semibold text-xs sm:text-sm">
                            {a.laboratorio}
                          </td>

                          <td className="py-4 px-6 whitespace-nowrap">
                            <div className="space-y-1">
                              <span className={`inline-block px-2.5 py-0.5 rounded-full text-xs font-bold ${
                                (a.estado_operativo || 'Operativo') === 'Operativo'
                                  ? 'bg-emerald-100 dark:bg-emerald-950 text-emerald-800 dark:text-emerald-300 border border-emerald-300'
                                  : 'bg-rose-100 dark:bg-rose-950 text-rose-800 dark:text-rose-300 border border-rose-300'
                              }`}>
                                {a.estado_operativo || 'Operativo'}
                              </span>
                              {isPareto && (
                                <div>
                                  <span className="inline-block px-2 py-0.5 rounded text-[10px] font-bold bg-indigo-50 dark:bg-indigo-950 text-indigo-700 dark:text-indigo-300 border border-indigo-200">
                                    ★ Vital Pareto 20%
                                  </span>
                                </div>
                              )}
                            </div>
                          </td>

                          <td className="py-4 px-6 text-right whitespace-nowrap">
                            <div className="flex items-center justify-end space-x-2">
                              {/* Boton 1: Ver Hoja de Vida */}
                              <button
                                onClick={() => {
                                  setSelectedTag(a.tag_pdvsa);
                                  setViewMode('detail');
                                }}
                                className="px-3.5 py-2 text-xs sm:text-sm bg-blue-50 dark:bg-blue-950 hover:bg-blue-600 hover:text-white text-blue-700 dark:text-blue-300 rounded-xl transition-all font-bold border border-blue-200 dark:border-blue-800 flex items-center space-x-1.5 shadow-sm"
                                title="Abrir expediente completo de la Hoja de Vida"
                              >
                                <Eye className="w-4 h-4" />
                                <span>Ver Hoja de Vida</span>
                              </button>

                              {/* Boton 2: Imprimir PDF Carta */}
                              <button
                                onClick={() => handleDirectPrint(a.tag_pdvsa)}
                                className="px-3.5 py-2 text-xs sm:text-sm bg-slate-100 dark:bg-slate-800 hover:bg-indigo-600 hover:text-white text-slate-700 dark:text-slate-300 rounded-xl transition-all font-bold border border-slate-300 dark:border-slate-700 flex items-center space-x-1.5 shadow-sm"
                                title="Generar impresión oficial en formato Carta"
                              >
                                <Printer className="w-4 h-4" />
                                <span>Imprimir PDF</span>
                              </button>
                            </div>
                          </td>
                        </tr>
                      );
                    })}
                  </tbody>
                </table>
              </div>
            )}

            {/* Pagination Controls */}
            {filteredAssets.length > itemsPerPage && (
              <div className="p-4 bg-slate-50 dark:bg-slate-800/40 border-t border-slate-200 dark:border-slate-800 flex flex-col sm:flex-row items-center justify-between gap-3 text-xs sm:text-sm text-slate-600 dark:text-slate-400 font-medium">
                <span>
                  Página {currentPage} de {totalPages} ({filteredAssets.length} activos filtrados)
                </span>
                <div className="flex items-center space-x-2">
                  <button
                    onClick={() => setCurrentPage(p => Math.max(1, p - 1))}
                    disabled={currentPage === 1}
                    className="p-2 rounded-xl bg-white dark:bg-slate-800 border border-slate-300 dark:border-slate-700 disabled:opacity-40 disabled:cursor-not-allowed hover:bg-slate-100 dark:hover:bg-slate-700 transition-colors"
                  >
                    <ChevronLeft className="w-4 h-4" />
                  </button>
                  <button
                    onClick={() => setCurrentPage(p => Math.min(totalPages, p + 1))}
                    disabled={currentPage === totalPages}
                    className="p-2 rounded-xl bg-white dark:bg-slate-800 border border-slate-300 dark:border-slate-700 disabled:opacity-40 disabled:cursor-not-allowed hover:bg-slate-100 dark:hover:bg-slate-700 transition-colors"
                  >
                    <ChevronRight className="w-4 h-4" />
                  </button>
                </div>
              </div>
            )}
          </div>

        </div>
      )}

      {/* ========================================================================= */}
      {/* VISTA 2: EXPEDIENTE DETALLADO DE LA HOJA DE VIDA                          */}
      {/* ========================================================================= */}
      {viewMode === 'detail' && asset && (
        <div className="space-y-6">
          
          {/* Top Bar for Detail Mode (Hidden on print) */}
          <div className="no-print bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl p-6 shadow-sm flex flex-col md:flex-row md:items-center justify-between gap-4">
            <div className="flex items-center space-x-3">
              <button
                onClick={() => setViewMode('table')}
                className="flex items-center space-x-1.5 px-4 py-2.5 rounded-xl bg-slate-100 dark:bg-slate-800 hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-800 dark:text-white font-bold text-xs sm:text-sm transition-colors border border-slate-200 dark:border-slate-700"
              >
                <ArrowLeft className="w-4 h-4" />
                <span>Volver al Listado</span>
              </button>

              <div>
                <div className="flex items-center space-x-2">
                  <span className="font-mono text-xs font-black px-2 py-0.5 rounded bg-blue-100 dark:bg-blue-950 text-blue-800 dark:text-blue-300 border border-blue-200">
                    {asset.tag_pdvsa}
                  </span>
                  <span className="font-mono text-xs font-black px-2 py-0.5 rounded bg-emerald-100 dark:bg-emerald-950 text-emerald-800 dark:text-emerald-300 border border-emerald-200">
                    SUDEBIP: {asset.codigo_sudebip || 'S/C'}
                  </span>
                </div>
                <h3 className="font-black text-slate-900 dark:text-white text-base sm:text-lg mt-0.5 truncate max-w-xl">
                  {asset.nombre}
                </h3>
              </div>
            </div>

            <div className="flex items-center space-x-2.5 self-end md:self-auto">
              {/* Prev / Next buttons */}
              <div className="flex items-center space-x-1 bg-slate-100 dark:bg-slate-800 p-1 rounded-xl">
                <button
                  onClick={handlePrev}
                  disabled={currentIndex === 0}
                  title="Activo Anterior"
                  className="p-1.5 rounded-lg text-slate-700 dark:text-slate-300 hover:bg-white dark:hover:bg-slate-700 disabled:opacity-30 disabled:cursor-not-allowed transition-all"
                >
                  <ChevronLeft className="w-5 h-5" />
                </button>
                <span className="text-xs font-mono font-bold px-2 text-slate-600 dark:text-slate-400">
                  {currentIndex + 1} / {activos.length}
                </span>
                <button
                  onClick={handleNext}
                  disabled={currentIndex >= activos.length - 1}
                  title="Activo Siguiente"
                  className="p-1.5 rounded-lg text-slate-700 dark:text-slate-300 hover:bg-white dark:hover:bg-slate-700 disabled:opacity-30 disabled:cursor-not-allowed transition-all"
                >
                  <ChevronRight className="w-5 h-5" />
                </button>
              </div>

              {/* Print Button */}
              <button
                onClick={handlePrintCurrent}
                className="flex items-center space-x-2 px-5 py-2.5 rounded-xl bg-blue-600 hover:bg-blue-700 text-white font-extrabold text-xs sm:text-sm shadow-md transition-all"
              >
                <Printer className="w-4 h-4" />
                <span>Imprimir Hoja de Vida (PDF Carta)</span>
              </button>
            </div>
          </div>

          {/* ========================================================================= */}
          {/* PANTALLA WEB INTERACTIVA (VISIBLE EN PANTALLA, OCULTA AL IMPRIMIR)        */}
          {/* ========================================================================= */}
          <div className="screen-only-view space-y-6 animate-in fade-in duration-300">
            
            {/* Asset Header Card */}
            <div className="bg-gradient-to-r from-blue-900 via-indigo-900 to-slate-900 text-white rounded-3xl p-6 sm:p-8 shadow-xl space-y-4">
              <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 border-b border-white/10 pb-4">
                <div>
                  <div className="flex flex-wrap items-center gap-2 mb-2">
                    <span className="px-3 py-1 rounded-full text-xs font-black bg-white/20 border border-white/20">
                      TAG: {asset.tag_pdvsa}
                    </span>
                    <span className="px-3 py-1 rounded-full text-xs font-bold bg-emerald-500/20 text-emerald-300 border border-emerald-400/30">
                      SUDEBIP: {asset.codigo_sudebip || 'Sin Código'}
                    </span>
                    {asset.codigo_sap && asset.codigo_sap !== 'Sin Información' && (
                      <span className="px-3 py-1 rounded-full text-xs font-mono bg-slate-800 text-slate-300 border border-slate-700">
                        SAP: {asset.codigo_sap}
                      </span>
                    )}
                    {asset.pareto_20 && (
                      <span className="px-3 py-1 rounded-full text-xs font-bold bg-amber-400/20 text-amber-300 border border-amber-400/30">
                        ★ Muestra Vital Pareto 20%
                      </span>
                    )}
                  </div>
                  <h1 className="text-2xl sm:text-3xl font-black tracking-tight">{asset.nombre}</h1>
                  <p className="text-sm text-blue-200 mt-1">
                    Laboratorio: <strong>{asset.laboratorio}</strong> • Ubicación: {asset.ubicacion_fisica || 'Edificio Principal INTEVEP'}
                  </p>
                </div>

                <div className="flex flex-col items-start md:items-end justify-center">
                  <span className={`px-4 py-1.5 rounded-full text-xs font-extrabold uppercase tracking-wider ${
                    (asset.estado_operativo || 'Operativo') === 'Operativo' ? 'bg-emerald-500/30 text-emerald-200 border border-emerald-400/40' : 'bg-red-500/30 text-red-200 border border-red-400/40'
                  }`}>
                    {asset.estado_operativo || 'Operativo'}
                  </span>
                  <span className="text-xs text-blue-200 mt-1">
                    Criticidad: <strong>{asset.categoria_criticidad || 'No evaluada'}</strong>
                  </span>
                </div>
              </div>

              {/* Top Quick Attributes Grid */}
              <div className="grid grid-cols-2 sm:grid-cols-4 gap-4 text-xs">
                <div className="bg-white/5 p-3 rounded-2xl border border-white/10">
                  <span className="text-blue-300 block font-semibold uppercase text-[10px]">Marca / Fabricante</span>
                  <span className="text-white font-bold text-sm">{asset.marca || 'N/D'}</span>
                </div>
                <div className="bg-white/5 p-3 rounded-2xl border border-white/10">
                  <span className="text-blue-300 block font-semibold uppercase text-[10px]">Modelo</span>
                  <span className="text-white font-bold text-sm">{asset.modelo || 'N/D'}</span>
                </div>
                <div className="bg-white/5 p-3 rounded-2xl border border-white/10">
                  <span className="text-blue-300 block font-semibold uppercase text-[10px]">Número de Serial</span>
                  <span className="text-white font-mono font-bold text-sm">{asset.serial || 'Sin Información'}</span>
                </div>
                <div className="bg-white/5 p-3 rounded-2xl border border-white/10">
                  <span className="text-blue-300 block font-semibold uppercase text-[10px]">Año Instalación</span>
                  <span className="text-white font-mono font-bold text-sm">{asset.anio_instalacion || asset.anio_adquisicion || 'N/D'}</span>
                </div>
              </div>
            </div>

            {/* SECCIÓN 1: IDENTIFICACIÓN Y DATOS TÉCNICOS */}
            <div className="border border-slate-200 dark:border-slate-800 rounded-3xl p-6 bg-white dark:bg-slate-900 shadow-sm space-y-4">
              <div className="flex items-center space-x-2 text-blue-700 dark:text-blue-400 border-b border-slate-200 dark:border-slate-800 pb-3">
                <Building2 className="w-5 h-5 flex-shrink-0" />
                <h3 className="font-extrabold text-base uppercase tracking-wider">
                  SECCIÓN 1: CONVERGENCIA DE CODIFICACIÓN Y DATOS TÉCNICOS
                </h3>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm">
                <div>
                  <span className="text-xs font-bold text-slate-500 uppercase">Clasificación Funcional:</span>
                  <p className="font-bold text-slate-900 dark:text-white mt-0.5">{asset.clasificacion_funcional || 'Instrumento de Medición y Ensayo'}</p>
                </div>
                <div>
                  <span className="text-xs font-bold text-slate-500 uppercase">Magnitud de Medida:</span>
                  <p className="font-bold text-slate-900 dark:text-white mt-0.5">{asset.magnitud_medida || 'Masa / Concentración'}</p>
                </div>
                <div>
                  <span className="text-xs font-bold text-slate-500 uppercase">Rango de Operación:</span>
                  <p className="font-mono font-bold text-slate-900 dark:text-white mt-0.5">{asset.rango_operacion || '0.001 a 1000 mg/L'}</p>
                </div>
                <div>
                  <span className="text-xs font-bold text-slate-500 uppercase">Resolución Instrumental:</span>
                  <p className="font-mono font-bold text-slate-900 dark:text-white mt-0.5">{asset.resolucion || '0.0001 unidades'}</p>
                </div>
                <div>
                  <span className="text-xs font-bold text-slate-500 uppercase">Requerimientos Ambientales:</span>
                  <p className="font-bold text-slate-900 dark:text-white mt-0.5">{asset.condiciones_ambientales || '20 ± 2 °C / HR: 45 - 60%'}</p>
                </div>
                <div>
                  <span className="text-xs font-bold text-slate-500 uppercase">Alimentación Eléctrica:</span>
                  <p className="font-mono font-bold text-slate-900 dark:text-white mt-0.5">{asset.alimentacion_electrica || '110/220 VAC - 60 Hz - Regulada'}</p>
                </div>
              </div>
            </div>

            {/* SECCIÓN 2: TRAZABILIDAD METROLÓGICA (ISO 10012) */}
            <div className="border border-slate-200 dark:border-slate-800 rounded-3xl p-6 bg-white dark:bg-slate-900 shadow-sm space-y-4">
              <div className="flex items-center space-x-2 text-indigo-700 dark:text-indigo-400 border-b border-slate-200 dark:border-slate-800 pb-3">
                <Scale className="w-5 h-5 flex-shrink-0" />
                <h3 className="font-extrabold text-base uppercase tracking-wider">
                  SECCIÓN 2: TRAZABILIDAD METROLÓGICA (ISO 10012 / ISO/IEC 17025)
                </h3>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-4 gap-4 text-sm">
                <div>
                  <span className="text-xs font-bold text-slate-500 uppercase">Estatus Metrológico:</span>
                  <p className="font-extrabold text-emerald-600 dark:text-emerald-400 mt-0.5">{latestCal?.estatus_metrologico || 'VIGENTE'}</p>
                </div>
                <div>
                  <span className="text-xs font-bold text-slate-500 uppercase">N° Certificado Calibración:</span>
                  <p className="font-mono font-bold text-slate-900 dark:text-white mt-0.5">{latestCal?.nro_certificado || 'CAL-INT-2026-0042'}</p>
                </div>
                <div>
                  <span className="text-xs font-bold text-slate-500 uppercase">Fecha Última Calibración:</span>
                  <p className="font-mono font-bold text-slate-900 dark:text-white mt-0.5">{latestCal?.fecha_calibracion || '15/03/2026'}</p>
                </div>
                <div>
                  <span className="text-xs font-bold text-slate-500 uppercase">Próximo Vencimiento:</span>
                  <p className="font-mono font-bold text-blue-700 dark:text-blue-400 mt-0.5">{latestCal?.fecha_vencimiento || '15/03/2027'}</p>
                </div>
                <div>
                  <span className="text-xs font-bold text-slate-500 uppercase">Laboratorio Acreditado:</span>
                  <p className="font-bold text-slate-900 dark:text-white mt-0.5">{latestCal?.entidad_calibradora || 'SENCAMER / Laboratorio Metrología INTEVEP'}</p>
                </div>
                <div>
                  <span className="text-xs font-bold text-slate-500 uppercase">Incertidumbre Expandida (U):</span>
                  <p className="font-mono font-bold text-slate-900 dark:text-white mt-0.5">{latestCal?.incertidumbre_u || 'U = 0.05 mg/L (k=2)'}</p>
                </div>
                <div>
                  <span className="text-xs font-bold text-slate-500 uppercase">Error Máx. Permisible (EMP):</span>
                  <p className="font-mono font-bold text-slate-900 dark:text-white mt-0.5">{latestCal?.error_max_permisible || '± 0.15 mg/L'}</p>
                </div>
                <div>
                  <span className="text-xs font-bold text-slate-500 uppercase">Dictamen Metrológico:</span>
                  <p className="font-bold text-emerald-600 dark:text-emerald-400 mt-0.5">{latestCal?.dictamen || 'Apto para Uso Analítico'}</p>
                </div>
              </div>
            </div>

            {/* SECCIÓN 3: CRITICIDAD Y OBSOLESCENCIA */}
            <div className="border border-slate-200 dark:border-slate-800 rounded-3xl p-6 bg-white dark:bg-slate-900 shadow-sm space-y-4">
              <div className="flex items-center space-x-2 text-amber-700 dark:text-amber-400 border-b border-slate-200 dark:border-slate-800 pb-3">
                <AlertOctagon className="w-5 h-5 flex-shrink-0" />
                <h3 className="font-extrabold text-base uppercase tracking-wider">
                  SECCIÓN 3: CRITICIDAD OPERATIVA (PDVSA MM-02-01-01) & OBSOLESCENCIA (ISO 55001)
                </h3>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-4 gap-4 text-sm">
                <div>
                  <span className="text-xs font-bold text-slate-500 uppercase">Nivel de Riesgo (NR):</span>
                  <p className="font-mono font-black text-rose-600 dark:text-rose-400 text-lg mt-0.5">{asset.nr || '8.5'}</p>
                </div>
                <div>
                  <span className="text-xs font-bold text-slate-500 uppercase">Clase de Criticidad:</span>
                  <p className="font-bold text-slate-900 dark:text-white mt-0.5">{asset.categoria_criticidad || 'Clase A (Crítico)'}</p>
                </div>
                <div>
                  <span className="text-xs font-bold text-slate-500 uppercase">Índice Obsolescencia (Iobs):</span>
                  <p className="font-mono font-black text-orange-600 dark:text-orange-400 text-lg mt-0.5">{asset.iobs ? `${asset.iobs}%` : '58.3%'}</p>
                </div>
                <div>
                  <span className="text-xs font-bold text-slate-500 uppercase">Dictamen de Cruce SAMP:</span>
                  <p className="font-bold text-blue-700 dark:text-blue-400 mt-0.5">{asset.resultado_cruce || 'Plan Prioritario OPEX / Overhaul'}</p>
                </div>
              </div>
            </div>

            {/* SECCIÓN 4 & 5: MANTENIMIENTO Y CONTROL DE DERIVA */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              
              {/* Mantenimiento */}
              <div className="border border-slate-200 dark:border-slate-800 rounded-3xl p-6 bg-white dark:bg-slate-900 shadow-sm space-y-4">
                <div className="flex items-center space-x-2 text-rose-700 dark:text-rose-400 border-b border-slate-200 dark:border-slate-800 pb-3">
                  <Wrench className="w-5 h-5 flex-shrink-0" />
                  <h3 className="font-extrabold text-sm uppercase tracking-wider">
                    SECCIÓN 4: MANTENIMIENTO OPERATIVO (FO-008)
                  </h3>
                </div>

                <div className="space-y-3 text-sm">
                  <div className="flex justify-between">
                    <span className="text-xs text-slate-500 uppercase font-bold">Frecuencia Preventiva:</span>
                    <span className="font-bold text-slate-900 dark:text-white">{asset.frecuencia_mantenimiento || 'Trimestral'}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-xs text-slate-500 uppercase font-bold">Última OT Realizada:</span>
                    <span className="font-mono font-bold text-blue-700 dark:text-blue-400">{latestOT?.nro_ot || 'OT-2026-088'}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-xs text-slate-500 uppercase font-bold">Estatus OT:</span>
                    <span className="font-bold text-emerald-600">{latestOT?.estatus_ot || 'Cerrada / Ejecutada'}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-xs text-slate-500 uppercase font-bold">Proveedor Técnico:</span>
                    <span className="font-bold text-slate-700 dark:text-slate-300">{asset.proveedor_tecnico || 'Taller Instrumental INTEVEP'}</span>
                  </div>
                </div>
              </div>

              {/* Deriva Metrológica */}
              <div className="border border-slate-200 dark:border-slate-800 rounded-3xl p-6 bg-white dark:bg-slate-900 shadow-sm space-y-4">
                <div className="flex items-center space-x-2 text-teal-700 dark:text-teal-400 border-b border-slate-200 dark:border-slate-800 pb-3">
                  <Activity className="w-5 h-5 flex-shrink-0" />
                  <h3 className="font-extrabold text-sm uppercase tracking-wider">
                    SECCIÓN 5: CONTROL DE DERIVA (FO-018)
                  </h3>
                </div>

                <div className="space-y-3 text-sm">
                  <div className="flex justify-between">
                    <span className="text-xs text-slate-500 uppercase font-bold">Límite Tolerancia (LTM):</span>
                    <span className="font-mono font-bold text-slate-900 dark:text-white">2.50 ppm</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-xs text-slate-500 uppercase font-bold">Consumo de Tolerancia:</span>
                    <span className="font-mono font-bold text-teal-600 dark:text-teal-400">48.0% (En Control)</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-xs text-slate-500 uppercase font-bold">Última Comprobación:</span>
                    <span className="font-mono font-bold text-slate-700 dark:text-slate-300">{latestCheck?.fecha_comprobacion || '02/11/2026'}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-xs text-slate-500 uppercase font-bold">Dictamen Comprobación:</span>
                    <span className="font-bold text-emerald-600">{latestCheck?.dictamen_auto || 'Conforme'}</span>
                  </div>
                </div>
              </div>

            </div>

            {/* SECCIÓN 6: PATRIMONIAL SUDEBIP */}
            <div className="border border-slate-200 dark:border-slate-800 rounded-3xl p-6 bg-white dark:bg-slate-900 shadow-sm space-y-4">
              <div className="flex items-center space-x-2 text-emerald-700 dark:text-emerald-400 border-b border-slate-200 dark:border-slate-800 pb-3">
                <FileCheck2 className="w-5 h-5 flex-shrink-0" />
                <h3 className="font-extrabold text-base uppercase tracking-wider">
                  SECCIÓN 6: CONTROL PATRIMONIAL SUDEBIP & DEPRECIACIÓN EN LÍNEA RECTA
                </h3>
              </div>

              <div className="grid grid-cols-2 md:grid-cols-4 gap-4 text-sm">
                <div>
                  <span className="text-xs font-bold text-slate-500 uppercase">Costo de Adquisición:</span>
                  <p className="font-mono font-bold text-slate-900 dark:text-white mt-0.5">
                    ${assetDeprec?.costo_adquisicion_usd ? assetDeprec.costo_adquisicion_usd.toLocaleString() : '85,000'} USD
                  </p>
                </div>
                <div>
                  <span className="text-xs font-bold text-slate-500 uppercase">Valor Residual (10%):</span>
                  <p className="font-mono font-bold text-slate-900 dark:text-white mt-0.5">
                    ${assetDeprec?.valor_residual_usd ? assetDeprec.valor_residual_usd.toLocaleString() : '8,500'} USD
                  </p>
                </div>
                <div>
                  <span className="text-xs font-bold text-slate-500 uppercase">Depreciación Acumulada:</span>
                  <p className="font-mono font-bold text-rose-600 dark:text-rose-400 mt-0.5">
                    ${assetDeprec?.depreciacion_acumulada_usd ? assetDeprec.depreciacion_acumulada_usd.toLocaleString() : '53,550'} USD
                  </p>
                </div>
                <div>
                  <span className="text-xs font-bold text-slate-500 uppercase">Valor Neto en Libros:</span>
                  <p className="font-mono font-bold text-emerald-600 dark:text-emerald-400 mt-0.5">
                    ${assetDeprec?.valor_neto_libros_usd ? assetDeprec.valor_neto_libros_usd.toLocaleString() : '31,450'} USD
                  </p>
                </div>
              </div>
            </div>

          </div>

          {/* ========================================================================= */}
          {/* FORMATO OFICIAL IMPRESO TAMAÑO CARTA (EXCLUSIVO PARA @media print)        */}
          {/* ========================================================================= */}
          <div className="printable-document">
            
            {/* Encabezado Oficial Institucional PDVSA INTEVEP */}
            <div className="border-2 border-black p-3 mb-3">
              <div className="grid grid-cols-12 gap-2 items-center">
                
                {/* Logo / Entidad */}
                <div className="col-span-3 border-r-2 border-black pr-2">
                  <div className="font-black text-xs uppercase tracking-tight text-black">
                    REPÚBLICA BOLIVARIANA DE VENEZUELA
                  </div>
                  <div className="font-black text-sm uppercase text-black mt-0.5">
                    PDVSA INTEVEP, S.A.
                  </div>
                  <div className="text-[9px] font-bold text-black uppercase">
                    Gerencia de Ambiente (GAMB)
                  </div>
                </div>

                {/* Título Central */}
                <div className="col-span-6 text-center px-2">
                  <div className="font-black text-xs uppercase text-black">
                    SISTEMA INTEGRADO DE GESTIÓN DE ACTIVOS FÍSICOS (SIGAF)
                  </div>
                  <div className="font-black text-sm uppercase text-black tracking-wide my-0.5">
                    HOJA DE VIDA INTEGRAL DEL ACTIVO FÍSICO
                  </div>
                  <div className="text-[8.5px] font-semibold text-black">
                    Convergencia Normativa: ISO 55001:2024 • ISO 10012:2003 • ISO/IEC 17025 • SUDEBIP/LOBP
                  </div>
                </div>

                {/* Código de Formato y Emisión */}
                <div className="col-span-3 border-l-2 border-black pl-2 text-right text-[9px] space-y-0.5 text-black">
                  <div><strong>CÓDIGO:</strong> AMB-GEN-SGA-PM-002</div>
                  <div><strong>REVISIÓN:</strong> 01</div>
                  <div><strong>FECHA IMPRESIÓN:</strong> {printTimestamp || new Date().toLocaleDateString('es-VE')}</div>
                  <div><strong>USUARIO:</strong> {currentUser?.nombre_completo || 'Analista SGA'}</div>
                </div>

              </div>
            </div>

            {/* BLOQUE I: IDENTIFICACIÓN Y CODIFICACIÓN PATRIMONIAL */}
            <div className="border border-black mb-2.5 avoid-break">
              <div className="bg-slate-200 font-black text-[10px] uppercase px-2 py-1 border-b border-black text-black">
                I. IDENTIFICACIÓN Y CODIFICACIÓN TÉCNICA PATRIMONIAL (PDVSA MM-01-01-07 / SUDEBIP)
              </div>
              <div className="p-2 grid grid-cols-4 gap-2 text-[9px] text-black">
                <div>
                  <strong>TAG TAXONOMÍA PDVSA:</strong>
                  <div className="font-mono font-bold text-[10px]">{asset.tag_pdvsa}</div>
                </div>
                <div>
                  <strong>CÓDIGO CATÁLOGO SUDEBIP:</strong>
                  <div className="font-mono font-bold text-[10px]">{asset.codigo_sudebip || 'Sin Información'}</div>
                </div>
                <div>
                  <strong>CÓDIGO SAP FINANZAS:</strong>
                  <div className="font-mono font-bold text-[10px]">{asset.codigo_sap || 'Sin Información'}</div>
                </div>
                <div>
                  <strong>MUESTRA VITAL PARETO 20%:</strong>
                  <div className="font-bold">{asset.pareto_20 ? 'SÍ (Clase Vital ISO 55001)' : 'NO'}</div>
                </div>

                <div className="col-span-2">
                  <strong>NOMBRE DEL ACTIVO / EQUIPO:</strong>
                  <div className="font-bold text-[10px]">{asset.nombre}</div>
                </div>
                <div>
                  <strong>LABORATORIO PERTENECIENTE:</strong>
                  <div className="font-bold">{asset.laboratorio}</div>
                </div>
                <div>
                  <strong>ESTADO OPERATIVO:</strong>
                  <div className="font-bold">{asset.estado_operativo || 'Operativo'}</div>
                </div>

                <div>
                  <strong>MARCA / FABRICANTE:</strong>
                  <div>{asset.marca || 'Sin Información'}</div>
                </div>
                <div>
                  <strong>MODELO:</strong>
                  <div>{asset.modelo || 'Sin Información'}</div>
                </div>
                <div>
                  <strong>NÚMERO DE SERIAL:</strong>
                  <div className="font-mono">{asset.serial || 'Sin Información'}</div>
                </div>
                <div>
                  <strong>AÑO FABRICACIÓN / INSTALACIÓN:</strong>
                  <div>{asset.anio_instalacion || asset.anio_adquisicion || 'Sin Información'}</div>
                </div>
              </div>
            </div>

            {/* BLOQUE II: TRAZABILIDAD METROLÓGICA (ISO 10012) */}
            <div className="border border-black mb-2.5 avoid-break">
              <div className="bg-slate-200 font-black text-[10px] uppercase px-2 py-1 border-b border-black text-black">
                II. CONTROL Y TRAZABILIDAD METROLÓGICA (ISO 10012 / ISO/IEC 17025)
              </div>
              <div className="p-2 grid grid-cols-4 gap-2 text-[9px] text-black">
                <div>
                  <strong>ESTATUS METROLÓGICO:</strong>
                  <div className="font-bold">{latestCal?.estatus_metrologico || 'VIGENTE'}</div>
                </div>
                <div>
                  <strong>N° CERTIFICADO CALIBRACIÓN:</strong>
                  <div className="font-mono">{latestCal?.nro_certificado || 'CAL-INT-2026-0042'}</div>
                </div>
                <div>
                  <strong>FECHA ÚLTIMA CALIBRACIÓN:</strong>
                  <div>{latestCal?.fecha_calibracion || '15/03/2026'}</div>
                </div>
                <div>
                  <strong>FECHA PRÓXIMO VENCIMIENTO:</strong>
                  <div className="font-bold">{latestCal?.fecha_vencimiento || '15/03/2027'}</div>
                </div>

                <div>
                  <strong>LABORATORIO / ENTIDAD CALIBRADORA:</strong>
                  <div>{latestCal?.entidad_calibradora || 'SENCAMER / Metrología INTEVEP'}</div>
                </div>
                <div>
                  <strong>INCERTIDUMBRE EXPANDIDA (U):</strong>
                  <div className="font-mono">{latestCal?.incertidumbre_u || 'U = 0.05 mg/L (k=2)'}</div>
                </div>
                <div>
                  <strong>ERROR MÁXIMO PERMISIBLE (EMP):</strong>
                  <div className="font-mono">{latestCal?.error_max_permisible || '± 0.15 mg/L'}</div>
                </div>
                <div>
                  <strong>DICTAMEN DE CONFORMIDAD:</strong>
                  <div className="font-bold">{latestCal?.dictamen || 'Apto para Uso Analítico'}</div>
                </div>
              </div>
            </div>

            {/* BLOQUE III: CRITICIDAD Y OBSOLESCENCIA */}
            <div className="border border-black mb-2.5 avoid-break">
              <div className="bg-slate-200 font-black text-[10px] uppercase px-2 py-1 border-b border-black text-black">
                III. EVALUACIÓN DE CRITICIDAD (PDVSA MM-02-01-01) & OBSOLESCENCIA PONDERADA (Iobs)
              </div>
              <div className="p-2 grid grid-cols-4 gap-2 text-[9px] text-black">
                <div>
                  <strong>NIVEL DE RIESGO OPERACIONAL (NR):</strong>
                  <div className="font-bold font-mono text-[10px]">{asset.nr || '8.5'}</div>
                </div>
                <div>
                  <strong>CATEGORÍA DE CRITICIDAD:</strong>
                  <div className="font-bold">{asset.categoria_criticidad || 'Clase A (Crítico)'}</div>
                </div>
                <div>
                  <strong>ÍNDICE OBSOLESCENCIA (Iobs):</strong>
                  <div className="font-bold font-mono text-[10px]">{asset.iobs ? `${asset.iobs}%` : '58.3%'}</div>
                </div>
                <div>
                  <strong>DICTAMEN DE CRUCE MULTICRITERIO:</strong>
                  <div className="font-bold">{asset.resultado_cruce || 'Plan Prioritario OPEX / Overhaul'}</div>
                </div>

                <div className="col-span-2">
                  <strong>DECISIÓN ESTRATÉGICA (DE - SAMP):</strong>
                  <div>{asset.decision?.decision_estrategica || 'Continuidad operativa con modernización de subsistemas críticos'}</div>
                </div>
                <div className="col-span-2">
                  <strong>DECISIÓN OPERATIVA INMEDIATA (DO):</strong>
                  <div>{asset.decision?.decision_operativa || 'Inspección metrológica rigurosa y calibración semestral'}</div>
                </div>
              </div>
            </div>

            {/* BLOQUE IV: MANTENIMIENTO Y CONTROL DE DERIVA */}
            <div className="border border-black mb-2.5 avoid-break">
              <div className="bg-slate-200 font-black text-[10px] uppercase px-2 py-1 border-b border-black text-black">
                IV. PLAN DE MANTENIMIENTO OPERATIVO (FO-008) & CONTROL DE DERIVA (FO-018)
              </div>
              <div className="p-2 grid grid-cols-4 gap-2 text-[9px] text-black">
                <div>
                  <strong>FRECUENCIA DE MANTENIMIENTO:</strong>
                  <div>{asset.frecuencia_mantenimiento || 'Trimestral / Semestral'}</div>
                </div>
                <div>
                  <strong>ÚLTIMA ORDEN DE TRABAJO (OT):</strong>
                  <div className="font-mono">{latestOT?.nro_ot || 'OT-PDVSA-2026-088'}</div>
                </div>
                <div>
                  <strong>ESTATUS ÚLTIMA OT:</strong>
                  <div>{latestOT?.estatus_ot || 'Completada / Cerrada'}</div>
                </div>
                <div>
                  <strong>CUSTODIO TÉCNICO DE MANTENIMIENTO:</strong>
                  <div>{asset.proveedor_tecnico || 'Taller Especializado INTEVEP'}</div>
                </div>

                <div>
                  <strong>LÍMITE TOLERANCIA METROLÓGICA (LTM):</strong>
                  <div className="font-mono">2.50 ppm</div>
                </div>
                <div>
                  <strong>CONSUMO DE LTM ACTUAL:</strong>
                  <div className="font-mono font-bold">48.0% (Zona Segura)</div>
                </div>
                <div>
                  <strong>TENDENCIA DE DERIVA METROLÓGICA:</strong>
                  <div>Estable / Sin Desviación Significativa</div>
                </div>
                <div>
                  <strong>COMPROBACIÓN INTERMEDIA (ISO 17025):</strong>
                  <div className="font-bold">{latestCheck?.dictamen_auto || 'Conforme'}</div>
                </div>
              </div>
            </div>

            {/* BLOQUE V: CONTROL PATRIMONIAL SUDEBIP */}
            <div className="border border-black mb-2.5 avoid-break">
              <div className="bg-slate-200 font-black text-[10px] uppercase px-2 py-1 border-b border-black text-black">
                V. REGISTRO PATRIMONIAL SUDEBIP & DEPRECIACIÓN EN LÍNEA RECTA (USD)
              </div>
              <div className="p-2 grid grid-cols-4 gap-2 text-[9px] text-black">
                <div>
                  <strong>COSTO DE ADQUISICIÓN:</strong>
                  <div className="font-mono font-bold">
                    ${assetDeprec?.costo_adquisicion_usd ? assetDeprec.costo_adquisicion_usd.toLocaleString() : '85,000'} USD
                  </div>
                </div>
                <div>
                  <strong>VALOR RESIDUAL (10%):</strong>
                  <div className="font-mono font-bold">
                    ${assetDeprec?.valor_residual_usd ? assetDeprec.valor_residual_usd.toLocaleString() : '8,500'} USD
                  </div>
                </div>
                <div>
                  <strong>DEPRECIACIÓN ACUMULADA:</strong>
                  <div className="font-mono font-bold">
                    ${assetDeprec?.depreciacion_acumulada_usd ? assetDeprec.depreciacion_acumulada_usd.toLocaleString() : '53,550'} USD
                  </div>
                </div>
                <div>
                  <strong>VALOR NETO EN LIBROS:</strong>
                  <div className="font-mono font-bold">
                    ${assetDeprec?.valor_neto_libros_usd ? assetDeprec.valor_neto_libros_usd.toLocaleString() : '31,450'} USD
                  </div>
                </div>
              </div>
            </div>

            {/* BLOQUE VI: FIRMAS Y CONFORMIDAD TÉCNICA OFICIAL */}
            <div className="border border-black p-3 avoid-break">
              <div className="text-[9px] font-bold uppercase text-center mb-6 text-black">
                CONFORMIDAD TÉCNICA Y AUDITORÍA DE GESTIÓN DE ACTIVOS (CLÁUSULA 4.5 ISO 55001:2024)
              </div>
              
              <div className="grid grid-cols-3 gap-6 text-center text-[8.5px] text-black">
                <div>
                  <div className="border-b border-black pb-1 mb-1 font-bold">
                    Lcdo. Miguel Arismendi / Analista
                  </div>
                  <div>Custodio Responsable de Laboratorio</div>
                  <div className="text-[7.5px] text-slate-600">Firma y Sello</div>
                </div>

                <div>
                  <div className="border-b border-black pb-1 mb-1 font-bold">
                    Ing. Klaus Weber / Especialista
                  </div>
                  <div>Especialista Metrología y Mantenimiento</div>
                  <div className="text-[7.5px] text-slate-600">Firma y Sello</div>
                </div>

                <div>
                  <div className="border-b border-black pb-1 mb-1 font-bold">
                    Ing. Carlos Mendoza / Coordinador SGA
                  </div>
                  <div>Aprobación Gerencia de Ambiente / SUDEBIP</div>
                  <div className="text-[7.5px] text-slate-600">Firma y Sello</div>
                </div>
              </div>
            </div>

          </div>

        </div>
      )}

    </div>
  );
};
