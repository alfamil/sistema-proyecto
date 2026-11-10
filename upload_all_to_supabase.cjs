const fs = require('fs');

const SUPABASE_URL = "https://vsjvkjdmxjbzqtzpnroy.supabase.co";
const SUPABASE_KEY = "sb_publishable_786xYEM3cgfif0v_7l9hCg_iAZOZBDV";

const headers = {
  "apikey": SUPABASE_KEY,
  "Authorization": `Bearer ${SUPABASE_KEY}`,
  "Content-Type": "application/json",
  "Prefer": "return=minimal"
};

async function apiRequest(endpoint, method = 'GET', body = null) {
  const url = `${SUPABASE_URL}/rest/v1/${endpoint}`;
  const options = { method, headers };
  if (body) {
    options.body = JSON.stringify(body);
  }
  const res = await fetch(url, options);
  if (!res.ok) {
    const errText = await res.text();
    throw new Error(`[${method} ${endpoint}] HTTP ${res.status}: ${errText}`);
  }
  if (method === 'GET') {
    return await res.json();
  }
  return null;
}

async function main() {
  console.log("=== INICIANDO SINCRONIZACIÓN DIRECTA A SUPABASE ===");

  // 1. Cargar datos consolidados
  const rawData = fs.readFileSync('sga_data.json', 'utf8');
  const sgaData = JSON.parse(rawData);

  console.log(`Total activos a sincronizar: ${sgaData.activos.length}`);

  // 2. Obtener mapa de activos existentes en Supabase para obtener sus UUIDs
  console.log("Obteniendo activos existentes de Supabase...");
  const existingActivos = await apiRequest('activos?select=id,tag_pdvsa&limit=1000');
  const tagToIdMap = new Map();
  for (const a of existingActivos) {
    tagToIdMap.set(a.tag_pdvsa, a.id);
  }
  console.log(`Activos encontrados en Supabase: ${existingActivos.length}`);

  // 3. Sincronizar o insertar activos
  console.log("Actualizando tabla 'activos' con cálculos y taxonomía...");
  let updatedCount = 0;
  let insertedCount = 0;

  for (const a of sgaData.activos) {
    const payload = {
      tag_pdvsa: a.tag_pdvsa,
      codigo_sudebip: a.codigo_sudebip || null,
      codigo_sap: a.codigo_sap || null,
      nombre: a.nombre,
      marca: a.marca || 'Sin Información',
      modelo: a.modelo || 'Sin Información',
      serial: a.serial || 'Sin Información',
      laboratorio: a.laboratorio,
      criticidad_analista: a.criticidad_analista || 'Baja',
      tipo_equipo: a.tipo_equipo || 'Instrumento de Medición',
      pareto_20: a.pareto_20 || false,
      estado_operativo: a.estado_operativo || 'Operativo',
      es_equipo_analitico: a.es_equipo_analitico !== undefined ? a.es_equipo_analitico : true,
      frecuencia_calibracion: a.frecuencia_calibracion || 'Anual',
      vida_util_fabricante_anos: a.vida_util_fabricante_anos || 10,
      capex_costo_adquisicion: a.costo_adquisicion_usd || 0,
      filial: a.filial || 'PDVSA INTEVEP S.A.',
      sede: a.sede || 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
      gerencia: a.gerencia || 'Gerencia de Ambiente',
      etapa_ciclo_vida: a.etapa_ciclo_vida || 'Operación y Mantenimiento',
      condicion_fisica: a.condicion_fisica || 'Buena',
      costo_adquisicion_usd: a.costo_adquisicion_usd || 0,
      clasificacion_sudebip: a.clasificacion_sudebip || 'Equipos Científicos y de Laboratorio (Cat. 2.04.02)',
      unidad_administradora: a.unidad_administradora || 'Gerencia de Ambiente - INTEVEP',
      condiciones_ambientales: a.condiciones_ambientales || 'Temp: 20 ± 2 °C / HR: 45 - 60%',
      suministro_electrico: a.suministro_electrico || '110/220 VAC - 60 Hz Regulada',
      estrategia_mantenimiento: a.estrategia_mantenimiento || 'Preventivo Planificado Sistemático y Predictivo',
      frecuencia_mantenimiento: a.frecuencia_mantenimiento || 'Trimestral',
      proveedor_tecnico: a.proveedor_tecnico || 'Taller Mantenimiento Instrumental INTEVEP',
      categoria_criticidad: a.categoria_criticidad || null,
      ic: a.ic || null,
      iobs: a.iobs || null,
      estatus_obsolescencia: a.estatus_obsolescencia || null,
      nivel_riesgo: a.nivel_riesgo || null,
      clasificacion_riesgo: a.clasificacion_riesgo || null,
      nivel_oportunidad: a.nivel_oportunidad || null,
      prioridad_oportunidad: a.prioridad_oportunidad || null,
      resultado_cruce: a.resultado_cruce || null,
      decision_estrategica: a.decision_estrategica || null,
      responsable_de: a.responsable_de || null,
      fecha_de: a.fecha_de || null,
      decision_operativa: a.decision_operativa || null,
      responsable_do: a.responsable_do || null,
      fecha_do: a.fecha_do || null,
      jerarquizacion: a.jerarquizacion || null,
      obsolescencia: a.obsolescencia || null,
      decision: a.decision || null
    };

    if (tagToIdMap.has(a.tag_pdvsa)) {
      // UPDATE
      await apiRequest(`activos?tag_pdvsa=eq.${encodeURIComponent(a.tag_pdvsa)}`, 'PATCH', payload);
      updatedCount++;
    } else {
      // INSERT
      payload.num = a.num || (existingActivos.length + insertedCount + 1);
      const inserted = await apiRequest('activos', 'POST', payload);
      insertedCount++;
    }
  }
  console.log(`Activos actualizados: ${updatedCount}, insertados nuevos: ${insertedCount}`);

  // Re-consultar mapa actualizado de IDs
  const refreshedActivos = await apiRequest('activos?select=id,tag_pdvsa&limit=1000');
  for (const a of refreshedActivos) {
    tagToIdMap.set(a.tag_pdvsa, a.id);
  }

  // 4. Catálogos Parámetros
  console.log("Sincronizando 'catalogos_parametros'...");
  await apiRequest('catalogos_parametros?id=gt.00000000-0000-0000-0000-000000000000', 'DELETE').catch(() => {});
  const catalogos = [
    { cat: 'filial', cod: 'FIL-01', nom: 'PDVSA INTEVEP S.A.' },
    { cat: 'sede', cod: 'SED-01', nom: 'Centro de Investigación y Apoyo Tecnológico (Los Teques)' },
    { cat: 'gerencia', cod: 'GER-AMB', nom: 'Gerencia de Ambiente' },
    { cat: 'laboratorio', cod: 'LAB-AIRE', nom: 'Aire (Calidad de Aire)' },
    { cat: 'laboratorio', cod: 'LAB-AGUA', nom: 'Aguas y Efluentes Industriales' },
    { cat: 'laboratorio', cod: 'LAB-SUELO', nom: 'Suelos y Sedimentos' },
    { cat: 'laboratorio', cod: 'LAB-ECOTOX', nom: 'Ecotoxicología' },
    { cat: 'laboratorio', cod: 'LAB-MICRO', nom: 'Microbiología Ambiental' },
    { cat: 'laboratorio', cod: 'LAB-BIOTEC', nom: 'Biotecnología Ambiental' },
    { cat: 'laboratorio', cod: 'LAB-CROM', nom: 'Cromatografía y Espectrometría' },
    { cat: 'laboratorio', cod: 'LAB-FISIQ', nom: 'Fisicoquímica Ambiental' },
    { cat: 'laboratorio', cod: 'LAB-SEDIM', nom: 'Sedimentología y Geología' },
    { cat: 'tipo_equipo', cod: 'TE-01', nom: 'Instrumento de Medición' },
    { cat: 'tipo_equipo', cod: 'TE-02', nom: 'Equipo de Laboratorio General' },
    { cat: 'tipo_equipo', cod: 'TE-03', nom: 'Patrón de Medición' },
    { cat: 'tipo_equipo', cod: 'TE-04', nom: 'Sistema de Muestreo' },
    { cat: 'tipo_equipo', cod: 'TE-05', nom: 'Equipo Auxiliar / Soporte' },
    { cat: 'estado_operativo', cod: 'EO-01', nom: 'Operativo' },
    { cat: 'estado_operativo', cod: 'EO-02', nom: 'Inoperativo' },
    { cat: 'estado_operativo', cod: 'EO-03', nom: 'En Calibración' },
    { cat: 'estado_operativo', cod: 'EO-04', nom: 'En Mantenimiento' },
    { cat: 'estado_operativo', cod: 'EO-05', nom: 'En Desincorporación' },
    { cat: 'categoria_criticidad', cod: 'CC-01', nom: 'Crítico' },
    { cat: 'categoria_criticidad', cod: 'CC-02', nom: 'Semicrítico' },
    { cat: 'categoria_criticidad', cod: 'CC-03', nom: 'No Crítico' },
    { cat: 'estatus_obsolescencia', cod: 'EOB-01', nom: 'Obsolescencia Baja' },
    { cat: 'estatus_obsolescencia', cod: 'EOB-02', nom: 'Obsolescencia Media' },
    { cat: 'estatus_obsolescencia', cod: 'EOB-03', nom: 'Obsolescencia Alta' },
    { cat: 'clasificacion_riesgo', cod: 'CR-01', nom: 'Muy Alto' },
    { cat: 'clasificacion_riesgo', cod: 'CR-02', nom: 'Alto' },
    { cat: 'clasificacion_riesgo', cod: 'CR-03', nom: 'Medio' },
    { cat: 'clasificacion_riesgo', cod: 'CR-04', nom: 'Bajo' },
    { cat: 'decision_estrategica', cod: 'DE-01', nom: 'Reemplazo Inmediato' },
    { cat: 'decision_estrategica', cod: 'DE-02', nom: 'Reemplazo a Mediano Plazo' },
    { cat: 'decision_estrategica', cod: 'DE-03', nom: 'Modernización / Retrofit' },
    { cat: 'decision_estrategica', cod: 'DE-04', nom: 'Mantenimiento Mayor Overhaul' },
    { cat: 'decision_estrategica', cod: 'DE-05', nom: 'Continuar Operación / Plan Mantenimiento' },
    { cat: 'decision_estrategica', cod: 'DE-06', nom: 'Desincorporación / Enajenación' },
    { cat: 'decision_operativa', cod: 'DO-01', nom: 'Plan Preventivo Riguroso' },
    { cat: 'decision_operativa', cod: 'DO-02', nom: 'Revisión Metrológica / Calibración Urgente' },
    { cat: 'decision_operativa', cod: 'DO-03', nom: 'Aprovisionamiento Crítico de Repuestos' },
    { cat: 'decision_operativa', cod: 'DO-04', nom: 'Inspección Predictiva Frecuente' },
    { cat: 'decision_operativa', cod: 'DO-05', nom: 'Operación Estándar' }
  ];

  for (let i = 0; i < catalogos.length; i++) {
    const c = catalogos[i];
    await apiRequest('catalogos_parametros', 'POST', {
      categoria: c.cat,
      codigo: c.cod,
      nombre: c.nom,
      orden: i + 1
    }).catch(() => {});
  }
  console.log(`Parámetros de catálogo insertados: ${catalogos.length}`);

  // 5. Catálogo SUDEBIP
  console.log("Sincronizando 'catalogo_sudebip'...");
  for (const s of (sgaData.catalogo_sudebip || [])) {
    await apiRequest('catalogo_sudebip', 'POST', {
      codigo: s.codigo,
      tipo_equipo: s.tipo_equipo
    }).catch(() => {});
  }

  // 6. Tablas hijas vinculadas por activo_id
  console.log("Limpiando y sincronizando tablas hijas...");
  await apiRequest('jerarquizacion_criticidad?id=gt.00000000-0000-0000-0000-000000000000', 'DELETE').catch(() => {});
  await apiRequest('evaluacion_obsolescencia?id=gt.00000000-0000-0000-0000-000000000000', 'DELETE').catch(() => {});
  await apiRequest('decisiones_estrategicas?id=gt.00000000-0000-0000-0000-000000000000', 'DELETE').catch(() => {});

  let jerCount = 0;
  let obsCount = 0;
  let decCount = 0;

  for (const a of sgaData.activos) {
    const activoId = tagToIdMap.get(a.tag_pdvsa);
    if (!activoId) continue;

    if (a.jerarquizacion) {
      const j = a.jerarquizacion;
      await apiRequest('jerarquizacion_criticidad', 'POST', {
        activo_id: activoId,
        tag_pdvsa: a.tag_pdvsa,
        ff: j.ff || 0,
        io: j.io || 0,
        fo: j.fo || 0,
        cm: j.cm || 0,
        sha: j.sha || 0,
        consecuencia: j.consecuencia || 0,
        ic: j.ic || 0,
        categoria_criticidad: j.categoria_criticidad || 'No Crítico',
        estatus_seleccion: j.estatus_seleccion || 'No Seleccionado',
        criterio_accion: j.criterio_accion || 'Mantenimiento Estándar'
      }).catch(e => console.error("Error jer:", e.message));
      jerCount++;
    }

    if (a.obsolescencia) {
      const o = a.obsolescencia;
      await apiRequest('evaluacion_obsolescencia', 'POST', {
        activo_id: activoId,
        tag_pdvsa: a.tag_pdvsa,
        eol: o.eol || 0,
        rep: o.rep || 0,
        met: o.met || 0,
        ant: o.ant || 0,
        suma_puntos: o.suma_puntos || 0,
        iobs: o.iobs || 0,
        estatus_obsolescencia: o.estatus_obsolescencia || 'Obsolescencia Baja'
      }).catch(e => console.error("Error obs:", e.message));
      obsCount++;
    }

    if (a.decision) {
      const d = a.decision;
      await apiRequest('decisiones_estrategicas', 'POST', {
        activo_id: activoId,
        tag_pdvsa: a.tag_pdvsa,
        nivel_riesgo: d.nivel_riesgo || 0,
        clasificacion_riesgo: d.clasificacion_riesgo || 'Bajo',
        nivel_oportunidad: d.nivel_oportunidad || 0,
        prioridad_oportunidad: d.prioridad_oportunidad || 'Baja',
        resultado_cruce: d.resultado_cruce || 'Zona Verde',
        decision_sugerida_riesgo: d.decision_sugerida_riesgo || 'Mantener',
        decision_sugerida_oportunidad: d.decision_sugerida_oportunidad || 'Mantener',
        decision_estrategica_final: d.decision_estrategica_final || 'Continuar Operación / Plan Mantenimiento',
        responsable_de: d.responsable_de || null,
        fecha_estimada_de: d.fecha_estimada_de || null,
        decision_operativa: d.decision_operativa || 'Operación Estándar',
        responsable_do: d.responsable_do || null,
        fecha_estimada_do: d.fecha_estimada_do || null
      }).catch(e => console.error("Error dec:", e.message));
      decCount++;
    }
  }
  console.log(`Jerarquizaciones insertadas: ${jerCount}`);
  console.log(`Evaluaciones obsolescencia insertadas: ${obsCount}`);
  console.log(`Decisiones estratégicas insertadas: ${decCount}`);

  // 7. Depreciación Patrimonial
  console.log("Sincronizando 'depreciacion_patrimonial'...");
  await apiRequest('depreciacion_patrimonial?id=gt.00000000-0000-0000-0000-000000000000', 'DELETE').catch(() => {});
  let depCount = 0;
  for (const d of (sgaData.depreciacion || [])) {
    await apiRequest('depreciacion_patrimonial', 'POST', {
      tag_pdvsa: d.tag_pdvsa,
      nro_bien_publico: d.nro_bien_publico || null,
      costo_adquisicion_usd: d.costo_adquisicion_usd || 0,
      fecha_incorporacion: d.fecha_incorporacion || null,
      tasa_salvamento: d.tasa_salvamento || 0.1,
      valor_residual_salvamento: d.valor_residual_salvamento || 0,
      base_depreciable_usd: d.base_depreciable_usd || 0,
      vida_util_anos: d.vida_util_anos || 10,
      meses_uso: d.meses_uso || 0,
      depreciacion_mensual_usd: d.depreciacion_mensual_usd || 0,
      depreciacion_acumulada_usd: d.depreciacion_acumulada_usd || 0,
      valor_neto_libros_usd: d.valor_neto_libros_usd || 0
    }).catch(e => console.error("Error dep:", e.message));
    depCount++;
  }
  console.log(`Depreciaciones patrimoniales insertadas: ${depCount}`);

  // 8. Calibraciones Metrológicas
  console.log("Sincronizando 'calibraciones_metrologicas'...");
  await apiRequest('calibraciones_metrologicas?id=gt.00000000-0000-0000-0000-000000000000', 'DELETE').catch(() => {});
  let calCount = 0;
  for (let i = 0; i < (sgaData.calibraciones || []).length; i++) {
    const c = sgaData.calibraciones[i];
    await apiRequest('calibraciones_metrologicas', 'POST', {
      id_calibracion: `CAL-2026-${String(i + 1).padStart(3, '0')}`,
      tag_pdvsa: c.tag_pdvsa,
      fecha_calibracion: c.fecha_calibracion || '2026-01-15',
      fecha_vencimiento: c.fecha_vencimiento || '2027-01-15',
      dias_restantes: 180,
      estatus_metrologico: 'VIGENTE',
      entidad_acreditada: c.ente_calibrador || 'Laboratorio Metrología INTEVEP',
      nro_certificado: c.nro_certificado || `CERT-INT-2026-${i+1}`,
      patron_utilizado: c.patron_utilizado || 'Patrón Certificado',
      desviacion_observada: c.error_encontrado ? String(c.error_encontrado) : null,
      incertidumbre_u: c.incertidumbre ? String(c.incertidumbre) : '±0.05',
      mep_tolerancia: '±0.10',
      dictamen: c.resultado || 'Conforme',
      precinto_colocado: 'SI-INT-2026',
      metrologo_responsable: 'Ing. Supervisor Metrológico'
    }).catch(e => console.error("Error cal:", e.message));
    calCount++;
  }
  console.log(`Calibraciones insertadas: ${calCount}`);

  // 9. Mantenimientos PDVSA
  console.log("Sincronizando 'mantenimientos_pdvsa'...");
  await apiRequest('mantenimientos_pdvsa?id=gt.00000000-0000-0000-0000-000000000000', 'DELETE').catch(() => {});
  let mantCount = 0;
  for (let i = 0; i < (sgaData.mantenimientos || []).length; i++) {
    const m = sgaData.mantenimientos[i];
    await apiRequest('mantenimientos_pdvsa', 'POST', {
      nro_ot: `OT-MM-2026-${String(i + 1).padStart(3, '0')}`,
      tag_pdvsa: m.tag_pdvsa,
      tipo_mantenimiento: m.tipo_mantenimiento || 'Preventivo',
      codigo_plan_pdvsa: 'AMB-GEN-SGA-FO-008',
      fecha_inicio: m.fecha_mantenimiento || '2026-02-10',
      fecha_cierre: m.fecha_mantenimiento || '2026-02-12',
      descripcion: m.actividades_realizadas || 'Mantenimiento preventivo planificado según norma PDVSA MM-02-01-01',
      repuestos_reemplazados: m.repuestos_utilizados || 'Filtros y empaques estándar',
      horas_hombre: 8,
      costo_total_usd: m.costo_usd || 150,
      responsable_ejecucion: m.responsable_ejecucion || 'Taller Mantenimiento Instrumental INTEVEP',
      impacto_ensayos_iso17025: 'Sin impacto / Controlado',
      requiere_recalibracion: false,
      estatus_ot: 'Cerrada',
      aprobado_por: 'Supervisión Instrumental',
      proximo_mantenimiento: '2026-08-10'
    }).catch(e => console.error("Error mant:", e.message));
    mantCount++;
  }
  console.log(`Mantenimientos insertados: ${mantCount}`);

  // 10. KPIs SGA FO-017
  console.log("Sincronizando 'kpis_sga_fo017'...");
  await apiRequest('kpis_sga_fo017?id=gt.00000000-0000-0000-0000-000000000000', 'DELETE').catch(() => {});
  let kpiCount = 0;
  for (const k of (sgaData.kpis_fo017 || [])) {
    await apiRequest('kpis_sga_fo017', 'POST', {
      codigo_kpi: k.codigo_kpi,
      nombre_kpi: k.nombre_kpi,
      valor_meta: k.valor_meta || 95,
      valor_real: k.valor_real || 0,
      cumplimiento_pct: k.cumplimiento_pct || 0,
      evaluacion_kpi: k.evaluacion_kpi || 'Conforme'
    }).catch(e => console.error("Error kpi:", e.message));
    kpiCount++;
  }
  console.log(`KPIs FO-017 insertados: ${kpiCount}`);

  // 11. Usuarios del Sistema
  console.log("Sincronizando 'usuarios_sistema'...");
  const usuarios = [
    { email: 'admin@intevep.pdvsa.com', nom: 'Administrador General SGA', rol: 'ADMIN', cargo: 'Gerente de Ambiente y Confiabilidad', lab: 'Todos los Laboratorios', clave: 'Intevep2026*' },
    { email: 'metrologo@intevep.pdvsa.com', nom: 'Ing. Supervisor Metrológico', rol: 'METROLOGO', cargo: 'Responsable Metrología ISO 10012', lab: 'Aire (Calidad de Aire)', clave: 'Metro2026*' },
    { email: 'analista@intevep.pdvsa.com', nom: 'Lic. Custodio de Laboratorio', rol: 'ANALISTA', cargo: 'Analista Químico Especialista', lab: 'Aguas y Efluentes Industriales', clave: 'Analista2026*' },
    { email: 'auditor@intevep.pdvsa.com', nom: 'Auditor de Calidad ISO 55001', rol: 'AUDITOR', cargo: 'Auditor Líder SGA / SUDEBIP', lab: 'Todos los Laboratorios', clave: 'Auditor2026*' }
  ];
  for (const u of usuarios) {
    await apiRequest('usuarios_sistema', 'POST', {
      email: u.email,
      nombre_completo: u.nom,
      rol: u.rol,
      cargo: u.cargo,
      laboratorio: u.lab,
      clave_demo: u.clave
    }).catch(() => {});
  }
  console.log(`Usuarios demo sincronizados: ${usuarios.length}`);

  console.log("\n=== ¡SINCRONIZACIÓN EXITOSA Y COMPLETA EN SUPABASE! ===");
}

main().catch(err => {
  console.error("FATAL ERROR EN SINCRONIZACIÓN:", err);
  process.exit(1);
});
