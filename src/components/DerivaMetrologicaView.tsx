import React, { useState } from 'react';
import { 
  TrendingDown, Plus, AlertTriangle, ShieldCheck, Activity, 
  HelpCircle, Calendar, UserCheck, AlertOctagon
} from 'lucide-react';
import { ResponsiveContainer, LineChart, Line, XAxis, YAxis, Tooltip, CartesianGrid, ReferenceLine, Legend } from 'recharts';
import { DerivaMetrologicaLectura } from '../types';

interface DerivaMetrologicaViewProps {
  lecturas: DerivaMetrologicaLectura[];
  onAddLectura: (lectura: DerivaMetrologicaLectura) => void;
}

export const DerivaMetrologicaView: React.FC<DerivaMetrologicaViewProps> = ({
  lecturas,
  onAddLectura
}) => {
  const [data, setData] = useState<DerivaMetrologicaLectura[]>(lecturas);
  const [isModalOpen, setIsModalOpen] = useState(false);

  // New measurement form state
  const [form, setForm] = useState({
    fecha_medicion: new Date().toISOString().slice(0, 10),
    analista: 'Lcdo. M. Arismendi',
    temperatura_c: 21.5,
    humedad_hr: 0.50,
    valor_nominal_ppm: 50.0,
    valor_medido_ppm: 51.2
  });

  // Calculate current drift stats
  const latest = data[data.length - 1];
  const maxConsumo = Math.max(...data.map(d => d.consumo_ltm_pct));
  const avgSesgo = (data.reduce((acc, curr) => acc + curr.sesgo_absoluto, 0) / (data.length || 1)).toFixed(3);

  // Chart data format
  const chartData = data.map((d, idx) => ({
    medicion: `#${d.nro_reg}`,
    fecha: d.fecha_medicion,
    medido: d.valor_medido_ppm,
    nominal: d.valor_nominal_ppm,
    sesgo: Number(d.sesgo_absoluto.toFixed(3)),
    consumo_pct: Number(d.consumo_ltm_pct.toFixed(1))
  }));

  const handleCreate = (e: React.FormEvent) => {
    e.preventDefault();
    const sesgo = form.valor_medido_ppm - form.valor_nominal_ppm;
    const consumo = (sesgo / 2.50) * 100;
    const zona = consumo < 60 ? 'Verde (<60%)' : (consumo < 80 ? 'Amarilla (60-79%)' : 'Roja (>=80%)');

    const newRec: DerivaMetrologicaLectura = {
      nro_reg: data.length + 1,
      tag_pdvsa: 'AMB-LAB-GCMS-001',
      fecha_medicion: form.fecha_medicion,
      analista: form.analista,
      temperatura_c: Number(form.temperatura_c),
      humedad_hr: Number(form.humedad_hr),
      valor_nominal_ppm: Number(form.valor_nominal_ppm),
      valor_medido_ppm: Number(form.valor_medido_ppm),
      sesgo_absoluto: sesgo,
      consumo_ltm_pct: consumo,
      zona_riesgo: zona
    };

    const updated = [...data, newRec];
    setData(updated);
    onAddLectura(newRec);
    setIsModalOpen(false);
  };

  return (
    <div className="space-y-6 animate-in fade-in duration-300">
      
      {/* Header Banner */}
      <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-2xl p-6 sm:p-8 shadow-sm flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <div className="flex items-center space-x-2.5 mb-2">
            <span className="p-2 bg-indigo-50 dark:bg-indigo-950 text-indigo-700 dark:text-indigo-300 rounded-xl border border-indigo-200 dark:border-indigo-800">
              <TrendingDown className="w-5 h-5" />
            </span>
            <span className="text-xs sm:text-sm font-bold tracking-wide uppercase text-indigo-700 dark:text-indigo-400">
              Formato AMB-GEN-SGA-FO-018
            </span>
            <span className="px-2.5 py-0.5 rounded-full text-xs font-semibold bg-blue-50 dark:bg-blue-950 text-blue-700 dark:text-blue-300 border border-blue-200 dark:border-blue-800">
              ISO 55001 Cl. 10.3 & ISO 17025 Cl. 6.4.10
            </span>
          </div>
          <h2 className="text-2xl sm:text-3xl font-black text-slate-900 dark:text-white tracking-tight">
            Control y Evaluación de Deriva Metrológica
          </h2>
          <p className="text-sm sm:text-base text-slate-600 dark:text-slate-400 mt-1 max-w-3xl">
            Monitoreo continuo del sesgo instrumental para predecir y anticipar intervenciones de calibración antes de superar el Límite de Tolerancia Metrológica (LTM).
          </p>
        </div>

        <button
          onClick={() => setIsModalOpen(true)}
          className="flex items-center justify-center space-x-2 bg-indigo-600 hover:bg-indigo-700 text-white font-bold px-5 py-3 rounded-xl shadow-md transition-all text-sm sm:text-base whitespace-nowrap self-stretch sm:self-auto"
        >
          <Plus className="w-5 h-5" />
          <span>Registrar Medición</span>
        </button>
      </div>

      {/* KPI Cards Grid */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-3 sm:gap-4">
        
        <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 p-5 rounded-2xl shadow-sm">
          <span className="text-xs font-bold uppercase tracking-wider text-slate-500 dark:text-slate-400">
            Último Sesgo Medido
          </span>
          <div className="text-2xl sm:text-3xl font-black text-slate-900 dark:text-white mt-2">
            +{latest?.sesgo_absoluto.toFixed(3) || 0} ppm
          </div>
          <div className="text-xs text-slate-500 dark:text-slate-400 mt-1">LTM Máx: 2.50 ppm</div>
        </div>

        <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 p-5 rounded-2xl shadow-sm">
          <span className="text-xs font-bold uppercase tracking-wider text-slate-500 dark:text-slate-400">
            Consumo Máximo de Tolerancia
          </span>
          <div className={`text-2xl sm:text-3xl font-black mt-2 ${maxConsumo >= 80 ? 'text-rose-600 dark:text-rose-400' : 'text-amber-600 dark:text-amber-400'}`}>
            {maxConsumo.toFixed(1)}%
          </div>
          <div className="text-xs text-slate-500 dark:text-slate-400 mt-1">Umbral Predictivo: 80%</div>
        </div>

        <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 p-5 rounded-2xl shadow-sm">
          <span className="text-xs font-bold uppercase tracking-wider text-slate-500 dark:text-slate-400">
            Sesgo Promedio Semestral
          </span>
          <div className="text-2xl sm:text-3xl font-black text-slate-900 dark:text-white mt-2">
            +{avgSesgo} ppm
          </div>
          <div className="text-xs text-slate-500 dark:text-slate-400 mt-1">{data.length} lecturas validadas</div>
        </div>

        <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 p-5 rounded-2xl shadow-sm">
          <span className="text-xs font-bold uppercase tracking-wider text-slate-500 dark:text-slate-400">
            Estatus Operativo del Activo
          </span>
          <div className="text-lg sm:text-xl font-black text-emerald-600 dark:text-emerald-400 mt-2 flex items-center space-x-2">
            <span className="w-3 h-3 rounded-full bg-emerald-500 animate-pulse"></span>
            <span>EN SERVICIO CONFORME</span>
          </div>
          <div className="text-xs text-slate-500 dark:text-slate-400 mt-1">Ensayos Previos Válidos</div>
        </div>

      </div>

      {/* Chart Section */}
      <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl p-6 sm:p-8 shadow-sm">
        <div className="flex flex-col sm:flex-row justify-between sm:items-center mb-6 gap-2">
          <div>
            <h3 className="text-lg sm:text-xl font-extrabold text-slate-900 dark:text-white">
              Curva Cronológica de Deriva vs Bandas de Control
            </h3>
            <p className="text-xs sm:text-sm text-slate-500 dark:text-slate-400">
              Patrón Mezcla Grob EPA 8270E (50.00 ppm) • Equipo AMB-LAB-GCMS-001
            </p>
          </div>

          <div className="flex items-center space-x-3 text-xs font-bold">
            <span className="flex items-center space-x-1.5 text-emerald-600 dark:text-emerald-400">
              <span className="w-2.5 h-2.5 rounded-full bg-emerald-500"></span>
              <span>Zona Verde (&lt;60%)</span>
            </span>
            <span className="flex items-center space-x-1.5 text-amber-600 dark:text-amber-400">
              <span className="w-2.5 h-2.5 rounded-full bg-amber-500"></span>
              <span>Zona Amarilla (60-79%)</span>
            </span>
            <span className="flex items-center space-x-1.5 text-rose-600 dark:text-rose-400">
              <span className="w-2.5 h-2.5 rounded-full bg-rose-500"></span>
              <span>Zona Roja (&ge;80%)</span>
            </span>
          </div>
        </div>

        <div className="h-80 w-full">
          <ResponsiveContainer width="100%" height={320}>
            <LineChart data={chartData} margin={{ top: 10, right: 30, left: 0, bottom: 0 }}>
              <CartesianGrid strokeDasharray="3 3" stroke="#e2e8f0" opacity={0.6} />
              <XAxis dataKey="fecha" stroke="#94a3b8" fontSize={11} />
              <YAxis domain={[49.5, 53.0]} stroke="#94a3b8" fontSize={11} />
              <Tooltip 
                contentStyle={{ backgroundColor: '#0f172a', borderColor: '#334155', borderRadius: '12px', color: '#fff' }}
                formatter={(val: any, name: any) => [
                  name === 'medido' ? `${val} ppm` : `${val}%`,
                  name === 'medido' ? 'Valor Medido' : 'Consumo LTM'
                ]}
              />
              <Legend />
              {/* Reference Band Lines */}
              <ReferenceLine y={50.0} stroke="#3b82f6" strokeDasharray="4 4" label="Nominal (50 ppm)" />
              <ReferenceLine y={51.5} stroke="#f59e0b" strokeDasharray="3 3" label="Umbral Preventivo 60% (51.5 ppm)" />
              <ReferenceLine y={52.0} stroke="#ef4444" strokeDasharray="3 3" label="Umbral Predictivo 80% (52.0 ppm)" />
              <ReferenceLine y={52.5} stroke="#b91c1c" strokeWidth={2} label="LTM Máximo (52.5 ppm)" />
              <Line type="monotone" dataKey="medido" stroke="#6366f1" strokeWidth={3} dot={{ r: 5, fill: '#6366f1' }} activeDot={{ r: 8 }} />
            </LineChart>
          </ResponsiveContainer>
        </div>
      </div>

      {/* Chronological Table */}
      <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl p-6 sm:p-8 shadow-sm">
        <h3 className="text-lg sm:text-xl font-extrabold text-slate-900 dark:text-white mb-4">
          Bitácora Cronológica de Mediciones (FO-018)
        </h3>

        <div className="overflow-x-auto">
          <table className="w-full text-left text-sm">
            <thead className="bg-slate-50 dark:bg-slate-800/60 text-slate-600 dark:text-slate-300 font-bold uppercase text-[11px] tracking-wider border-b border-slate-200 dark:border-slate-800">
              <tr>
                <th className="py-3 px-4">N°</th>
                <th className="py-3 px-4">Fecha</th>
                <th className="py-3 px-4">Analista</th>
                <th className="py-3 px-4">Condiciones</th>
                <th className="py-3 px-4">Nominal</th>
                <th className="py-3 px-4">Medido</th>
                <th className="py-3 px-4">Sesgo Abs.</th>
                <th className="py-3 px-4">% Consumo LTM</th>
                <th className="py-3 px-4">Zona</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100 dark:divide-slate-800">
              {data.map((row) => (
                <tr key={row.nro_reg} className="hover:bg-slate-50 dark:hover:bg-slate-800/40 transition-colors">
                  <td className="py-3.5 px-4 font-bold text-slate-900 dark:text-white">#{row.nro_reg}</td>
                  <td className="py-3.5 px-4 font-mono text-slate-600 dark:text-slate-300">{row.fecha_medicion}</td>
                  <td className="py-3.5 px-4 font-medium text-slate-800 dark:text-slate-200">{row.analista}</td>
                  <td className="py-3.5 px-4 text-xs text-slate-500 dark:text-slate-400">
                    {row.temperatura_c}°C | {((row.humedad_hr || 0.5) * 100).toFixed(0)}% HR
                  </td>
                  <td className="py-3.5 px-4 font-mono font-bold text-slate-700 dark:text-slate-300">{row.valor_nominal_ppm.toFixed(2)} ppm</td>
                  <td className="py-3.5 px-4 font-mono font-extrabold text-indigo-600 dark:text-indigo-400">{row.valor_medido_ppm.toFixed(2)} ppm</td>
                  <td className="py-3.5 px-4 font-mono font-bold text-slate-900 dark:text-white">+{row.sesgo_absoluto.toFixed(3)}</td>
                  <td className="py-3.5 px-4 font-mono font-extrabold">{row.consumo_ltm_pct.toFixed(1)}%</td>
                  <td className="py-3.5 px-4">
                    <span className={`px-2.5 py-1 rounded-full text-xs font-bold ${
                      row.consumo_ltm_pct < 60 
                        ? 'bg-emerald-100 text-emerald-800 dark:bg-emerald-950 dark:text-emerald-300' 
                        : (row.consumo_ltm_pct < 80 
                            ? 'bg-amber-100 text-amber-800 dark:bg-amber-950 dark:text-amber-300' 
                            : 'bg-rose-100 text-rose-800 dark:bg-rose-950 dark:text-rose-300')
                    }`}>
                      {row.consumo_ltm_pct < 60 ? 'Verde' : (row.consumo_ltm_pct < 80 ? 'Amarilla' : 'Roja (Alerta)')}
                    </span>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      {/* Modal Nueva Medición */}
      {isModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm p-4 overflow-y-auto">
          <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl p-6 sm:p-8 max-w-lg w-full shadow-2xl">
            <h3 className="text-xl font-black text-slate-900 dark:text-white mb-2">
              Registrar Nueva Medición de Deriva
            </h3>
            <p className="text-xs text-slate-500 dark:text-slate-400 mb-6">
              Alineación ISO 17025 Cl. 6.4.10 con Estándar Trazable NIST
            </p>

            <form onSubmit={handleCreate} className="space-y-4">
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-xs font-bold uppercase text-slate-600 dark:text-slate-300 mb-1">
                    Fecha Medición
                  </label>
                  <input
                    type="date"
                    required
                    value={form.fecha_medicion}
                    onChange={e => setForm({ ...form, fecha_medicion: e.target.value })}
                    className="w-full px-3 py-2 rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white text-sm"
                  />
                </div>
                <div>
                  <label className="block text-xs font-bold uppercase text-slate-600 dark:text-slate-300 mb-1">
                    Analista Responsable
                  </label>
                  <input
                    type="text"
                    required
                    value={form.analista}
                    onChange={e => setForm({ ...form, analista: e.target.value })}
                    className="w-full px-3 py-2 rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white text-sm"
                  />
                </div>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-xs font-bold uppercase text-slate-600 dark:text-slate-300 mb-1">
                    Temp. (°C)
                  </label>
                  <input
                    type="number"
                    step="0.1"
                    value={form.temperatura_c}
                    onChange={e => setForm({ ...form, temperatura_c: parseFloat(e.target.value) || 21.0 })}
                    className="w-full px-3 py-2 rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white text-sm"
                  />
                </div>
                <div>
                  <label className="block text-xs font-bold uppercase text-slate-600 dark:text-slate-300 mb-1">
                    Humedad (%HR)
                  </label>
                  <input
                    type="number"
                    step="0.01"
                    value={form.humedad_hr}
                    onChange={e => setForm({ ...form, humedad_hr: parseFloat(e.target.value) || 0.5 })}
                    className="w-full px-3 py-2 rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white text-sm"
                  />
                </div>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-xs font-bold uppercase text-slate-600 dark:text-slate-300 mb-1">
                    Valor Nominal (ppm)
                  </label>
                  <input
                    type="number"
                    step="0.01"
                    value={form.valor_nominal_ppm}
                    onChange={e => setForm({ ...form, valor_nominal_ppm: parseFloat(e.target.value) || 50.0 })}
                    className="w-full px-3 py-2 rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white text-sm"
                  />
                </div>
                <div>
                  <label className="block text-xs font-bold uppercase text-slate-600 dark:text-slate-300 mb-1">
                    Valor Medido (ppm)
                  </label>
                  <input
                    type="number"
                    step="0.01"
                    value={form.valor_medido_ppm}
                    onChange={e => setForm({ ...form, valor_medido_ppm: parseFloat(e.target.value) || 50.0 })}
                    className="w-full px-3 py-2 rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white text-sm font-bold text-indigo-600"
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
                  className="px-5 py-2 rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white font-bold text-sm shadow"
                >
                  Guardar y Graficar
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

    </div>
  );
};
