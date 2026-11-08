import React, { useState, useMemo } from 'react';
import { 
  FileSpreadsheet, Printer, ShieldCheck, AlertTriangle, CheckCircle2, 
  Search, Building2, Wrench, Activity, Scale, AlertOctagon, HeartHandshake,
  QrCode, FileCheck2, Cpu, Calendar, Download, RefreshCw
} from 'lucide-react';
import { ActivoFisico, CalibracionMetrologica, MantenimientoPDVSA, ComprobacionIntermedia, DepreciacionPatrimonial } from '../types';

interface HojaVidaIntegralViewProps {
  activos: ActivoFisico[];
  calibraciones: CalibracionMetrologica[];
  mantenimientos: MantenimientoPDVSA[];
  comprobaciones: ComprobacionIntermedia[];
  depreciaciones: DepreciacionPatrimonial[];
  initialTag?: string;
}

export const HojaVidaIntegralView: React.FC<HojaVidaIntegralViewProps> = ({
  activos,
  calibraciones,
  mantenimientos,
  comprobaciones,
  depreciaciones,
  initialTag
}) => {
  const [selectedTag, setSelectedTag] = useState<string>(initialTag || activos[0]?.tag_pdvsa || '');
  const [searchFilter, setSearchFilter] = useState('');

  // Selected asset object
  const asset = useMemo(() => {
    return activos.find(a => a.tag_pdvsa === selectedTag) || activos[0];
  }, [activos, selectedTag]);

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

  const handlePrint = () => {
    window.print();
  };

  if (!asset) {
    return (
      <div className="p-8 text-center text-slate-500">
        No hay activos registrados en el sistema.
      </div>
    );
  }

  return (
    <div className="space-y-6 animate-in fade-in duration-300">
      
      {/* Top Selector & Action Bar (Hidden when printing) */}
      <div className="no-print bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-2xl p-6 shadow-sm flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <div className="flex items-center space-x-2.5 mb-1.5">
            <span className="p-2 bg-blue-50 dark:bg-blue-950 text-blue-700 dark:text-blue-300 rounded-xl border border-blue-200 dark:border-blue-800">
              <FileSpreadsheet className="w-5 h-5" />
            </span>
            <span className="text-xs sm:text-sm font-bold tracking-wide uppercase text-blue-700 dark:text-blue-400">
              Formato AMB-GEN-SGA-PM-002
            </span>
            <span className="px-2.5 py-0.5 rounded-full text-xs font-semibold bg-emerald-50 dark:bg-emerald-950 text-emerald-700 dark:text-emerald-300 border border-emerald-200 dark:border-emerald-800">
              ISO 55001 & SUDEBIP
            </span>
          </div>
          <h2 className="text-2xl sm:text-3xl font-black text-slate-900 dark:text-white tracking-tight">
            Hoja de Vida Integral del Activo Físico
          </h2>
          <p className="text-sm sm:text-base text-slate-600 dark:text-slate-400 mt-0.5">
            Expediente maestro unificado: Taxonomía PDVSA, Bienes Públicos, Metrología ISO 10012, LOPCYMAT y Mantenimiento.
          </p>
        </div>

        <div className="flex flex-col sm:flex-row items-stretch sm:items-center gap-3">
          {/* Asset Selector */}
          <div className="relative min-w-[280px]">
            <select
              value={selectedTag}
              onChange={e => setSelectedTag(e.target.value)}
              className="w-full px-4 py-2.5 rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white font-bold text-sm shadow-sm focus:ring-2 focus:ring-blue-500 focus:outline-none"
            >
              {activos.map(a => (
                <option key={a.tag_pdvsa} value={a.tag_pdvsa}>
                  {a.tag_pdvsa} • {a.nombre.slice(0, 35)}
                </option>
              ))}
            </select>
          </div>

          <button
            onClick={handlePrint}
            className="flex items-center justify-center space-x-2 bg-slate-900 dark:bg-blue-600 hover:bg-slate-800 dark:hover:bg-blue-700 text-white font-bold px-4 py-2.5 rounded-xl shadow transition-all text-sm whitespace-nowrap"
          >
            <Printer className="w-4 h-4" />
            <span>Imprimir Ficha PDF</span>
          </button>
        </div>
      </div>

      {/* Main Printable Dossier Card */}
      <div className="print-page bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-3xl p-6 sm:p-10 shadow-sm space-y-8">
        
        {/* Document Header - Formato Oficial INTEVEP */}
        <div className="border-b-2 border-slate-900 dark:border-slate-700 pb-6 flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
          <div>
            <p className="text-xs font-bold tracking-widest uppercase text-slate-500 dark:text-slate-400">
              PDVSA INTEVEP • GERENCIA DE AMBIENTE | SISTEMA INTEGRADO DE GESTIÓN DE ACTIVOS (SIGA)
            </p>
            <h1 className="text-2xl sm:text-3xl font-black text-slate-900 dark:text-white tracking-tight mt-1">
              HOJA DE VIDA INTEGRAL DE ACTIVO
            </h1>
            <p className="text-xs sm:text-sm text-slate-600 dark:text-slate-400 font-semibold mt-0.5">
              Alineación Conjunta ISO 55001 / SUDEBIP / PDVSA MM-02-01-01 / LOPCYMAT / ISO 17025 / ISO 10012
            </p>
          </div>

          <div className="flex flex-col items-end">
            <span className="font-mono text-xl sm:text-2xl font-black text-blue-700 dark:text-blue-400 bg-blue-50 dark:bg-blue-950/60 px-4 py-1.5 rounded-xl border border-blue-200 dark:border-blue-800">
              {asset.tag_pdvsa}
            </span>
            <span className="text-xs text-slate-500 dark:text-slate-400 mt-1 font-medium">
              Formato AMB-GEN-SGA-PM-002
            </span>
          </div>
        </div>

        {/* 4 Main Status Cards */}
        <div className="grid grid-cols-2 lg:grid-cols-4 gap-3 sm:gap-4">
          
          <div className="bg-slate-50 dark:bg-slate-800/60 border border-slate-200 dark:border-slate-700/80 p-4 rounded-2xl">
            <span className="text-xs font-bold uppercase tracking-wider text-slate-500 dark:text-slate-400">
              Estatus Operacional
            </span>
            <div className="flex items-center space-x-2 mt-2">
              <span className="w-3 h-3 rounded-full bg-emerald-500 animate-pulse"></span>
              <p className="text-lg font-black text-slate-900 dark:text-white">
                {asset.estado_operativo || 'Operativo'}
              </p>
            </div>
            <p className="text-xs text-slate-500 dark:text-slate-400 mt-1">Línea de ensayo activa</p>
          </div>

          <div className="bg-slate-50 dark:bg-slate-800/60 border border-slate-200 dark:border-slate-700/80 p-4 rounded-2xl">
            <span className="text-xs font-bold uppercase tracking-wider text-slate-500 dark:text-slate-400">
              Criticidad PDVSA
            </span>
            <p className="text-lg font-black text-blue-700 dark:text-blue-400 mt-2">
              {asset.categoria_criticidad || 'Clase A - Crítico'}
            </p>
            <p className="text-xs text-slate-500 dark:text-slate-400 mt-1">Impacto directo en ensayos</p>
          </div>

          <div className="bg-slate-50 dark:bg-slate-800/60 border border-slate-200 dark:border-slate-700/80 p-4 rounded-2xl">
            <span className="text-xs font-bold uppercase tracking-wider text-slate-500 dark:text-slate-400">
              Estado Metrológico
            </span>
            <p className={`text-lg font-black mt-2 ${
              (latestCal?.estatus_metrologico || 'VIGENTE') === 'VIGENTE' 
                ? 'text-emerald-600 dark:text-emerald-400' 
                : 'text-rose-600 dark:text-rose-400'
            }`}>
              {latestCal?.estatus_metrologico || 'VIGENTE'}
            </p>
            <p className="text-xs text-slate-500 dark:text-slate-400 mt-1">
              {latestCal?.dias_restantes ? `${latestCal.dias_restantes} días restantes` : 'Conforme ISO 10012'}
            </p>
          </div>

          <div className="bg-slate-50 dark:bg-slate-800/60 border border-slate-200 dark:border-slate-700/80 p-4 rounded-2xl">
            <span className="text-xs font-bold uppercase tracking-wider text-slate-500 dark:text-slate-400">
              Valor Neto en Libros
            </span>
            <p className="text-lg font-black text-slate-900 dark:text-white mt-2">
              ${(assetDeprec?.valor_neto_libros_usd || asset.costo_adquisicion_usd || 41012).toLocaleString()} USD
            </p>
            <p className="text-xs text-slate-500 dark:text-slate-400 mt-1">Línea recta SUDEBIP</p>
          </div>

        </div>

        {/* ========================================================================= */}
        {/* SECCIÓN 1: TAXONOMÍA, JERARQUÍA Y LOCALIZACIÓN FÍSICA                    */}
        {/* ========================================================================= */}
        <div className="border border-slate-200 dark:border-slate-700 rounded-2xl p-5 sm:p-6 bg-white dark:bg-slate-900/60 space-y-4">
          <div className="flex items-center space-x-2 text-blue-700 dark:text-blue-400 border-b border-slate-200 dark:border-slate-700 pb-2.5">
            <Building2 className="w-5 h-5 flex-shrink-0" />
            <h3 className="font-extrabold text-sm sm:text-base uppercase tracking-wider">
              SECCIÓN 1: TAXONOMÍA, JERARQUÍA Y LOCALIZACIÓN FÍSICA (PDVSA MM-02-01-01 / ISO 55001:2024)
            </h3>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm">
            <div>
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase">Denominación del Instrumento:</span>
              <p className="font-extrabold text-slate-900 dark:text-white text-base mt-0.5">{asset.nombre}</p>
            </div>
            <div>
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase">Complejo / Sede Operativa:</span>
              <p className="font-bold text-slate-800 dark:text-slate-200 mt-0.5">{asset.sede || 'Centro de Investigación y Apoyo Tecnológico (Los Teques)'}</p>
            </div>
            <div>
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase">Gerencia / Unidad Administradora:</span>
              <p className="font-bold text-slate-800 dark:text-slate-200 mt-0.5">{asset.gerencia || 'Gerencia de Ambiente / Dpto. Tecnologías Ambientales'}</p>
            </div>
            <div>
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase">Laboratorio / Sala de Ensayo:</span>
              <p className="font-bold text-slate-800 dark:text-slate-200 mt-0.5">{asset.laboratorio}</p>
            </div>
            <div>
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase">Sistema / Subsistema PDVSA:</span>
              <p className="font-bold text-slate-800 dark:text-slate-200 mt-0.5">{asset.sistema || 'Sistema Cromatográfico / Subsistema Inyección-MSD'}</p>
            </div>
            <div>
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase">Custodio Responsable Integral:</span>
              <p className="font-bold text-slate-800 dark:text-slate-200 mt-0.5">{asset.custodio || 'Dra. Elena Salazar (Jefe de Laboratorio)'}</p>
            </div>
          </div>
        </div>

        {/* ========================================================================= */}
        {/* SECCIÓN 2: REGISTRO Y CONTROL PATRIMONIAL DE BIENES PÚBLICOS             */}
        {/* ========================================================================= */}
        <div className="border border-slate-200 dark:border-slate-700 rounded-2xl p-5 sm:p-6 bg-white dark:bg-slate-900/60 space-y-4">
          <div className="flex items-center space-x-2 text-indigo-700 dark:text-indigo-400 border-b border-slate-200 dark:border-slate-700 pb-2.5">
            <QrCode className="w-5 h-5 flex-shrink-0" />
            <h3 className="font-extrabold text-sm sm:text-base uppercase tracking-wider">
              SECCIÓN 2: REGISTRO Y CONTROL PATRIMONIAL DE BIENES PÚBLICOS (SUDEBIP / LOBP)
            </h3>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm">
            <div>
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase">Código Patrimonial SIGEBI / SUDEBIP:</span>
              <p className="font-mono font-bold text-slate-900 dark:text-white mt-0.5">{asset.codigo_sudebip}</p>
            </div>
            <div>
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase">N° Etiqueta / Bien Nacional (QR):</span>
              <p className="font-mono font-bold text-slate-900 dark:text-white mt-0.5">{asset.numero_etiqueta_qr || 'BN-INT-88492'}</p>
            </div>
            <div>
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase">Condición Física del Bien:</span>
              <p className="font-bold text-slate-800 dark:text-slate-200 mt-0.5">{asset.condicion_fisica || 'Buena'}</p>
            </div>
            <div>
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase">Costo Histórico de Adquisición:</span>
              <p className="font-mono font-bold text-slate-900 dark:text-white mt-0.5">${(asset.costo_adquisicion_usd || 85000).toLocaleString()} USD</p>
            </div>
            <div>
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase">Depreciación Acumulada:</span>
              <p className="font-mono font-bold text-slate-900 dark:text-white mt-0.5">${(assetDeprec?.depreciacion_acumulada_usd || 43987.5).toLocaleString()} USD</p>
            </div>
            <div>
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase">Vida Útil Contable:</span>
              <p className="font-bold text-slate-800 dark:text-slate-200 mt-0.5">{asset.vida_util_anos || 10} Años (Método Línea Recta)</p>
            </div>
            <div>
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase">Clasificación Catálogo SUDEBIP:</span>
              <p className="font-bold text-slate-800 dark:text-slate-200 mt-0.5">{asset.clasificacion_sudebip || 'Equipos Científicos y de Lab. (Cat. 2.04.02)'}</p>
            </div>
            <div>
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase">N° Orden Compra / Factura:</span>
              <p className="font-mono font-bold text-slate-800 dark:text-slate-200 mt-0.5">{asset.nro_orden_compra || 'OC-INTEVEP-2021-089'}</p>
            </div>
            <div>
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase">Estatus de Registro SIGEBI:</span>
              <p className="font-bold text-emerald-600 dark:text-emerald-400 mt-0.5">{asset.estatus_sigebi || 'Incorporado Conforme'}</p>
            </div>
          </div>
        </div>

        {/* ========================================================================= */}
        {/* SECCIÓN 3: ESPECIFICACIONES TÉCNICAS Y OPERACIONALES                     */}
        {/* ========================================================================= */}
        <div className="border border-slate-200 dark:border-slate-700 rounded-2xl p-5 sm:p-6 bg-white dark:bg-slate-900/60 space-y-4">
          <div className="flex items-center space-x-2 text-cyan-700 dark:text-cyan-400 border-b border-slate-200 dark:border-slate-700 pb-2.5">
            <Cpu className="w-5 h-5 flex-shrink-0" />
            <h3 className="font-extrabold text-sm sm:text-base uppercase tracking-wider">
              SECCIÓN 3: ESPECIFICACIONES TÉCNICAS Y OPERACIONALES (ISO/IEC 17025:2017 Cl. 6.4 / ISO 10012)
            </h3>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm">
            <div>
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase">Fabricante / Marca:</span>
              <p className="font-bold text-slate-900 dark:text-white mt-0.5">{asset.marca || 'Agilent Technologies Inc.'}</p>
            </div>
            <div>
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase">Modelo:</span>
              <p className="font-bold text-slate-900 dark:text-white mt-0.5">{asset.modelo || '8890 GC System / 5977B MSD'}</p>
            </div>
            <div>
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase">Número de Serie Principal:</span>
              <p className="font-mono font-bold text-slate-900 dark:text-white mt-0.5">{asset.serial || 'US19482014'}</p>
            </div>
            <div>
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase">Rango de Medición / Operativo:</span>
              <p className="font-bold text-slate-800 dark:text-slate-200 mt-0.5">{asset.rango_medicion || '1.6 a 1050 u (Resolución 0.1 u)'}</p>
            </div>
            <div>
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase">Límite de Detección / Sensibilidad:</span>
              <p className="font-bold text-slate-800 dark:text-slate-200 mt-0.5">{asset.limite_deteccion || 'IDL < 5 fg Octafluoronaftaleno (OFN)'}</p>
            </div>
            <div>
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase">Error Máximo Permisible (MEP):</span>
              <p className="font-bold text-slate-800 dark:text-slate-200 mt-0.5">{asset.mep || 'Desviación masa ≤ ±0.10 u | RT < 0.008 min'}</p>
            </div>
            <div>
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase">Software / Firmware Validado:</span>
              <p className="font-bold text-slate-800 dark:text-slate-200 mt-0.5">{asset.software_version || 'OpenLab CDS ChemStation Rev. C.01.10'}</p>
            </div>
            <div>
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase">Suministro Eléctrico y Respaldo:</span>
              <p className="font-bold text-slate-800 dark:text-slate-200 mt-0.5">{asset.suministro_electrico || '220 VAC, 60 Hz / Respaldo UPS 10 kVA'}</p>
            </div>
            <div>
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase">Precinto de Seguridad (ISO 10012):</span>
              <p className="font-mono font-bold text-blue-700 dark:text-blue-400 mt-0.5">{asset.precinto_seguridad || 'PDVSA-CAL-2026-01'}</p>
            </div>
          </div>
        </div>

        {/* ========================================================================= */}
        {/* SECCIÓN 4: GESTIÓN METROLÓGICA Y CONFIRMACIÓN                            */}
        {/* ========================================================================= */}
        <div className="border border-slate-200 dark:border-slate-700 rounded-2xl p-5 sm:p-6 bg-white dark:bg-slate-900/60 space-y-4">
          <div className="flex items-center space-x-2 text-emerald-700 dark:text-emerald-400 border-b border-slate-200 dark:border-slate-700 pb-2.5">
            <Scale className="w-5 h-5 flex-shrink-0" />
            <h3 className="font-extrabold text-sm sm:text-base uppercase tracking-wider">
              SECCIÓN 4: GESTIÓN METROLÓGICA Y CONFIRMACIÓN (ISO/IEC 17025:2017 / ISO 10012:2003)
            </h3>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm">
            <div>
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase">Frecuencia Calibración Externa:</span>
              <p className="font-bold text-slate-900 dark:text-white mt-0.5">{asset.frecuencia_calibracion || 'Anual (Intervalo: 12 Meses)'}</p>
            </div>
            <div>
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase">Entidad Metrológica Acreditada:</span>
              <p className="font-bold text-slate-900 dark:text-white mt-0.5">{latestCal?.entidad_acreditada || 'SENCAMER / Lab. Acreditado ISO 17025'}</p>
            </div>
            <div>
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase">N° Certificado de Calibración:</span>
              <p className="font-mono font-bold text-blue-700 dark:text-blue-400 mt-0.5">{latestCal?.nro_certificado || 'CERT-MET-2026-884'}</p>
            </div>
            <div>
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase">Fecha Última Calibración:</span>
              <p className="font-mono font-bold text-slate-800 dark:text-slate-200 mt-0.5">{latestCal?.fecha_calibracion || '2026-06-15'}</p>
            </div>
            <div>
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase">Fecha Próxima Calibración:</span>
              <p className="font-mono font-bold text-slate-800 dark:text-slate-200 mt-0.5">{latestCal?.fecha_vencimiento || '2027-06-15'}</p>
            </div>
            <div>
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase">Incertidumbre Expandida (U, k=2):</span>
              <p className="font-bold text-slate-800 dark:text-slate-200 mt-0.5">{latestCal?.incertidumbre_u || 'U = ± 0.05 u (95%)'}</p>
            </div>
            <div>
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase">Dictamen Metrológico Oficial:</span>
              <p className="font-extrabold text-emerald-600 dark:text-emerald-400 mt-0.5">{latestCal?.dictamen || 'Conforme (Pasa)'}</p>
            </div>
            <div>
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase">Frecuencia Comprobación Intermedia:</span>
              <p className="font-bold text-slate-800 dark:text-slate-200 mt-0.5">{asset.frecuencia_comprobacion || 'Mensual (Cl. 6.4.10)'}</p>
            </div>
            <div>
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase">Rótulo Operacional en Equipo:</span>
              <p className="font-extrabold text-emerald-600 dark:text-emerald-400 mt-0.5">ETIQUETA VERDE - EN SERVICIO</p>
            </div>
          </div>
        </div>

        {/* ========================================================================= */}
        {/* SECCIÓN 5: SEGURIDAD, SALUD LABORAL Y AMBIENTE (LOPCYMAT / SIHO)        */}
        {/* ========================================================================= */}
        <div className="border border-slate-200 dark:border-slate-700 rounded-2xl p-5 sm:p-6 bg-white dark:bg-slate-900/60 space-y-4">
          <div className="flex items-center space-x-2 text-amber-700 dark:text-amber-400 border-b border-slate-200 dark:border-slate-700 pb-2.5">
            <AlertOctagon className="w-5 h-5 flex-shrink-0" />
            <h3 className="font-extrabold text-sm sm:text-base uppercase tracking-wider">
              SECCIÓN 5: SEGURIDAD, SALUD LABORAL Y AMBIENTE (LOPCYMAT / SIHO PDVSA)
            </h3>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm">
            <div>
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase">Riesgos Físicos Ocupacionales:</span>
              <p className="font-bold text-slate-800 dark:text-slate-200 mt-0.5">{asset.riesgos_fisicos || 'Gases comprimidos alta presión (Helio/H2 80 psi); Ruido bomba'}</p>
            </div>
            <div>
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase">EPP Mandatorio en Operación:</span>
              <p className="font-bold text-slate-800 dark:text-slate-200 mt-0.5">{asset.epp_operacion || 'Lentes de seguridad lateral, guantes nitrilo, bata antiestática'}</p>
            </div>
            <div>
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase">Riesgos Químicos Asociados:</span>
              <p className="font-bold text-slate-800 dark:text-slate-200 mt-0.5">{asset.riesgos_quimicos || 'Vapores solventes orgánicos (Hexano, Diclorometano, Metanol)'}</p>
            </div>
            <div>
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase">Procedimiento de Bloqueo LOTO:</span>
              <p className="font-bold text-slate-800 dark:text-slate-200 mt-0.5">{asset.procedimiento_loto || 'Aplica: SIHO-PDVSA-LOTO-08 (Desconexión eléctrica y purga)'}</p>
            </div>
            <div>
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase">Dispositivos de Seguridad Integrados:</span>
              <p className="font-bold text-slate-800 dark:text-slate-200 mt-0.5">{asset.dispositivos_seguridad || 'Sensor de fuga de H2 con corte automático, extracción forzada'}</p>
            </div>
            <div>
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase">Ubicación Equipos de Emergencia:</span>
              <p className="font-bold text-slate-800 dark:text-slate-200 mt-0.5">{asset.ubicacion_emergencia || 'Ducha de seguridad y lavaojos a 5 m; Extintor CO2 a 3 m'}</p>
            </div>
          </div>
        </div>

        {/* ========================================================================= */}
        {/* SECCIÓN 6: ESTRATEGIA Y GESTIÓN DE MANTENIMIENTO                         */}
        {/* ========================================================================= */}
        <div className="border border-slate-200 dark:border-slate-700 rounded-2xl p-5 sm:p-6 bg-white dark:bg-slate-900/60 space-y-4">
          <div className="flex items-center space-x-2 text-rose-700 dark:text-rose-400 border-b border-slate-200 dark:border-slate-700 pb-2.5">
            <Wrench className="w-5 h-5 flex-shrink-0" />
            <h3 className="font-extrabold text-sm sm:text-base uppercase tracking-wider">
              SECCIÓN 6: ESTRATEGIA Y GESTIÓN DE MANTENIMIENTO (PDVSA MM-02-01-01 / ISO 55001)
            </h3>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm">
            <div>
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase">Estrategia de Mantenimiento:</span>
              <p className="font-bold text-slate-900 dark:text-white mt-0.5">{asset.estrategia_mantenimiento || 'Preventivo Planificado Sistemático y Predictivo'}</p>
            </div>
            <div>
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase">Frecuencia Preventiva:</span>
              <p className="font-bold text-slate-900 dark:text-white mt-0.5">{asset.frecuencia_mantenimiento || 'Trimestral (Menor) y Anual (Mayor)'}</p>
            </div>
            <div>
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase">Código Plan PDVSA:</span>
              <p className="font-mono font-bold text-slate-900 dark:text-white mt-0.5">{asset.codigo_plan_pdvsa || 'PM-LAB-GCMS-TRIM'}</p>
            </div>
            <div>
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase">Última Orden de Trabajo (OT):</span>
              <p className="font-mono font-bold text-blue-700 dark:text-blue-400 mt-0.5">{latestOT?.nro_ot || 'OT-PDVSA-2026-018'}</p>
            </div>
            <div>
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase">Estatus Última OT:</span>
              <p className="font-bold text-emerald-600 dark:text-emerald-400 mt-0.5">{latestOT?.estatus_ot || 'Cerrada / Completada'}</p>
            </div>
            <div>
              <span className="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase">Proveedor / Custodio Técnico:</span>
              <p className="font-bold text-slate-800 dark:text-slate-200 mt-0.5">{asset.proveedor_tecnico || 'Taller Mantenimiento Instrumental INTEVEP'}</p>
            </div>
          </div>
        </div>

        {/* Audit Signatures Footer */}
        <div className="pt-6 border-t border-slate-200 dark:border-slate-800 flex flex-col sm:flex-row justify-between items-center gap-6 text-xs text-slate-500 dark:text-slate-400 font-medium">
          <div className="text-center sm:text-left">
            <div className="w-48 border-b border-slate-400 dark:border-slate-600 mb-1 mx-auto sm:mx-0"></div>
            <p className="font-bold text-slate-800 dark:text-slate-200">Dra. Elena Salazar</p>
            <p>Custodio Responsable / Jefe de Laboratorio</p>
          </div>

          <div className="text-center sm:text-right">
            <div className="w-48 border-b border-slate-400 dark:border-slate-600 mb-1 mx-auto sm:ml-auto"></div>
            <p className="font-bold text-slate-800 dark:text-slate-200">Ing. Carlos Mendoza</p>
            <p>Coordinador SGA / Líder Calidad GAMB</p>
          </div>
        </div>

      </div>

    </div>
  );
};
