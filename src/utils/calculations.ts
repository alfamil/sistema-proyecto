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

