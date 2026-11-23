// ========================================================================
// SISTEMA INTEGRADO DE GESTIÓN DE ACTIVOS FÍSICOS (SGAF)
// Fórmulas Oficiales: PDVSA MM-02-01-01 | ISO 55001:2024 | ISO 10012
// ========================================================================

/**
 * 1. Consecuencia (C) según PDVSA MM-02-01-01
 * C = (IO x FO) + CM + SHA
 * IO: Impacto Operacional (1 a 10)
 * FO: Flexibilidad Operacional (1 a 4)
 * CM: Costo Mantenimiento (1 a 3)
 * SHA: Impacto en Seguridad, Higiene y Ambiente (1 a 8)
 */
export function calculateConsecuencia(io: number, fo: number, cm: number, sha: number): number {
  return (io * fo) + cm + sha;
}

/**
 * 2. Índice de Criticidad (IC) según PDVSA MM-02-01-01
 * IC = FF x C
 * FF: Frecuencia de Falla (1 a 4)
 */
export function calculateCriticidad(ff: number, consecuencia: number): number {
  return ff * consecuencia;
}

/**
 * 3. Categoría de Criticidad según IC
 * Nivel A (Alto - Crítico): IC >= 80
 * Nivel B (Medio - Semicrítico): 40 <= IC < 80
 * Nivel C (Bajo - No Crítico): IC < 40
 */
export function getCategoriaCriticidad(ic: number): {
  categoria: 'Nivel A (Alto - Crítico)' | 'Nivel B (Medio - Semicrítico)' | 'Nivel C (Bajo - No Crítico)';
  estatusSeleccion: string;
  criterioAccion: string;
} {
  if (ic >= 80) {
    return {
      categoria: 'Nivel A (Alto - Crítico)',
      estatusSeleccion: 'Selección Obligatoria (Pasa a Evaluación)',
      criterioAccion: 'Evaluación integral de riesgos en todo el ciclo de vida (Adquisición, O&M, Disposición)'
    };
  } else if (ic >= 40) {
    return {
      categoria: 'Nivel B (Medio - Semicrítico)',
      estatusSeleccion: 'Selección Condicionada (Pasa a Evaluación)',
      criterioAccion: 'Evaluación de riesgos focalizada en Operación y Mantenimiento (o completa si Iobs > 66%)'
    };
  } else {
    return {
      categoria: 'Nivel C (Bajo - No Crítico)',
      estatusSeleccion: 'No Aplica',
      criterioAccion: 'No justifica matriz individual de riesgos; gestión por mantenimiento rutinario y control básico'
    };
  }
}

/**
 * 4. Índice de Obsolescencia Ponderado (Iobs)
 * Iobs = [(EOL + REP + MET + ANT) / 12] x 100%
 * Cada variable ponderada de 1 a 3. Suma máxima = 12.
 */
export function calculateIobs(eol: number, rep: number, met: number, ant: number): {
  suma: number;
  iobs: number;
  estatus: 'Obsolescencia Crítica' | 'Obsolescencia Media' | 'Obsolescencia Baja';
} {
  const suma = eol + rep + met + ant;
  const iobs = (suma / 12) * 100;

  let estatus: 'Obsolescencia Crítica' | 'Obsolescencia Media' | 'Obsolescencia Baja' = 'Obsolescencia Baja';
  if (iobs > 66.67) {
    estatus = 'Obsolescencia Crítica';
  } else if (iobs >= 50) {
    estatus = 'Obsolescencia Media';
  } else {
    estatus = 'Obsolescencia Baja';
  }

  return {
    suma,
    iobs: parseFloat(iobs.toFixed(2)),
    estatus
  };
}

/**
 * 5. Matriz de Cruce Multicriterio (NR x Iobs) y Decisiones Sugeridas
 * NR: Nivel de Riesgo (1 a 9)
 * Iobs: Índice de Obsolescencia en %
 */
export function getMatrizCruceDecision(nr: number, iobs: number): {
  resultadoCruce: string;
  decisionSugerida: string;
  prioridad: 'Urgente / Nivel 1' | 'Mediano Plazo' | 'Monitoreo' | 'Rutinario';
  badgeColor: string;
} {
  if (nr >= 6 && iobs > 66.67) {
    return {
      resultadoCruce: 'CRÍTICO EXTREMO',
      decisionSugerida: 'Sustitución Inmediata y Plan de Inversión CAPEX prioritario. Riesgo no tolerable.',
      prioridad: 'Urgente / Nivel 1',
      badgeColor: 'bg-red-600 text-white'
    };
  } else if (nr >= 6 && iobs <= 66.67) {
    return {
      resultadoCruce: 'ALTO RIESGO OPERACIONAL',
      decisionSugerida: 'Plan de Mitigación Operativa y Mantenimiento Predictivo Reforzado. Stock crítico de repuestos.',
      prioridad: 'Urgente / Nivel 1',
      badgeColor: 'bg-orange-600 text-white'
    };
  } else if (nr < 6 && iobs > 66.67) {
    return {
      resultadoCruce: 'OBSOLESCENCIA ALTA',
      decisionSugerida: 'Reemplazo Planificado a Mediano Plazo o Inicio de Trámite de Desincorporación SUDEBIP.',
      prioridad: 'Mediano Plazo',
      badgeColor: 'bg-amber-500 text-white'
    };
  } else if (nr >= 3 && iobs <= 66.67) {
    return {
      resultadoCruce: 'MODERADO CONTROLABLE',
      decisionSugerida: 'Monitoreo Periódico de Condición y Verificación Metrológica ISO 10012.',
      prioridad: 'Monitoreo',
      badgeColor: 'bg-blue-600 text-white'
    };
  } else {
    return {
      resultadoCruce: 'ACEPTABLE',
      decisionSugerida: 'Gestión por Mantenimiento Rutinario y Operación Estándar.',
      prioridad: 'Rutinario',
      badgeColor: 'bg-emerald-600 text-white'
    };
  }
}

/**
 * 6. Cálculo de Vida Útil Transcurrida y Remanente
 */
export function calculateVidaUtil(startupDateStr?: string, lifeYears: number = 10): {
  porcentajeConsumido: number;
  anosTranscurridos: number;
  anosRestantes: number;
  esObsoletoPorVidaUtil: boolean;
  alertaVencimientoProximo: boolean; // Menos de 2 años o >= 80%
} {
  if (!startupDateStr) {
    return {
      porcentajeConsumido: 0,
      anosTranscurridos: 0,
      anosRestantes: lifeYears,
      esObsoletoPorVidaUtil: false,
      alertaVencimientoProximo: false
    };
  }

  const startDate = new Date(startupDateStr);
  const now = new Date();
  const diffMs = now.getTime() - startDate.getTime();
  const diffYears = diffMs / (1000 * 60 * 60 * 24 * 365.25);

  const porcentaje = Math.min(Math.max((diffYears / lifeYears) * 100, 0), 100);
  const anosRestantes = Math.max(lifeYears - diffYears, 0);

  return {
    porcentajeConsumido: parseFloat(porcentaje.toFixed(1)),
    anosTranscurridos: parseFloat(diffYears.toFixed(1)),
    anosRestantes: parseFloat(anosRestantes.toFixed(1)),
    esObsoletoPorVidaUtil: diffYears >= lifeYears,
    alertaVencimientoProximo: diffYears >= (lifeYears * 0.8) && diffYears < lifeYears
  };
}

/**
 * 7. Catálogo Oficial Estandarizado de Decisiones Estratégicas y Operativas (SAMP / ISO 55001)
 */
export const CATALOGO_DECISIONES_ESTRATEGICAS = [
  'Reemplazo Inmediato (Inversión CAPEX)',
  'Reemplazo a Mediano Plazo (Ciclo 24 Meses)',
  'Modernización / Retrofit Tecnológico',
  'Mantenimiento Mayor Overhaul',
  'Continuar Operación / Plan Mantenimiento Preventivo',
  'Desincorporación / Enajenación Patrimonial (SUDEBIP)'
] as const;

export const CATALOGO_DECISIONES_OPERATIVAS = [
  'Plan de Mantenimiento Preventivo Riguroso',
  'Recalibración / Verificación Metrológica Urgente',
  'Aprovisionamiento Prioritario de Repuestos Críticos',
  'Inspección Predictiva Frecuente (Control de Deriva FO-018)',
  'Operación Estándar y Monitoreo Rutinario'
] as const;

export interface RecomendacionIAExperta {
  decisionEstrategica: typeof CATALOGO_DECISIONES_ESTRATEGICAS[number];
  decisionOperativa: typeof CATALOGO_DECISIONES_OPERATIVAS[number];
  justificacionTecnica: string;
  prioridad: 'Inmediata (30 días)' | 'Alta (90 días)' | 'Media (180 días)' | 'Rutinaria (360 días)';
  plazoMeses: number;
  clausulaISO: string;
  normaPDVSA: string;
  accionesRecomendadas: string[];
}

/**
 * 8. Motor Asesor Experto e Inteligencia de Decisiones ISO 55001 & PDVSA MM-02-01-01
 * Evalúa el vector multidimensional del activo (IC, Iobs, Riesgo, Deriva, Operatividad)
 * y emite una recomendación técnica estandarizada y justificada.
 */
export function getAsesorInteligenteDecision(activo: any): RecomendacionIAExperta {
  const ic = Number(activo.ic || activo.jerarquizacion?.ic || 0);
  const iobs = Number(activo.iobs || activo.obsolescencia?.iobs || 0);
  const cruce = (activo.resultado_cruce || activo.decision?.cruce_resultado || '').toUpperCase();
  const esInoperativo = (activo.estado_operativo || '').toLowerCase().includes('inoperativo');

  // Escenario 1: Crítico Extremo o Inoperativo de Alta Criticidad
  if (cruce.includes('CRÍTICO EXTREMO') || (ic >= 80 && iobs > 66.7) || (esInoperativo && ic >= 80)) {
    return {
      decisionEstrategica: 'Reemplazo Inmediato (Inversión CAPEX)',
      decisionOperativa: 'Aprovisionamiento Prioritario de Repuestos Críticos',
      justificacionTecnica: `El activo presenta un Nivel de Criticidad Crítico (IC=${ic}) con Obsolescencia Crítica (Iobs=${iobs}%). Conforme a ISO 55001 Cl. 6.2 y PDVSA MM-02-01-01, este equipo genera un riesgo no tolerable para la continuidad de los ensayos analíticos de la Gerencia de Ambiente, requiriendo sustitución inmediata en el plan CAPEX.`,
      prioridad: 'Inmediata (30 días)',
      plazoMeses: 3,
      clausulaISO: 'ISO 55001:2024 Cl. 6.2 Planificación del Tratamiento de Riesgos',
      normaPDVSA: 'PDVSA MM-02-01-01 Sección 5.4',
      accionesRecomendadas: [
        'Elaborar pliego de especificaciones técnicas para licitación de compra CAPEX',
        'Declarar stock de contingencia o subcontratar ensayos a laboratorios acreditados de la red INTEVEP',
        'Iniciar expediente de desincorporación progresiva ante la SUDEBIP'
      ]
    };
  }

  // Escenario 2: Alto Riesgo Operacional (Alta Criticidad pero Obsolescencia Media o Baja)
  if (cruce.includes('ALTO RIESGO') || (ic >= 80 && iobs <= 66.7)) {
    return {
      decisionEstrategica: 'Mantenimiento Mayor Overhaul',
      decisionOperativa: 'Plan de Mantenimiento Preventivo Riguroso',
      justificacionTecnica: `Activo vital de alta criticidad (IC=${ic}) cuya tecnología aún es viable (Iobs=${iobs}%). La estrategia óptima según ISO 55001 Cl. 8.1 es extender su vida útil mediante un mantenimiento mayor programado (Overhaul), asegurando disponibilidad continua de repuestos críticos.`,
      prioridad: 'Alta (90 días)',
      plazoMeses: 6,
      clausulaISO: 'ISO 55001:2024 Cl. 8.1 Control Operacional y Planes de Mantenimiento',
      normaPDVSA: 'PDVSA MM-02-01-01 Sección 6.2',
      accionesRecomendadas: [
        'Programar parada técnica para mantenimiento mayor en taller instrumental',
        'Realizar calibración metrológica acreditada con cálculo de incertidumbre',
        'Garantizar suministro de consumibles y piezas de desgaste periódico'
      ]
    };
  }

  // Escenario 3: Obsolescencia Alta con Criticidad Media o Baja
  if (cruce.includes('OBSOLESCENCIA ALTA') || (iobs > 66.7 && ic < 80)) {
    return {
      decisionEstrategica: 'Reemplazo a Mediano Plazo (Ciclo 24 Meses)',
      decisionOperativa: 'Inspección Predictiva Frecuente (Control de Deriva FO-018)',
      justificacionTecnica: `El equipo presenta alta obsolescencia tecnológica (Iobs=${iobs}%) con bajo soporte de repuestos por fabricante. Dado que su criticidad es moderada (IC=${ic}), se planifica su sustitución en el ciclo presupuestario de 24 meses mientras se controla su deriva metrológica según FO-018.`,
      prioridad: 'Media (180 días)',
      plazoMeses: 12,
      clausulaISO: 'ISO 55001:2024 Cl. 10.3 Acción Predictiva y Gestión de Obsolescencia',
      normaPDVSA: 'PDVSA MM-01-01-07 Criterios de Obsolescencia Tecnológica',
      accionesRecomendadas: [
        'Monitorear quincenalmente la deriva metrológica contra el Límite de Tolerancia Metrológica (LTM)',
        'Consolidar informe técnico de obsolescencia para el Comité de Gestión de Activos',
        'Incluir en el Plan de Adquisiciones Estratégicas (PEGA) a mediano plazo'
      ]
    };
  }

  // Escenario 4: Moderado / Modernización
  if (cruce.includes('MODERADO') || (ic >= 40 && iobs >= 40)) {
    return {
      decisionEstrategica: 'Modernización / Retrofit Tecnológico',
      decisionOperativa: 'Recalibración / Verificación Metrológica Urgente',
      justificacionTecnica: `Activo semicrítico (IC=${ic}) con obsolescencia moderada (Iobs=${iobs}%). La intervención más rentable es actualizar componentes modulares, tarjetas electrónicas o software de adquisición de datos (Retrofit) sin cambiar la estructura principal del equipo.`,
      prioridad: 'Media (180 días)',
      plazoMeses: 6,
      clausulaISO: 'ISO 55001:2024 Cl. 6.2.2 Objetivos de Gestión de Activos',
      normaPDVSA: 'PDVSA MM-02-01-01 Prácticas de Modernización Tecnológica',
      accionesRecomendadas: [
        'Evaluar compatibilidad de kit de actualización o retrofit con el fabricante',
        'Ejecutar comprobación intermedia para verificar repetibilidad analítica',
        'Actualizar la Hoja de Vida Integral con la nueva configuración'
      ]
    };
  }

  // Escenario 5: Aceptable / Rutinario
  return {
    decisionEstrategica: 'Continuar Operación / Plan Mantenimiento Preventivo',
    decisionOperativa: 'Operación Estándar y Monitoreo Rutinario',
    justificacionTecnica: `El activo opera en condiciones nominales de bajo riesgo (IC=${ic}) y baja obsolescencia (Iobs=${iobs}%). Conforme a ISO 55001 Cl. 8.1, se mantiene la rutina establecida de mantenimiento preventivo planificado (AMB-GEN-SGA-FO-008) e inspección periódica de laboratorio.`,
    prioridad: 'Rutinaria (360 días)',
    plazoMeses: 12,
    clausulaISO: 'ISO 55001:2024 Cl. 8.1 Procesos Operacionales del SGA',
    normaPDVSA: 'PDVSA MM-02-01-01 Rutinas de Mantenimiento Preventivo',
    accionesRecomendadas: [
      'Cumplir con la pauta semestral de mantenimiento preventivo',
      'Registrar calibraciones rutinarias según frecuencia establecida',
      'Mantener orden y limpieza bajo lineamientos de laboratorio seguro'
    ]
  };
}

