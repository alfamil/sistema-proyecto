export type UserRole = 'admin' | 'analista' | 'mantenimiento' | 'sudebip' | 'gerente';

export interface UsuarioSistema {
  id: string;
  email: string;
  nombre_completo: string;
  rol: UserRole;
  cargo?: string;
  laboratorio?: string;
  clave_demo?: string;
  activo?: boolean;
}

export interface PermisoAcceso {
  ver: boolean;
  crear: boolean;
  editar: boolean;
  eliminar: boolean;
}

export type PermisosPorRol = Record<UserRole, Record<string, PermisoAcceso>>;

export interface CatalogoParametro {
  id?: string;
  categoria: string;
  codigo: string;
  nombre: string;
  descripcion?: string;
  orden?: number;
  activo?: boolean;
}

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
  categoria_criticidad?: string;        // Clase A, Clase B, Clase C
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
  cruce_resultado?: string;
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

export interface CalibracionMetrologica {
  id?: string;
  id_calibracion: string;
  tag_pdvsa: string;
  nro_certificado: string;
  fecha_calibracion: string;
  fecha_vencimiento: string;
  dias_restantes: number;
  estatus_metrologico: 'VIGENTE' | 'POR VENCER' | 'VENCIDA' | string;
  entidad_acreditada: string;
  patron_utilizado?: string;
  desviacion_observada?: string;
  incertidumbre_u?: string;
  mep_tolerancia?: string;
  dictamen: 'Conforme (Pasa)' | 'Conforme con Restricciones' | 'No Conforme (No Pasa / Requiere Ajuste)' | string;
  precinto_colocado?: string;
  metrologo_responsable?: string;
  observaciones?: string;
}

export interface MantenimientoPDVSA {
  id?: string;
  nro_ot: string;
  tag_pdvsa: string;
  tipo_mantenimiento: string;
  codigo_plan_pdvsa?: string;
  fecha_inicio: string;
  fecha_cierre?: string;
  descripcion: string;
  repuestos_reemplazados?: string;
  horas_hombre: number;
  costo_total_usd: number;
  responsable_ejecucion: string;
  impacto_ensayos_iso17025?: string;
  requiere_recalibracion?: boolean;
  estatus_ot: string;
  aprobado_por?: string;
  proximo_mantenimiento?: string;
}

export interface ComprobacionIntermedia {
  id?: string;
  id_comprobacion: string;
  tag_pdvsa: string;
  fecha_verificacion: string;
  parametro_verificado: string;
  patron_referencia: string;
  limite_min: number;
  limite_max: number;
  valor_experimental: number;
  dictamen_auto: 'CONFORME (PASA)' | 'NO CONFORME (NO PASA)' | string;
  desviacion_observada?: string;
  rotulado_operativo: string;
  analista_responsable: string;
  observaciones?: string;
}

export interface DerivaMetrologicaLectura {
  id?: string;
  nro_reg: number;
  tag_pdvsa: string;
  fecha_medicion: string;
  analista: string;
  temperatura_c?: number;
  humedad_hr?: number;
  valor_nominal_ppm: number;
  valor_medido_ppm: number;
  sesgo_absoluto: number;
  consumo_ltm_pct: number;
  zona_riesgo: 'Verde (<60%)' | 'Amarilla (60-79%)' | 'Roja (>=80%)' | string;
}

export interface DepreciacionPatrimonial {
  id?: string;
  tag_pdvsa: string;
  codigo_sigebi?: string;
  denominacion: string;
  fecha_incorporacion?: string;
  costo_adquisicion_usd: number;
  tasa_salvamento: number;
  valor_residual_salvamento: number;
  base_depreciable_usd: number;
  vida_util_anos: number;
  meses_uso: number;
  depreciacion_mensual_usd: number;
  depreciacion_acumulada_usd: number;
  valor_neto_libros_usd: number;
}

export interface ActaMovimientoSudebip {
  id?: string;
  nro_acta: string;
  tag_pdvsa: string;
  fecha_movimiento: string;
  tipo_movimiento: string;
  unidad_emisora: string;
  unidad_receptora: string;
  responsable_entrega: string;
  responsable_receptor: string;
  nro_autorizacion?: string;
  condicion_fisica?: string;
  motivo?: string;
  estatus_sigebi?: string;
  observaciones?: string;
}

export interface KpiSGA {
  numero: number;
  indicador: string;
  dimension: string;
  formula: string;
  meta: string;
  frecuencia: string;
  responsable: string;
  valor_real_q3: number;
  valor_real_texto?: string;
}

export interface AcuerdoDireccion {
  codigo: string;
  requisito_iso: string;
  acuerdo_adoptado: string;
  responsable: string;
  fecha_limite?: string;
  recursos_aprobados?: string;
  mecanismo_verificacion?: string;
  estatus?: string;
}

export interface CierreBrecha {
  numero: number;
  cod_brecha: string;
  origen_brecha: string;
  clausula_iso: string;
  laboratorio: string;
  descripcion: string;
  tipo_accion: string;
  causa_raiz_5p: string;
  estatus?: 'No Iniciada' | 'En Proceso' | 'Cerrada';
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
  estado_operativo?: 'Operativo' | 'En Calibración' | 'En Mantenimiento' | 'Fuera de Servicio' | 'Desincorporado' | string;

  // Ubicación y Jerarquía
  filial?: string;
  sede?: string;
  gerencia?: string;
  sistema?: string;
  custodio?: string;
  etapa_ciclo_vida?: string;
  fecha_puesta_servicio?: string;

  // SUDEBIP & Finanzas
  numero_etiqueta_qr?: string;
  condicion_fisica?: string;
  costo_adquisicion_usd?: number;
  clasificacion_sudebip?: string;
  unidad_administradora?: string;
  responsable_patrimonial?: string;
  nro_orden_compra?: string;
  responsable_custodia?: string;
  estatus_sigebi?: string;
  vida_util_anos?: number;
  tasa_salvamento?: number;
  depreciacion_acumulada_usd?: number;
  valor_neto_libros_usd?: number;

  // Metrología ISO 10012 / ISO 17025
  es_equipo_analitico?: boolean;
  rango_medicion?: string;
  rango_temperatura?: string;
  limite_deteccion?: string;
  mep?: string;                          // Error Máximo Permisible
  software_version?: string;             // Software / Firmware Validado
  condiciones_ambientales?: string;
  suministro_electrico?: string;
  precinto_seguridad?: string;
  frecuencia_calibracion?: string;       // Anual, Semestral, etc.
  frecuencia_comprobacion?: string;      // Mensual, Quincenal, etc.
  fecha_ultima_calibracion?: string;
  fecha_proxima_calibracion?: string;
  dias_restantes_calibracion?: number;
  estatus_calibracion?: 'VIGENTE' | 'POR VENCER' | 'VENCIDA' | string;

  // Seguridad & Salud LOPCYMAT / SIHO PDVSA
  riesgos_fisicos?: string;
  epp_operacion?: string;
  riesgos_quimicos?: string;
  epp_mantenimiento?: string;
  riesgos_termicos?: string;
  procedimiento_loto?: string;
  dispositivos_seguridad?: string;
  ubicacion_emergencia?: string;

  // Mantenimiento
  estrategia_mantenimiento?: string;
  frecuencia_mantenimiento?: string;
  codigo_plan_pdvsa?: string;
  proveedor_tecnico?: string;

  // Evaluaciones integradas
  categoria_criticidad?: string;
  iobs?: number | string;
  estatus_obsolescencia?: string;
  nivel_riesgo?: number | string;
  clasificacion_riesgo?: string;
  nivel_oportunidad?: number | string;
  prioridad_oportunidad?: string;
  resultado_cruce?: string;

  jerarquizacion?: JerarquizacionData;
  obsolescencia?: ObsolescenciaData;
  decision?: DecisionData;
  historial_fallas?: HistorialFalla[];
}
