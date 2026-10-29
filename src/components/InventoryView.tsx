import React, { useState, useMemo } from 'react';
import { 
  Search, Plus, Filter, Download, ExternalLink, 
  AlertTriangle, ShieldCheck, Wrench, ChevronLeft, ChevronRight, CheckCircle2
} from 'lucide-react';
import { ActivoFisico } from '../types';

interface InventoryViewProps {
  activos: ActivoFisico[];
  onSelectActivo: (activo: ActivoFisico) => void;
  onCreateActivo: () => void;
}

export const InventoryView: React.FC<InventoryViewProps> = ({
  activos,
  onSelectActivo,
  onCreateActivo
}) => {
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedLab, setSelectedLab] = useState('ALL');
  const [selectedPareto, setSelectedPareto] = useState('ALL');
  const [selectedCrit, setSelectedCrit] = useState('ALL');
  const [selectedObs, setSelectedObs] = useState('ALL');

  // Pagination
  const [currentPage, setCurrentPage] = useState(1);
  const itemsPerPage = 15;

  // Distinct Laboratories
  const labs = useMemo(() => {
    const set = new Set<string>();
    activos.forEach(a => { if (a.laboratorio) set.add(a.laboratorio); });
    return Array.from(set).sort();
  }, [activos]);

  // Filtered Assets
  const filtered = useMemo(() => {
    return activos.filter(a => {
      // Search
      const search = searchTerm.toLowerCase();
      const matchSearch = !searchTerm || (
        (a.nombre && a.nombre.toLowerCase().includes(search)) ||
        (a.tag_pdvsa && a.tag_pdvsa.toLowerCase().includes(search)) ||
        (a.codigo_sudebip && a.codigo_sudebip.toLowerCase().includes(search)) ||
        (a.codigo_sap && a.codigo_sap.toLowerCase().includes(search)) ||
        (a.marca && a.marca.toLowerCase().includes(search)) ||
        (a.serial && a.serial.toLowerCase().includes(search))
      );

      // Lab filter
      const matchLab = selectedLab === 'ALL' || a.laboratorio === selectedLab;

      // Pareto filter
      const matchPareto = selectedPareto === 'ALL' || (
        selectedPareto === 'PARETO' ? a.pareto_20 : !a.pareto_20
      );

      // Criticality filter
      const matchCrit = selectedCrit === 'ALL' || (
        a.categoria_criticidad && a.categoria_criticidad.includes(selectedCrit)
      );

      // Obsolescence filter
      const matchObs = selectedObs === 'ALL' || (
        a.estatus_obsolescencia && a.estatus_obsolescencia.includes(selectedObs)
      );

      return matchSearch && matchLab && matchPareto && matchCrit && matchObs;
    });
  }, [activos, searchTerm, selectedLab, selectedPareto, selectedCrit, selectedObs]);

  // Paginated slice
  const totalPages = Math.ceil(filtered.length / itemsPerPage) || 1;
  const paginatedActivos = useMemo(() => {
    const start = (currentPage - 1) * itemsPerPage;
    return filtered.slice(start, start + itemsPerPage);
  }, [filtered, currentPage]);

  const handleResetFilters = () => {
    setSearchTerm('');
    setSelectedLab('ALL');
    setSelectedPareto('ALL');
    setSelectedCrit('ALL');
    setSelectedObs('ALL');
    setCurrentPage(1);
  };

  return (
    <div className="space-y-6 animate-in fade-in duration-300">
      
      {/* Top Header - Light Theme High Contrast */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 bg-white border border-slate-200 p-6 sm:p-7 rounded-2xl shadow-sm">
        <div>
          <h2 className="text-2xl sm:text-3xl font-black text-slate-900 tracking-tight">
            Inventario Operativo y Hoja de Vida de Activos
          </h2>
          <p className="text-sm sm:text-base text-slate-500 mt-1 font-medium">
            Convergencia de Codificación SUDEBIP y Taxonomía PDVSA MM-01-01-07 / MM-02-01-01
          </p>
        </div>

        <button
          onClick={onCreateActivo}
          className="flex items-center justify-center space-x-2 bg-blue-600 hover:bg-blue-700 text-white font-bold px-5 py-3 rounded-xl shadow-md transition-all text-sm sm:text-base whitespace-nowrap self-stretch sm:self-auto"
        >
          <Plus className="w-5 h-5" />
          <span>Registrar Nuevo Activo</span>
        </button>
      </div>

      {/* Filter Bar */}
      <div className="bg-white border border-slate-200 p-5 rounded-2xl space-y-4 shadow-sm">
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-12 gap-3.5">
          
          {/* Search box */}
          <div className="lg:col-span-4 relative">
            <Search className="w-5 h-5 absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400" />
            <input
              type="text"
              placeholder="Buscar por TAG, SUDEBIP, SAP, nombre, serial..."
              value={searchTerm}
              onChange={(e) => { setSearchTerm(e.target.value); setCurrentPage(1); }}
              className="w-full bg-slate-50 border border-slate-300 rounded-xl pl-11 pr-4 py-2.5 text-sm sm:text-base text-slate-900 placeholder-slate-400 focus:outline-none focus:border-blue-600 focus:bg-white transition-all font-medium"
            />
          </div>

          {/* Lab filter */}
          <div className="lg:col-span-3">
            <select
              value={selectedLab}
              onChange={(e) => { setSelectedLab(e.target.value); setCurrentPage(1); }}
              className="w-full bg-slate-50 border border-slate-300 rounded-xl px-3.5 py-2.5 text-sm sm:text-base text-slate-800 focus:outline-none focus:border-blue-600 focus:bg-white transition-all font-medium"
            >
              <option value="ALL">Todos los Laboratorios ({labs.length})</option>
              {labs.map((l, i) => (
                <option key={i} value={l}>{l}</option>
              ))}
            </select>
          </div>

          {/* Pareto filter */}
          <div className="lg:col-span-2">
            <select
              value={selectedPareto}
              onChange={(e) => { setSelectedPareto(e.target.value); setCurrentPage(1); }}
              className="w-full bg-slate-50 border border-slate-300 rounded-xl px-3.5 py-2.5 text-sm sm:text-base text-slate-800 focus:outline-none focus:border-blue-600 focus:bg-white transition-all font-medium"
            >
              <option value="ALL">Muestra: Todas</option>
              <option value="PARETO">Solo Pareto 20% (Muestra Vital)</option>
              <option value="NO_PARETO">Fuera de Pareto (80%)</option>
            </select>
          </div>

          {/* Criticidad filter */}
          <div className="lg:col-span-2">
            <select
              value={selectedCrit}
              onChange={(e) => { setSelectedCrit(e.target.value); setCurrentPage(1); }}
              className="w-full bg-slate-50 border border-slate-300 rounded-xl px-3.5 py-2.5 text-sm sm:text-base text-slate-800 focus:outline-none focus:border-blue-600 focus:bg-white transition-all font-medium"
            >
              <option value="ALL">Criticidad: Todas</option>
              <option value="Nivel A">Clase A (Crítico)</option>
              <option value="Nivel B">Clase B (Semicrítico)</option>
              <option value="Nivel C">Clase C (No Crítico)</option>
            </select>
          </div>

          {/* Reset button */}
          <div className="lg:col-span-1 flex items-center">
            <button
              onClick={handleResetFilters}
              className="w-full py-2.5 px-3 bg-slate-100 hover:bg-slate-200 text-slate-700 text-sm sm:text-base rounded-xl transition-colors font-bold text-center"
              title="Limpiar filtros"
            >
              Limpiar
            </button>
          </div>

        </div>

        {/* Filter count summary */}
        <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center text-xs sm:text-sm text-slate-500 pt-3 border-t border-slate-100 gap-1 font-medium">
          <span>
            Mostrando <strong className="text-slate-900 font-bold">{filtered.length}</strong> de <strong className="text-slate-900 font-bold">{activos.length}</strong> activos registrados.
          </span>
          <span className="font-mono">
            Página {currentPage} de {totalPages}
          </span>
        </div>
      </div>

      {/* Asset Table - High Contrast Light Theme */}
      <div className="bg-white border border-slate-200 rounded-2xl overflow-hidden shadow-sm">
        <div className="overflow-x-auto">
          <table className="w-full text-left text-sm sm:text-base border-collapse">
            <thead>
              <tr className="bg-slate-50 text-slate-600 uppercase tracking-wider text-xs sm:text-sm border-b border-slate-200">
                <th className="py-4 px-4 font-bold">N°</th>
                <th className="py-4 px-4 font-bold">Convergencia de Codificación</th>
                <th className="py-4 px-4 font-bold">Nombre del Activo / Especificación</th>
                <th className="py-4 px-4 font-bold">Laboratorio</th>
                <th className="py-4 px-4 font-bold">Pareto 20%</th>
                <th className="py-4 px-4 font-bold">Criticidad PDVSA</th>
                <th className="py-4 px-4 font-bold">Obsolescencia (Iobs)</th>
                <th className="py-4 px-4 font-bold text-right">Acción</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100 text-slate-800">
              {paginatedActivos.length === 0 ? (
                <tr>
                  <td colSpan={8} className="py-12 text-center text-slate-400 text-base">
                    No se encontraron activos con los filtros seleccionados.
                  </td>
                </tr>
              ) : (
                paginatedActivos.map((asset, idx) => {
                  const isPareto = asset.pareto_20;
                  const crit = asset.categoria_criticidad || '';
                  const obs = asset.estatus_obsolescencia || '';

                  return (
                    <tr 
                      key={asset.id || asset.tag_pdvsa || idx}
                      onClick={() => onSelectActivo(asset)}
                      className="hover:bg-slate-50/80 transition-colors cursor-pointer group"
                    >
                      <td className="py-4 px-4 font-mono font-bold text-slate-500">
                        {asset.num || (currentPage - 1) * itemsPerPage + idx + 1}
                      </td>

                      <td className="py-4 px-4">
                        <div className="font-mono font-bold text-blue-700 text-sm sm:text-base">
                          {asset.tag_pdvsa}
                        </div>
                        <div className="flex items-center space-x-2 mt-1 flex-wrap gap-y-1">
                          <span className="font-mono text-xs font-bold text-emerald-800 bg-emerald-50 px-2 py-0.5 rounded border border-emerald-200">
                            SUDEBIP: {asset.codigo_sudebip || 'S/C'}
                          </span>
                          {asset.codigo_sap && asset.codigo_sap !== 'Sin Información' && (
                            <span className="font-mono text-xs text-slate-600 bg-slate-100 px-2 py-0.5 rounded border border-slate-200">
                              SAP: {asset.codigo_sap}
                            </span>
                          )}
                        </div>
                      </td>

                      <td className="py-4 px-4">
                        <div className="font-bold text-slate-900 group-hover:text-blue-700 transition-colors text-sm sm:text-base">
                          {asset.nombre}
                        </div>
                        <div className="text-xs sm:text-sm text-slate-500 mt-0.5 font-medium">
                          {asset.marca} {asset.modelo && `• Mod: ${asset.modelo}`} {asset.serial && asset.serial !== 'Sin Información' && `• S/N: ${asset.serial}`}
                        </div>
                      </td>

                      <td className="py-4 px-4 text-slate-700 font-medium">
                        {asset.laboratorio}
                      </td>

                      <td className="py-4 px-4">
                        {isPareto ? (
                          <span className="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-bold bg-indigo-50 text-indigo-700 border border-indigo-200">
                            ★ Pareto 20%
                          </span>
                        ) : (
                          <span className="text-xs text-slate-400 font-mono">No</span>
                        )}
                      </td>

                      <td className="py-4 px-4 whitespace-nowrap">
                        {crit.includes('Nivel A') ? (
                          <span className="inline-block px-3 py-1 rounded-full text-xs font-bold bg-red-100 text-red-800 border border-red-300">
                            Clase A (Crítico)
                          </span>
                        ) : crit.includes('Nivel B') ? (
                          <span className="inline-block px-3 py-1 rounded-full text-xs font-bold bg-amber-100 text-amber-800 border border-amber-300">
                            Clase B (Semicrítico)
                          </span>
                        ) : crit.includes('Nivel C') ? (
                          <span className="inline-block px-3 py-1 rounded-full text-xs font-bold bg-emerald-100 text-emerald-800 border border-emerald-300">
                            Clase C (No Crítico)
                          </span>
                        ) : (
                          <span className="text-slate-400 text-xs">No evaluado</span>
                        )}
                      </td>

                      <td className="py-4 px-4 whitespace-nowrap">
                        {obs.includes('Crítica') ? (
                          <span className="inline-block px-3 py-1 rounded-full text-xs font-bold bg-red-100 text-red-800 border border-red-300">
                            Crítica ({asset.iobs}%)
                          </span>
                        ) : obs.includes('Media') ? (
                          <span className="inline-block px-3 py-1 rounded-full text-xs font-bold bg-orange-100 text-orange-800 border border-orange-300">
                            Media ({asset.iobs}%)
                          </span>
                        ) : obs.includes('Baja') ? (
                          <span className="inline-block px-3 py-1 rounded-full text-xs font-bold bg-emerald-100 text-emerald-800 border border-emerald-300">
                            Baja ({asset.iobs}%)
                          </span>
                        ) : (
                          <span className="text-slate-400 text-xs">No calculada</span>
                        )}
                      </td>

                      <td className="py-4 px-4 text-right whitespace-nowrap">
                        <button
                          onClick={(e) => {
                            e.stopPropagation();
                            onSelectActivo(asset);
                          }}
                          className="px-3.5 py-1.5 text-xs sm:text-sm bg-blue-50 hover:bg-blue-600 text-blue-700 hover:text-white rounded-xl transition-colors font-bold border border-blue-200 hover:border-transparent"
                        >
                          Ver Ficha
                        </button>
                      </td>
                    </tr>
                  );
                })
              )}
            </tbody>
          </table>
        </div>

        {/* Pagination Footer */}
        <div className="p-4 bg-slate-50 border-t border-slate-200 flex flex-col sm:flex-row items-center justify-between gap-3">
          <span className="text-xs sm:text-sm text-slate-600 font-medium">
            Página {currentPage} de {totalPages} ({filtered.length} equipos filtrados)
          </span>

          <div className="flex items-center space-x-2">
            <button
              onClick={() => setCurrentPage(p => Math.max(p - 1, 1))}
              disabled={currentPage === 1}
              className="p-2 rounded-lg bg-white border border-slate-300 text-slate-700 hover:bg-slate-100 disabled:opacity-40 disabled:cursor-not-allowed transition-colors"
            >
              <ChevronLeft className="w-5 h-5" />
            </button>
            <button
              onClick={() => setCurrentPage(p => Math.min(p + 1, totalPages))}
              disabled={currentPage === totalPages}
              className="p-2 rounded-lg bg-white border border-slate-300 text-slate-700 hover:bg-slate-100 disabled:opacity-40 disabled:cursor-not-allowed transition-colors"
            >
              <ChevronRight className="w-5 h-5" />
            </button>
          </div>
        </div>

      </div>

    </div>
  );
};
