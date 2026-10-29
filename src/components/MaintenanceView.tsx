import React, { useState, useMemo } from 'react';
import { 
  Wrench, Plus, Search, Filter, Calendar, Clock, DollarSign, 
  CheckCircle2, AlertTriangle, Edit3, Trash2, ShieldCheck, 
  Settings, UserCheck, X, Save, ArrowUpDown, ChevronLeft, ChevronRight, FileSpreadsheet
} from 'lucide-react';
import { ActivoFisico, HistorialFalla } from '../types';

interface MaintenanceViewProps {
  activos: ActivoFisico[];
  onUpdateActivoFallas: (tag_pdvsa: string, fallas: HistorialFalla[]) => void;
}

export const MaintenanceView: React.FC<MaintenanceViewProps> = ({
  activos,
  onUpdateActivoFallas
}) => {
  // Aggregate all maintenance orders across all assets
  const allOrders = useMemo(() => {
    const list: (HistorialFalla & { assetName: string })[] = [];
    activos.forEach(asset => {
      if (asset.historial_fallas && asset.historial_fallas.length > 0) {
        asset.historial_fallas.forEach(f => {
          list.push({
            ...f,
            tag_pdvsa: f.tag_pdvsa || asset.tag_pdvsa,
            assetName: asset.nombre
          });
        });
      }
    });

    // Sort by date descending
    return list.sort((a, b) => new Date(b.fecha_evento).getTime() - new Date(a.fecha_evento).getTime());
  }, [activos]);

  // Filtering State
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedTipo, setSelectedTipo] = useState('ALL');
  const [selectedEstado, setSelectedEstado] = useState('ALL');
  const [selectedPrioridad, setSelectedPrioridad] = useState('ALL');

  // Pagination State
  const [currentPage, setCurrentPage] = useState(1);
  const itemsPerPage = 10;

  // Modal State for CRUD
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingIndex, setEditingIndex] = useState<number | null>(null);
  const [selectedOrderAssetTag, setSelectedOrderAssetTag] = useState<string>('');

  // Form State
  const [formData, setFormData] = useState<HistorialFalla>({
    tag_pdvsa: '',
    fecha_evento: new Date().toISOString().slice(0, 10),
    tipo_evento: 'Mantenimiento Preventivo',
    estado: 'Completado',
    prioridad: 'Media',
    descripcion: '',
    tiempo_fuera_servicio_horas: 0,
    costo_reparacion: 0,
    tecnico_responsable: '',
    impacto_operacional: 'Sin impacto operacional',
    accion_tomada: ''
  });

  // KPI Metrics
  const metrics = useMemo(() => {
    const total = allOrders.length;
    const preventivos = allOrders.filter(o => o.tipo_evento === 'Mantenimiento Preventivo').length;
    const correctivos = allOrders.filter(o => o.tipo_evento === 'Mantenimiento Correctivo').length;
    const calibraciones = allOrders.filter(o => o.tipo_evento === 'Calibración ISO 10012').length;
    const enProceso = allOrders.filter(o => o.estado === 'En Proceso' || o.estado === 'Programado').length;
    const totalHoras = allOrders.reduce((sum, o) => sum + (Number(o.tiempo_fuera_servicio_horas) || 0), 0);
    const totalCosto = allOrders.reduce((sum, o) => sum + (Number(o.costo_reparacion) || 0), 0);

    return {
      total,
      preventivos,
      correctivos,
      calibraciones,
      enProceso,
      totalHoras: totalHoras.toFixed(1),
      totalCosto: totalCosto.toLocaleString()
    };
  }, [allOrders]);

  // Filtered Orders
  const filtered = useMemo(() => {
    return allOrders.filter(order => {
      const s = searchTerm.toLowerCase();
      const matchSearch = !searchTerm || (
        order.tag_pdvsa.toLowerCase().includes(s) ||
        (order.assetName && order.assetName.toLowerCase().includes(s)) ||
        (order.descripcion && order.descripcion.toLowerCase().includes(s)) ||
        (order.tecnico_responsable && order.tecnico_responsable.toLowerCase().includes(s))
      );

      const matchTipo = selectedTipo === 'ALL' || order.tipo_evento === selectedTipo;
      const matchEstado = selectedEstado === 'ALL' || (order.estado || 'Completado') === selectedEstado;
      const matchPrioridad = selectedPrioridad === 'ALL' || (order.prioridad || 'Media') === selectedPrioridad;

      return matchSearch && matchTipo && matchEstado && matchPrioridad;
    });
  }, [allOrders, searchTerm, selectedTipo, selectedEstado, selectedPrioridad]);

  // Pagination Slice
  const totalPages = Math.ceil(filtered.length / itemsPerPage) || 1;
  const paginatedOrders = useMemo(() => {
    const start = (currentPage - 1) * itemsPerPage;
    return filtered.slice(start, start + itemsPerPage);
  }, [filtered, currentPage]);

  // CRUD Handlers
  const handleOpenCreate = () => {
    setEditingIndex(null);
    setSelectedOrderAssetTag(activos[0]?.tag_pdvsa || '');
    setFormData({
      tag_pdvsa: activos[0]?.tag_pdvsa || '',
      fecha_evento: new Date().toISOString().slice(0, 10),
      tipo_evento: 'Mantenimiento Preventivo',
      estado: 'Programado',
      prioridad: 'Media',
      descripcion: '',
      tiempo_fuera_servicio_horas: 0,
      costo_reparacion: 0,
      tecnico_responsable: '',
      impacto_operacional: 'Sin impacto operacional',
      accion_tomada: ''
    });
    setIsModalOpen(true);
  };

  const handleOpenEdit = (order: HistorialFalla & { assetName: string }) => {
    setSelectedOrderAssetTag(order.tag_pdvsa);
    setFormData({ ...order });
    // Find index of this order in asset's fallas
    const targetAsset = activos.find(a => a.tag_pdvsa === order.tag_pdvsa);
    if (targetAsset && targetAsset.historial_fallas) {
      const idx = targetAsset.historial_fallas.findIndex(f => 
        f.id === order.id || (f.fecha_evento === order.fecha_evento && f.descripcion === order.descripcion)
      );
      setEditingIndex(idx >= 0 ? idx : 0);
    }
    setIsModalOpen(true);
  };

  const handleDelete = (order: HistorialFalla) => {
    if (confirm(`¿Estás seguro de eliminar el registro de mantenimiento para ${order.tag_pdvsa}?`)) {
      const targetAsset = activos.find(a => a.tag_pdvsa === order.tag_pdvsa);
      if (targetAsset) {
        const updatedFallas = (targetAsset.historial_fallas || []).filter(f => 
          f.id !== order.id && (f.fecha_evento !== order.fecha_evento || f.descripcion !== order.descripcion)
        );
        onUpdateActivoFallas(targetAsset.tag_pdvsa, updatedFallas);
      }
    }
  };

  const handleSaveModal = (e: React.FormEvent) => {
    e.preventDefault();
    if (!formData.descripcion.trim()) {
      alert('Por favor introduzca la descripción de la intervención.');
      return;
    }

    const tag = selectedOrderAssetTag || formData.tag_pdvsa;
    const targetAsset = activos.find(a => a.tag_pdvsa === tag);
    if (!targetAsset) {
      alert('Activo no encontrado.');
      return;
    }

    const currentFallas = [...(targetAsset.historial_fallas || [])];
    const orderToSave: HistorialFalla = {
      ...formData,
      id: formData.id || 'falla_' + Date.now(),
      tag_pdvsa: tag,
      nombre_equipo: targetAsset.nombre
    };

    if (editingIndex !== null && editingIndex >= 0 && editingIndex < currentFallas.length) {
      // Update existing
      currentFallas[editingIndex] = orderToSave;
    } else {
      // Create new (at the beginning)
      currentFallas.unshift(orderToSave);
    }

    onUpdateActivoFallas(tag, currentFallas);
    setIsModalOpen(false);
  };

  return (
    <div className="space-y-6 animate-in fade-in duration-300">
      
      {/* Header Banner - Executive Light Style */}
      <div className="bg-white border border-slate-200 rounded-2xl p-6 sm:p-8 shadow-sm flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <div className="flex items-center space-x-2.5 mb-2">
            <span className="p-2 bg-blue-50 text-blue-700 rounded-xl border border-blue-200">
              <Wrench className="w-5 h-5" />
            </span>
            <span className="text-xs sm:text-sm font-bold tracking-wide uppercase text-blue-700">
              Módulo de Mantenimiento & Operaciones (O&M)
            </span>
            <span className="px-2.5 py-0.5 rounded-full text-xs font-semibold bg-emerald-50 text-emerald-700 border border-emerald-200">
              ISO 55001 & ISO 10012
            </span>
          </div>
          <h2 className="text-2xl sm:text-3xl font-black text-slate-900 tracking-tight">
            Gestión Integral de Órdenes y Bitácora de Activos
          </h2>
          <p className="text-sm sm:text-base text-slate-600 mt-1 max-w-3xl">
            Control operativo de intervenciones preventivas, correctivas y calibraciones metrológicas. Registro de tiempos de paro, costos e historial de confiabilidad.
          </p>
        </div>

        <button
          onClick={handleOpenCreate}
          className="flex items-center justify-center space-x-2 bg-blue-600 hover:bg-blue-700 text-white font-bold px-5 py-3 rounded-xl shadow-md transition-all text-sm sm:text-base whitespace-nowrap self-stretch sm:self-auto"
        >
          <Plus className="w-5 h-5" />
          <span>Nueva Orden de Mantenimiento</span>
        </button>
      </div>

      {/* KPI Cards Grid */}
      <div className="grid grid-cols-2 lg:grid-cols-6 gap-3 sm:gap-4">
        
        {/* Total Intervenciones */}
        <div className="bg-white border border-slate-200 p-4 sm:p-5 rounded-2xl shadow-sm flex flex-col justify-between">
          <div className="flex justify-between items-center text-slate-500 mb-2">
            <span className="text-xs sm:text-sm font-bold uppercase tracking-wider">Total Órdenes</span>
            <Wrench className="w-4 h-4 text-blue-600" />
          </div>
          <div className="text-2xl sm:text-3xl font-black text-slate-900">{metrics.total}</div>
          <div className="text-xs text-slate-500 mt-1">Registros en bitácora</div>
        </div>

        {/* Preventivos */}
        <div className="bg-white border border-slate-200 p-4 sm:p-5 rounded-2xl shadow-sm flex flex-col justify-between">
          <div className="flex justify-between items-center text-slate-500 mb-2">
            <span className="text-xs sm:text-sm font-bold uppercase tracking-wider">Preventivos</span>
            <ShieldCheck className="w-4 h-4 text-emerald-600" />
          </div>
          <div className="text-2xl sm:text-3xl font-black text-emerald-600">{metrics.preventivos}</div>
          <div className="text-xs text-slate-500 mt-1">Planes rutinarios</div>
        </div>

        {/* Correctivos */}
        <div className="bg-white border border-slate-200 p-4 sm:p-5 rounded-2xl shadow-sm flex flex-col justify-between">
          <div className="flex justify-between items-center text-slate-500 mb-2">
            <span className="text-xs sm:text-sm font-bold uppercase tracking-wider">Correctivos</span>
            <AlertTriangle className="w-4 h-4 text-amber-600" />
          </div>
          <div className="text-2xl sm:text-3xl font-black text-amber-600">{metrics.correctivos}</div>
          <div className="text-xs text-slate-500 mt-1">Fallas operativas</div>
        </div>

        {/* Calibraciones ISO 10012 */}
        <div className="bg-white border border-slate-200 p-4 sm:p-5 rounded-2xl shadow-sm flex flex-col justify-between">
          <div className="flex justify-between items-center text-slate-500 mb-2">
            <span className="text-xs sm:text-sm font-bold uppercase tracking-wider">Calibraciones</span>
            <Settings className="w-4 h-4 text-indigo-600" />
          </div>
          <div className="text-2xl sm:text-3xl font-black text-indigo-600">{metrics.calibraciones}</div>
          <div className="text-xs text-slate-500 mt-1">ISO 10012 / Metrología</div>
        </div>

        {/* Horas de Paro */}
        <div className="bg-white border border-slate-200 p-4 sm:p-5 rounded-2xl shadow-sm flex flex-col justify-between">
          <div className="flex justify-between items-center text-slate-500 mb-2">
            <span className="text-xs sm:text-sm font-bold uppercase tracking-wider">Horas Paro</span>
            <Clock className="w-4 h-4 text-red-600" />
          </div>
          <div className="text-2xl sm:text-3xl font-black text-red-600">{metrics.totalHoras} hrs</div>
          <div className="text-xs text-slate-500 mt-1">Indisponibilidad acumulada</div>
        </div>

        {/* Costo Total */}
        <div className="bg-white border border-slate-200 p-4 sm:p-5 rounded-2xl shadow-sm flex flex-col justify-between">
          <div className="flex justify-between items-center text-slate-500 mb-2">
            <span className="text-xs sm:text-sm font-bold uppercase tracking-wider">Costo O&M</span>
            <DollarSign className="w-4 h-4 text-slate-700" />
          </div>
          <div className="text-2xl sm:text-3xl font-black text-slate-900">${metrics.totalCosto}</div>
          <div className="text-xs text-slate-500 mt-1">Inversión operativa</div>
        </div>

      </div>

      {/* Filter and Search Bar */}
      <div className="bg-white border border-slate-200 p-4 sm:p-5 rounded-2xl shadow-sm space-y-4">
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-12 gap-3">
          
          {/* Search box */}
          <div className="lg:col-span-5 relative">
            <Search className="w-5 h-5 absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400" />
            <input
              type="text"
              placeholder="Buscar por TAG de equipo, nombre, descripción o técnico..."
              value={searchTerm}
              onChange={(e) => { setSearchTerm(e.target.value); setCurrentPage(1); }}
              className="w-full bg-slate-50 border border-slate-300 rounded-xl pl-11 pr-4 py-2.5 text-sm sm:text-base text-slate-900 placeholder-slate-400 focus:outline-none focus:border-blue-600 focus:bg-white transition-all"
            />
          </div>

          {/* Tipo de Mantenimiento */}
          <div className="lg:col-span-3">
            <select
              value={selectedTipo}
              onChange={(e) => { setSelectedTipo(e.target.value); setCurrentPage(1); }}
              className="w-full bg-slate-50 border border-slate-300 rounded-xl px-3.5 py-2.5 text-sm sm:text-base text-slate-800 focus:outline-none focus:border-blue-600 focus:bg-white transition-all font-medium"
            >
              <option value="ALL">Todos los Tipos de Intervención</option>
              <option value="Mantenimiento Preventivo">Mantenimiento Preventivo</option>
              <option value="Mantenimiento Correctivo">Mantenimiento Correctivo</option>
              <option value="Calibración ISO 10012">Calibración ISO 10012</option>
              <option value="Overhaul / Mayor">Overhaul / Mantenimiento Mayor</option>
              <option value="Inspección Rutinaria">Inspección Rutinaria</option>
            </select>
          </div>

          {/* Estado */}
          <div className="lg:col-span-2">
            <select
              value={selectedEstado}
              onChange={(e) => { setSelectedEstado(e.target.value); setCurrentPage(1); }}
              className="w-full bg-slate-50 border border-slate-300 rounded-xl px-3.5 py-2.5 text-sm sm:text-base text-slate-800 focus:outline-none focus:border-blue-600 focus:bg-white transition-all font-medium"
            >
              <option value="ALL">Todos los Estados</option>
              <option value="Completado">Completado</option>
              <option value="En Proceso">En Proceso</option>
              <option value="Programado">Programado</option>
              <option value="Cancelado">Cancelado</option>
            </select>
          </div>

          {/* Prioridad */}
          <div className="lg:col-span-2">
            <select
              value={selectedPrioridad}
              onChange={(e) => { setSelectedPrioridad(e.target.value); setCurrentPage(1); }}
              className="w-full bg-slate-50 border border-slate-300 rounded-xl px-3.5 py-2.5 text-sm sm:text-base text-slate-800 focus:outline-none focus:border-blue-600 focus:bg-white transition-all font-medium"
            >
              <option value="ALL">Todas las Prioridades</option>
              <option value="Crítica">Crítica</option>
              <option value="Alta">Alta</option>
              <option value="Media">Media</option>
              <option value="Baja">Baja</option>
            </select>
          </div>

        </div>

        {/* Filter Summary */}
        <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center text-xs sm:text-sm text-slate-500 pt-3 border-t border-slate-100 gap-2">
          <span>
            Mostrando <strong className="text-slate-800 font-bold">{filtered.length}</strong> órdenes de trabajo registradas.
          </span>
          <span className="font-mono">
            Página {currentPage} de {totalPages}
          </span>
        </div>
      </div>

      {/* Maintenance Orders Table - Responsive Card Design */}
      <div className="bg-white border border-slate-200 rounded-2xl overflow-hidden shadow-sm">
        <div className="overflow-x-auto">
          <table className="w-full text-left text-sm sm:text-base border-collapse">
            <thead>
              <tr className="bg-slate-50 text-slate-600 uppercase tracking-wider text-xs sm:text-sm border-b border-slate-200">
                <th className="py-3.5 px-4 font-bold">Activo / TAG PDVSA</th>
                <th className="py-3.5 px-4 font-bold">Fecha & Tipo</th>
                <th className="py-3.5 px-4 font-bold">Descripción de la Tarea</th>
                <th className="py-3.5 px-4 font-bold">Técnico / Responsable</th>
                <th className="py-3.5 px-4 font-bold text-center">Horas Paro</th>
                <th className="py-3.5 px-4 font-bold text-center">Estado</th>
                <th className="py-3.5 px-4 font-bold text-right">Acciones</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100 text-slate-800">
              {paginatedOrders.length === 0 ? (
                <tr>
                  <td colSpan={7} className="py-12 text-center text-slate-400 text-base">
                    No hay órdenes de mantenimiento que coincidan con la búsqueda.
                  </td>
                </tr>
              ) : (
                paginatedOrders.map((order, i) => {
                  const isPreventivo = order.tipo_evento === 'Mantenimiento Preventivo';
                  const isCorrectivo = order.tipo_evento === 'Mantenimiento Correctivo';
                  const isCalibracion = order.tipo_evento === 'Calibración ISO 10012';

                  return (
                    <tr key={i} className="hover:bg-slate-50/80 transition-colors">
                      {/* Activo / TAG */}
                      <td className="py-4 px-4">
                        <div className="font-mono font-bold text-blue-700 text-sm sm:text-base">
                          {order.tag_pdvsa}
                        </div>
                        <div className="text-xs sm:text-sm text-slate-600 font-medium truncate max-w-[220px]">
                          {order.assetName}
                        </div>
                      </td>

                      {/* Fecha & Tipo */}
                      <td className="py-4 px-4 whitespace-nowrap">
                        <div className="font-semibold text-slate-900 text-sm sm:text-base">
                          {order.fecha_evento}
                        </div>
                        <span className={`inline-block px-2.5 py-0.5 rounded-full text-xs font-bold mt-1 ${
                          isPreventivo ? 'bg-emerald-100 text-emerald-800 border border-emerald-300' :
                          isCorrectivo ? 'bg-amber-100 text-amber-800 border border-amber-300' :
                          isCalibracion ? 'bg-indigo-100 text-indigo-800 border border-indigo-300' :
                          'bg-slate-100 text-slate-800 border border-slate-300'
                        }`}>
                          {order.tipo_evento}
                        </span>
                      </td>

                      {/* Descripción */}
                      <td className="py-4 px-4 max-w-xs">
                        <p className="text-sm sm:text-base text-slate-800 line-clamp-2">
                          {order.descripcion}
                        </p>
                        {order.accion_tomada && (
                          <p className="text-xs text-slate-500 mt-1 italic line-clamp-1">
                            Acción: {order.accion_tomada}
                          </p>
                        )}
                      </td>

                      {/* Técnico */}
                      <td className="py-4 px-4 whitespace-nowrap text-sm sm:text-base text-slate-700 font-medium">
                        {order.tecnico_responsable || 'No Asignado'}
                      </td>

                      {/* Horas Paro */}
                      <td className="py-4 px-4 text-center whitespace-nowrap font-mono font-bold text-sm sm:text-base">
                        {order.tiempo_fuera_servicio_horas > 0 ? (
                          <span className="text-red-600 bg-red-50 px-2.5 py-1 rounded-lg border border-red-200">
                            {order.tiempo_fuera_servicio_horas} hrs
                          </span>
                        ) : (
                          <span className="text-slate-400">0 hrs</span>
                        )}
                      </td>

                      {/* Estado */}
                      <td className="py-4 px-4 text-center whitespace-nowrap">
                        <span className={`inline-flex items-center px-3 py-1 rounded-full text-xs sm:text-sm font-bold ${
                          order.estado === 'Completado' ? 'bg-emerald-50 text-emerald-700 border border-emerald-200' :
                          order.estado === 'En Proceso' ? 'bg-blue-50 text-blue-700 border border-blue-200' :
                          order.estado === 'Programado' ? 'bg-amber-50 text-amber-700 border border-amber-200' :
                          'bg-slate-100 text-slate-600'
                        }`}>
                          {order.estado || 'Completado'}
                        </span>
                      </td>

                      {/* Acciones */}
                      <td className="py-4 px-4 text-right whitespace-nowrap">
                        <div className="flex items-center justify-end space-x-2">
                          <button
                            onClick={() => handleOpenEdit(order)}
                            className="p-2 text-blue-700 hover:bg-blue-50 rounded-lg transition-colors border border-transparent hover:border-blue-200"
                            title="Editar Orden de Mantenimiento"
                          >
                            <Edit3 className="w-4 h-4 sm:w-5 sm:h-5" />
                          </button>
                          <button
                            onClick={() => handleDelete(order)}
                            className="p-2 text-red-600 hover:bg-red-50 rounded-lg transition-colors border border-transparent hover:border-red-200"
                            title="Eliminar Registro"
                          >
                            <Trash2 className="w-4 h-4 sm:w-5 sm:h-5" />
                          </button>
                        </div>
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
            Página {currentPage} de {totalPages} ({filtered.length} órdenes filtradas)
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

      {/* CRUD MODAL */}
      {isModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm p-4 overflow-y-auto">
          <div className="bg-white w-full max-w-2xl rounded-2xl shadow-2xl border border-slate-200 overflow-hidden my-8 animate-in fade-in zoom-in-95 duration-200 flex flex-col max-h-[90vh]">
            
            {/* Modal Header */}
            <div className="px-6 py-4 bg-slate-50 border-b border-slate-200 flex justify-between items-center flex-shrink-0">
              <div className="flex items-center space-x-3">
                <div className="p-2.5 bg-blue-100 text-blue-700 rounded-xl">
                  <Wrench className="w-5 h-5" />
                </div>
                <div>
                  <h3 className="text-lg sm:text-xl font-bold text-slate-900">
                    {editingIndex !== null ? 'Editar Orden de Mantenimiento' : 'Nueva Orden de Mantenimiento / Intervención'}
                  </h3>
                  <p className="text-xs sm:text-sm text-slate-500">
                    Control de Confiabilidad y Aseguramiento Metrológico ISO 55001 / ISO 10012
                  </p>
                </div>
              </div>
              <button
                onClick={() => setIsModalOpen(false)}
                className="p-1.5 rounded-lg text-slate-400 hover:text-slate-700 hover:bg-slate-100 transition-colors"
              >
                <X className="w-6 h-6" />
              </button>
            </div>

            {/* Modal Form */}
            <form onSubmit={handleSaveModal} className="p-6 space-y-4 overflow-y-auto flex-1 text-slate-800">
              
              {/* Asset Selection */}
              <div>
                <label className="block text-sm font-bold text-slate-800 mb-1.5">
                  Activo / Equipo <span className="text-red-500">*</span>
                </label>
                <select
                  disabled={editingIndex !== null}
                  value={selectedOrderAssetTag}
                  onChange={(e) => setSelectedOrderAssetTag(e.target.value)}
                  className="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-sm sm:text-base text-slate-900 focus:outline-none focus:border-blue-600 focus:bg-white font-medium"
                >
                  {activos.map(a => (
                    <option key={a.tag_pdvsa} value={a.tag_pdvsa}>
                      {a.tag_pdvsa} — {a.nombre} ({a.laboratorio})
                    </option>
                  ))}
                </select>
                <span className="text-xs text-slate-500 mt-1 block">
                  Selecciona el activo del inventario maestro PDVSA INTEVEP.
                </span>
              </div>

              {/* Tipo de Intervención & Estado */}
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-bold text-slate-800 mb-1.5">
                    Tipo de Evento / Mantenimiento
                  </label>
                  <select
                    value={formData.tipo_evento}
                    onChange={(e) => setFormData({ ...formData, tipo_evento: e.target.value })}
                    className="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-sm sm:text-base text-slate-900 focus:outline-none focus:border-blue-600 focus:bg-white font-medium"
                  >
                    <option value="Mantenimiento Preventivo">Mantenimiento Preventivo</option>
                    <option value="Mantenimiento Correctivo">Mantenimiento Correctivo</option>
                    <option value="Calibración ISO 10012">Calibración ISO 10012</option>
                    <option value="Overhaul / Mayor">Overhaul / Mantenimiento Mayor</option>
                    <option value="Inspección Rutinaria">Inspección Rutinaria</option>
                  </select>
                </div>

                <div>
                  <label className="block text-sm font-bold text-slate-800 mb-1.5">
                    Estado de la Orden
                  </label>
                  <select
                    value={formData.estado || 'Completado'}
                    onChange={(e: any) => setFormData({ ...formData, estado: e.target.value })}
                    className="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-sm sm:text-base text-slate-900 focus:outline-none focus:border-blue-600 focus:bg-white font-medium"
                  >
                    <option value="Programado">Programado</option>
                    <option value="En Proceso">En Proceso</option>
                    <option value="Completado">Completado</option>
                    <option value="Cancelado">Cancelado</option>
                  </select>
                </div>
              </div>

              {/* Fecha & Prioridad */}
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-bold text-slate-800 mb-1.5">
                    Fecha de la Intervención <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="date"
                    required
                    value={formData.fecha_evento}
                    onChange={(e) => setFormData({ ...formData, fecha_evento: e.target.value })}
                    className="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-sm sm:text-base text-slate-900 focus:outline-none focus:border-blue-600 focus:bg-white font-medium"
                  />
                </div>

                <div>
                  <label className="block text-sm font-bold text-slate-800 mb-1.5">
                    Prioridad de la Intervención
                  </label>
                  <select
                    value={formData.prioridad || 'Media'}
                    onChange={(e: any) => setFormData({ ...formData, prioridad: e.target.value })}
                    className="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-sm sm:text-base text-slate-900 focus:outline-none focus:border-blue-600 focus:bg-white font-medium"
                  >
                    <option value="Crítica">Crítica (Riesgo Parada / SHA)</option>
                    <option value="Alta">Alta</option>
                    <option value="Media">Media (Rutinaria)</option>
                    <option value="Baja">Baja</option>
                  </select>
                </div>
              </div>

              {/* Horas Paro, Costo & Técnico */}
              <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
                <div>
                  <label className="block text-sm font-bold text-slate-800 mb-1.5">
                    Horas Fuera de Servicio
                  </label>
                  <input
                    type="number"
                    min={0}
                    step={0.5}
                    value={formData.tiempo_fuera_servicio_horas}
                    onChange={(e) => setFormData({ ...formData, tiempo_fuera_servicio_horas: Number(e.target.value) })}
                    className="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-sm sm:text-base text-slate-900 focus:outline-none focus:border-blue-600 focus:bg-white font-mono"
                  />
                </div>

                <div>
                  <label className="block text-sm font-bold text-slate-800 mb-1.5">
                    Costo Reparación ($)
                  </label>
                  <input
                    type="number"
                    min={0}
                    step={10}
                    value={formData.costo_reparacion || 0}
                    onChange={(e) => setFormData({ ...formData, costo_reparacion: Number(e.target.value) })}
                    className="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-sm sm:text-base text-slate-900 focus:outline-none focus:border-blue-600 focus:bg-white font-mono"
                  />
                </div>

                <div>
                  <label className="block text-sm font-bold text-slate-800 mb-1.5">
                    Técnico / Responsable
                  </label>
                  <input
                    type="text"
                    placeholder="Ej. Ing. Carlos Lugo"
                    value={formData.tecnico_responsable || ''}
                    onChange={(e) => setFormData({ ...formData, tecnico_responsable: e.target.value })}
                    className="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-sm sm:text-base text-slate-900 focus:outline-none focus:border-blue-600 focus:bg-white"
                  />
                </div>
              </div>

              {/* Descripción */}
              <div>
                <label className="block text-sm font-bold text-slate-800 mb-1.5">
                  Descripción de la Falla o Tarea de Mantenimiento <span className="text-red-500">*</span>
                </label>
                <textarea
                  required
                  rows={3}
                  placeholder="Describe la anomalía detectada, el síntoma de falla o la pauta de mantenimiento preventivo ejecutada..."
                  value={formData.descripcion}
                  onChange={(e) => setFormData({ ...formData, descripcion: e.target.value })}
                  className="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-sm sm:text-base text-slate-900 focus:outline-none focus:border-blue-600 focus:bg-white leading-relaxed"
                />
              </div>

              {/* Acción Tomada / Repuestos */}
              <div>
                <label className="block text-sm font-bold text-slate-800 mb-1.5">
                  Acción Correctiva / Repuestos y Piezas Utilizadas
                </label>
                <input
                  type="text"
                  placeholder="Ej. Reemplazo de kit de sellos, ajuste de óptica, calibración metrológica y verificación..."
                  value={formData.accion_tomada || ''}
                  onChange={(e) => setFormData({ ...formData, accion_tomada: e.target.value })}
                  className="w-full bg-slate-50 border border-slate-300 rounded-xl px-4 py-2.5 text-sm sm:text-base text-slate-900 focus:outline-none focus:border-blue-600 focus:bg-white"
                />
              </div>

              {/* Modal Actions */}
              <div className="pt-4 border-t border-slate-200 flex items-center justify-end space-x-3">
                <button
                  type="button"
                  onClick={() => setIsModalOpen(false)}
                  className="px-5 py-2.5 bg-slate-100 hover:bg-slate-200 text-slate-700 font-semibold rounded-xl text-sm sm:text-base transition-colors"
                >
                  Cancelar
                </button>
                <button
                  type="submit"
                  className="px-6 py-2.5 bg-blue-600 hover:bg-blue-700 text-white font-bold rounded-xl text-sm sm:text-base shadow-md transition-colors flex items-center space-x-2"
                >
                  <Save className="w-5 h-5" />
                  <span>{editingIndex !== null ? 'Actualizar Orden' : 'Guardar Orden de Mantenimiento'}</span>
                </button>
              </div>

            </form>

          </div>
        </div>
      )}

    </div>
  );
};

