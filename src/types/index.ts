export type UserRole = 'analista' | 'mantenimiento' | 'sudebip' | 'gerente';

export interface SudebipItem {
  codigo: string;
  tipo_equipo: string;
}

export interface JerarquizacionData {
  ff?: number | string | null;          // 1-4
  io?: number | string | null;          // 1-10
  fo?: number | string | null;          // 1-4
  cm?: number | string | null;          // 1-3
  sha?: number | string | null;         // 1-8
  consecuencia?: number | string | null; // (IO x FO) + CM + SHA
  ic?: number | string | null;          // FF x C
  categoria_criticidad?: string;        // Nivel A, Nivel B, Nivel C
  estatus_seleccion?: string;
  criterio_accion?: string;
}

export interface ObsolescenciaData {
  eol?: number | string | null;         // 1-3
  rep?: number | string | null;         // 1-3
  met?: number | string | null;         // 1-3
  ant?: number | string | null;         // 1-3
  suma_puntos?: number | string | null; // Máx 12
  iobs?: number | string | null;        // %
  estatus_obsolescencia?: string;       // Obsolescencia Crítica, Media, Baja
}

export interface DecisionData {
  cruce_resultado?: string;             // CRÍTICO EXTREMO, OBSOLESCENCIA ALTA, etc.
  decision_sugerida_riesgo?: string;
  prioridad_oportunidad?: string;
  decision_sugerida_oportunidad?: string;
  decision_estrategica_final?: string;
  responsable_de?: string;
  fecha_de?: string | null;
  decision_operativa?: string;
  responsable_do?: string;
  fecha_do?: string | null;
}

export interface HistorialFalla {
  id?: string;
  activo_id?: string;
  tag_pdvsa: string;
  nombre_equipo?: string;
  fecha_evento: string;
  tipo_evento: string;                   // Mantenimiento Preventivo, Correctivo, Calibración ISO 10012, Overhaul
  descripcion: string;
  tiempo_fuera_servicio_horas: number;
  impacto_operacional?: string;
  accion_tomada?: string;
  tecnico_responsable?: string;
  costo_reparacion?: number;
  estado?: 'Programado' | 'En Proceso' | 'Completado' | 'Cancelado';
  prioridad?: 'Crítica' | 'Alta' | 'Media' | 'Baja';
}

export interface ActivoFisico {
  id?: string;
  num?: number | string;
  tag_pdvsa: string;                     // Código Taxonomía MM-01-01-07 / MM-02-01-01
  codigo_sudebip: string;                // Código Catálogo SUDEBIP
  codigo_sap?: string;                   // Código SAP Finanzas
  nombre: string;
  marca?: string;
  modelo?: string;
  serial?: string;
  laboratorio: string;
  criticidad_analista?: string;          // Alta, Media, Baja
  tipo_equipo?: string;                  // Clasificación funcional
  pareto_20?: boolean;                   // Muestra vital Pareto (20%)
  estado_operativo?: 'Operativo' | 'En Reparación' | 'Fuera de Servicio' | 'Desincorporado';

  // Metrología ISO 10012
  es_equipo_analitico?: boolean;
  rango_medicion?: string;
  resolucion?: string;
  frecuencia_calibracion?: string;       // Anual, Semestral, Bianual
  fecha_ultima_calibracion?: string;
  fecha_proxima_calibracion?: string;

  // Ciclo de Vida y Valor ISO 55001:2024
  fecha_puesta_marcha?: string;
  vida_util_fabricante_anos?: number;
  capex_costo_adquisicion?: number;
  tco_costo_total?: number;

  // Evaluaciones integradas
  categoria_criticidad?: string;
  iobs?: number | string;
  estatus_obsolescencia?: string;
  nivel_riesgo?: number | string;
  clasificacion_riesgo?: string;
  nivel_oportunidad?: number | string;
  prioridad_oportunidad?: string;
  resultado_cruce?: string;

  jerarquizacion?: JerarquizacionData | null;
  obsolescencia?: ObsolescenciaData | null;
  decision?: DecisionData | null;
  historial_fallas?: HistorialFalla[];
}
