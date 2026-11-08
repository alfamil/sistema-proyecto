import React, { useState } from 'react';
import { 
  Building2, Plus, QrCode, FileText, Search, Download, 
  ArrowRightLeft, ShieldCheck, DollarSign
} from 'lucide-react';
import { DepreciacionPatrimonial, ActaMovimientoSudebip, ActivoFisico } from '../types';

interface SudebipPatrimonioViewProps {
  depreciaciones: DepreciacionPatrimonial[];
  movimientos: ActaMovimientoSudebip[];
  activos: ActivoFisico[];
  onAddMovimiento: (mov: ActaMovimientoSudebip) => void;
}

export const SudebipPatrimonioView: React.FC<SudebipPatrimonioViewProps> = ({
  depreciaciones,
  movimientos,
  activos,
  onAddMovimiento
}) => {
  const [subTab, setSubTab] = useState<'depreciacion' | 'actas'>('depreciacion');
  const [isModalOpen, setIsModalOpen] = useState(false);

  // Form for new movement act
  const [form, setForm] = useState<ActaMovimientoSudebip>({
    nro_acta: `ACTA-SUDEBIP-2026-${(movimientos.length + 1).toString().padStart(3, '0')}`,
    tag_pdvsa: activos[0]?.tag_pdvsa || '',
    fecha_movimiento: new Date().toISOString().slice(0, 10),
    tipo_movimiento: 'Salida Temporal para Calibración/Mantenimiento Externo',
    unidad_emisora: 'Lab. de Calidad de Aguas y Efluentes (Sala 3B)',
    unidad_receptora: 'Taller Especializado / SENCAMER',
    responsable_entrega: 'Dra. Elena Salazar (Jefe de Laboratorio)',
    responsable_receptor: 'Ing. Klaus Weber (Servicio Autorizado)',
    nro_autorizacion: 'PASE-SALIDA-INT-2026-001',
    condicion_fisica: 'Buena',
    motivo: 'Calibración metrológica y mantenimiento mayor preventivo',
    estatus_sigebi: 'En Trámite',
    observaciones: 'Con precintos de seguridad colocados'
  });

  const totalCosto = depreciaciones.reduce((acc, curr) => acc + (curr.costo_adquisicion_usd || 0), 0);
  const totalDeprec = depreciaciones.reduce((acc, curr) => acc + (curr.depreciacion_acumulada_usd || 0), 0);
  const totalNeto = depreciaciones.reduce((acc, curr) => acc + (curr.valor_neto_libros_usd || 0), 0);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    onAddMovimiento(form);
    setIsModalOpen(false);
  };

  return (
    <div className="space-y-6 animate-in fade-in duration-300">
      
      {/* Header Banner */}
      <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-2xl p-6 sm:p-8 shadow-sm flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <div className="flex items-center space-x-2.5 mb-2">
            <span className="p-2 bg-amber-50 dark:bg-amber-950 text-amber-700 dark:text-amber-300 rounded-xl border border-amber-200 dark:border-amber-800">
              <Building2 className="w-5 h-5" />
            </span>
            <span className="text-xs sm:text-sm font-bold tracking-wide uppercase text-amber-700 dark:text-amber-400">
              Control Patrimonial de Bienes Públicos
            </span>
            <span className="px-2.5 py-0.5 rounded-full text-xs font-semibold bg-blue-50 dark:bg-blue-950 text-blue-700 dark:text-blue-300 border border-blue-200 dark:border-blue-800">
              LOBP / SUDEBIP / SIGEBI
            </span>
          </div>
          <h2 className="text-2xl sm:text-3xl font-black text-slate-900 dark:text-white tracking-tight">
            Control Patrimonial, Depreciación y Actas SUDEBIP
          </h2>
          <p className="text-sm sm:text-base text-slate-600 dark:text-slate-400 mt-1 max-w-3xl">
            Cálculo de amortización contable por el método de línea recta, trazabilidad de chapas con código QR y libro oficial de transferencias y custodias.
          </p>
        </div>

        <div className="flex items-center gap-3 self-start md:self-auto">
          {/* SubTab Toggle */}
          <div className="flex bg-slate-100 dark:bg-slate-800 p-1 rounded-xl">
            <button
              onClick={() => setSubTab('depreciacion')}
              className={`px-4 py-2 rounded-lg text-xs sm:text-sm font-bold transition-all ${
                subTab === 'depreciacion' ? 'bg-white dark:bg-slate-900 text-amber-600 dark:text-amber-400 shadow-sm' : 'text-slate-600 dark:text-slate-400'
              }`}
            >
              Depreciación Financiera
            </button>
            <button
              onClick={() => setSubTab('actas')}
              className={`px-4 py-2 rounded-lg text-xs sm:text-sm font-bold transition-all ${
                subTab === 'actas' ? 'bg-white dark:bg-slate-900 text-amber-600 dark:text-amber-400 shadow-sm' : 'text-slate-600 dark:text-slate-400'
              }`}
            >
              Libro de Actas ({movimientos.length})
            </button>
          </div>

          <button
            onClick={() => setIsModalOpen(true)}
            className="flex items-center space-x-2 bg-amber-600 hover:bg-amber-700 text-white font-bold px-4 py-2.5 rounded-xl shadow transition-all text-xs sm:text-sm whitespace-nowrap"
          >
            <Plus className="w-4 h-4" />
            <span>Emitir Acta Formal</span>
          </button>
        </div>
      </div>

      {/* Summary KPI Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
        <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 p-5 rounded-2xl shadow-sm">
          <span className="text-xs font-bold uppercase tracking-wider text-slate-500 dark:text-slate-400">
            Costo Histórico de Adquisición
          </span>
          <div className="text-2xl sm:text-3xl font-black text-slate-900 dark:text-white mt-2">
            ${totalCosto.toLocaleString()} USD
          </div>
          <p className="text-xs text-slate-500 dark:text-slate-400 mt-1">Patrimonio Registrado</p>
        </div>

        <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 p-5 rounded-2xl shadow-sm">
          <span className="text-xs font-bold uppercase tracking-wider text-slate-500 dark:text-slate-400">
            Depreciación Acumulada
          </span>
          <div className="text-2xl sm:text-3xl font-black text-rose-600 dark:text-rose-400 mt-2">
            -${totalDeprec.toLocaleString()} USD
          </div>
          <p className="text-xs text-slate-500 dark:text-slate-400 mt-1">Línea recta contable LOBP</p>
        </div>

        <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 p-5 rounded-2xl shadow-sm">
          <span className="text-xs font-bold uppercase tracking-wider text-slate-500 dark:text-slate-400">
            Valor Neto en Libros Actual
          </span>
          <div className="text-2xl sm:text-3xl font-black text-emerald-600 dark:text-emerald-400 mt-2">
            ${totalNeto.toLocaleString()} USD
          </div>
          <p className="text-xs text-slate-500 dark:text-slate-400 mt-1">Conciliado con SIGEBI</p>
        </div>
      </div>

      {/* SUB-TAB 1: DEPRECIACIÓN */}
      {subTab === 'depreciacion' && (
        <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl p-6 sm:p-8 shadow-sm">
          <h3 className="text-lg sm:text-xl font-extrabold text-slate-900 dark:text-white mb-4">
            Tabla 5A: Amortización y Depreciación Financiera SUDEBIP (Método Línea Recta)
          </h3>

          <div className="overflow-x-auto">
            <table className="w-full text-left text-sm">
              <thead className="bg-slate-50 dark:bg-slate-800/60 text-slate-600 dark:text-slate-300 font-bold uppercase text-[11px] tracking-wider border-b border-slate-200 dark:border-slate-800">
                <tr>
                  <th className="py-3 px-4">TAG PDVSA</th>
                  <th className="py-3 px-4">Código SIGEBI</th>
                  <th className="py-3 px-4">Denominación del Bien</th>
                  <th className="py-3 px-4">Fecha Incorp.</th>
                  <th className="py-3 px-4">Costo USD</th>
                  <th className="py-3 px-4">Salvamento</th>
                  <th className="py-3 px-4">Meses Uso</th>
                  <th className="py-3 px-4">Deprec. Acumulada</th>
                  <th className="py-3 px-4">Valor Neto Libros</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100 dark:divide-slate-800">
                {depreciaciones.map((d) => (
                  <tr key={d.tag_pdvsa} className="hover:bg-slate-50 dark:hover:bg-slate-800/40 transition-colors">
                    <td className="py-3.5 px-4 font-mono font-bold text-blue-600 dark:text-blue-400">{d.tag_pdvsa}</td>
                    <td className="py-3.5 px-4 font-mono text-xs text-slate-700 dark:text-slate-300">{d.codigo_sigebi || 'BP-INT-2021'}</td>
                    <td className="py-3.5 px-4 font-bold text-slate-900 dark:text-white max-w-xs">{d.denominacion}</td>
                    <td className="py-3.5 px-4 font-mono text-xs text-slate-600 dark:text-slate-400">{d.fecha_incorporacion}</td>
                    <td className="py-3.5 px-4 font-mono font-bold">${d.costo_adquisicion_usd.toLocaleString()}</td>
                    <td className="py-3.5 px-4 font-mono text-xs">${d.valor_residual_salvamento.toLocaleString()} ({(d.tasa_salvamento * 100).toFixed(0)}%)</td>
                    <td className="py-3.5 px-4 font-mono">{d.meses_uso} meses</td>
                    <td className="py-3.5 px-4 font-mono font-bold text-rose-600 dark:text-rose-400">-${d.depreciacion_acumulada_usd.toLocaleString()}</td>
                    <td className="py-3.5 px-4 font-mono font-black text-emerald-600 dark:text-emerald-400">${d.valor_neto_libros_usd.toLocaleString()}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {/* SUB-TAB 2: ACTAS Y MOVIMIENTOS */}
      {subTab === 'actas' && (
        <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl p-6 sm:p-8 shadow-sm">
          <h3 className="text-lg sm:text-xl font-extrabold text-slate-900 dark:text-white mb-4">
            Tabla 5B: Historial de Movimientos, Transferencias y Asignaciones (SUDEBIP)
          </h3>

          <div className="overflow-x-auto">
            <table className="w-full text-left text-sm">
              <thead className="bg-slate-50 dark:bg-slate-800/60 text-slate-600 dark:text-slate-300 font-bold uppercase text-[11px] tracking-wider border-b border-slate-200 dark:border-slate-800">
                <tr>
                  <th className="py-3 px-4">N° Acta</th>
                  <th className="py-3 px-4">TAG</th>
                  <th className="py-3 px-4">Fecha</th>
                  <th className="py-3 px-4">Tipo de Movimiento</th>
                  <th className="py-3 px-4">Origen</th>
                  <th className="py-3 px-4">Destino</th>
                  <th className="py-3 px-4">Custodio Receptor</th>
                  <th className="py-3 px-4">Estatus SIGEBI</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100 dark:divide-slate-800">
                {movimientos.map((m) => (
                  <tr key={m.nro_acta} className="hover:bg-slate-50 dark:hover:bg-slate-800/40 transition-colors">
                    <td className="py-3.5 px-4 font-mono font-bold text-amber-600 dark:text-amber-400">{m.nro_acta}</td>
                    <td className="py-3.5 px-4 font-mono font-bold text-blue-600 dark:text-blue-400">{m.tag_pdvsa}</td>
                    <td className="py-3.5 px-4 font-mono text-xs text-slate-600 dark:text-slate-400">{m.fecha_movimiento}</td>
                    <td className="py-3.5 px-4 font-bold text-slate-900 dark:text-white">{m.tipo_movimiento}</td>
                    <td className="py-3.5 px-4 text-xs text-slate-600 dark:text-slate-400 max-w-xs">{m.unidad_emisora}</td>
                    <td className="py-3.5 px-4 text-xs text-slate-600 dark:text-slate-400 max-w-xs">{m.unidad_receptora}</td>
                    <td className="py-3.5 px-4 text-xs font-medium text-slate-800 dark:text-slate-200">{m.responsable_receptor}</td>
                    <td className="py-3.5 px-4">
                      <span className="px-2.5 py-1 rounded-full text-xs font-bold bg-emerald-50 text-emerald-700 dark:bg-emerald-950 dark:text-emerald-300 border border-emerald-200 dark:border-emerald-800">
                        {m.estatus_sigebi}
                      </span>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {/* Modal Emitir Acta */}
      {isModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm p-4 overflow-y-auto">
          <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl p-6 sm:p-8 max-w-xl w-full shadow-2xl">
            <h3 className="text-xl font-black text-slate-900 dark:text-white mb-2">
              Emitir Acta Formal de Movimiento SUDEBIP
            </h3>
            <p className="text-xs text-slate-500 dark:text-slate-400 mb-6">
              Alineación Ley Orgánica de Bienes Públicos y Control SIGEBI
            </p>

            <form onSubmit={handleSubmit} className="space-y-4">
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-xs font-bold uppercase text-slate-600 dark:text-slate-300 mb-1">
                    N° Acta Oficial
                  </label>
                  <input
                    type="text"
                    required
                    value={form.nro_acta}
                    onChange={e => setForm({ ...form, nro_acta: e.target.value })}
                    className="w-full px-3 py-2 rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white text-sm font-mono font-bold"
                  />
                </div>
                <div>
                  <label className="block text-xs font-bold uppercase text-slate-600 dark:text-slate-300 mb-1">
                    Fecha de Movimiento
                  </label>
                  <input
                    type="date"
                    required
                    value={form.fecha_movimiento}
                    onChange={e => setForm({ ...form, fecha_movimiento: e.target.value })}
                    className="w-full px-3 py-2 rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white text-sm"
                  />
                </div>
              </div>

              <div>
                <label className="block text-xs font-bold uppercase text-slate-600 dark:text-slate-300 mb-1">
                  Activo (TAG PDVSA)
                </label>
                <select
                  value={form.tag_pdvsa}
                  onChange={e => setForm({ ...form, tag_pdvsa: e.target.value })}
                  className="w-full px-3 py-2 rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white text-sm font-bold"
                >
                  {activos.map(a => (
                    <option key={a.tag_pdvsa} value={a.tag_pdvsa}>
                      {a.tag_pdvsa} - {a.nombre}
                    </option>
                  ))}
                </select>
              </div>

              <div>
                <label className="block text-xs font-bold uppercase text-slate-600 dark:text-slate-300 mb-1">
                  Tipo de Movimiento SUDEBIP
                </label>
                <select
                  value={form.tipo_movimiento}
                  onChange={e => setForm({ ...form, tipo_movimiento: e.target.value })}
                  className="w-full px-3 py-2 rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white text-sm"
                >
                  <option value="Incorporación Inicial por Compra">Incorporación Inicial por Compra</option>
                  <option value="Asignación de Custodia a Responsable">Asignación de Custodia a Responsable</option>
                  <option value="Salida Temporal para Calibración/Mantenimiento Externo">Salida Temporal para Calibración/Mantenimiento Externo</option>
                  <option value="Reincorporación y Retorno a Planta">Reincorporación y Retorno a Planta</option>
                  <option value="Traspaso Interdepartamental">Traspaso Interdepartamental</option>
                  <option value="Desincorporación por Obsolescencia">Desincorporación por Obsolescencia</option>
                </select>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-xs font-bold uppercase text-slate-600 dark:text-slate-300 mb-1">
                    Unidad Emisora (Origen)
                  </label>
                  <input
                    type="text"
                    required
                    value={form.unidad_emisora}
                    onChange={e => setForm({ ...form, unidad_emisora: e.target.value })}
                    className="w-full px-3 py-2 rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white text-sm"
                  />
                </div>
                <div>
                  <label className="block text-xs font-bold uppercase text-slate-600 dark:text-slate-300 mb-1">
                    Unidad Receptora (Destino)
                  </label>
                  <input
                    type="text"
                    required
                    value={form.unidad_receptora}
                    onChange={e => setForm({ ...form, unidad_receptora: e.target.value })}
                    className="w-full px-3 py-2 rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white text-sm"
                  />
                </div>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-xs font-bold uppercase text-slate-600 dark:text-slate-300 mb-1">
                    Responsable de Entrega
                  </label>
                  <input
                    type="text"
                    required
                    value={form.responsable_entrega}
                    onChange={e => setForm({ ...form, responsable_entrega: e.target.value })}
                    className="w-full px-3 py-2 rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white text-sm"
                  />
                </div>
                <div>
                  <label className="block text-xs font-bold uppercase text-slate-600 dark:text-slate-300 mb-1">
                    Responsable Receptor (Custodio)
                  </label>
                  <input
                    type="text"
                    required
                    value={form.responsable_receptor}
                    onChange={e => setForm({ ...form, responsable_receptor: e.target.value })}
                    className="w-full px-3 py-2 rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white text-sm"
                  />
                </div>
              </div>

              <div className="flex justify-end space-x-3 pt-4 border-t border-slate-200 dark:border-slate-800">
                <button
                  type="button"
                  onClick={() => setIsModalOpen(false)}
                  className="px-4 py-2 rounded-xl border border-slate-300 dark:border-slate-700 text-slate-700 dark:text-slate-300 font-bold text-sm"
                >
                  Cancelar
                </button>
                <button
                  type="submit"
                  className="px-5 py-2 rounded-xl bg-amber-600 hover:bg-amber-700 text-white font-bold text-sm shadow"
                >
                  Firmar y Registrar Acta
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

    </div>
  );
};

