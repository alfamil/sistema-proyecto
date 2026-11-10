import json

def sql_escape(val):
    if val is None:
        return "NULL"
    if isinstance(val, bool):
        return "TRUE" if val else "FALSE"
    if isinstance(val, (int, float)):
        return str(val)
    if isinstance(val, dict):
        return "'" + json.dumps(val, ensure_ascii=False).replace("'", "''") + "'::jsonb"
    s = str(val).replace("'", "''")
    return f"'{s}'"

with open('sga_data.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

sql_lines = []

sql_lines.append("""-- ==============================================================================
-- SIGAF INTEVEP • SISTEMA INTEGRADO DE GESTIÓN DE ACTIVOS FÍSICOS
-- IMPORTACIÓN DE DATA 100% REAL DE LA HERRAMIENTA OFICIAL SGA
-- Fuente: herramienta_sga.xlsx / hoja_de_vida_integral.xlsx / formularios_anexos_sga.xlsx
-- ==============================================================================

-- 1. ASEGURAR EXTENSIÓN UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- 2. ASEGURAR COLUMNAS EN TABLA ACTIVOS
CREATE TABLE IF NOT EXISTS activos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    num NUMERIC,
    tag_pdvsa TEXT UNIQUE NOT NULL,
    codigo_sudebip TEXT,
    codigo_sap TEXT,
    nombre TEXT NOT NULL,
    marca TEXT,
    modelo TEXT,
    serial TEXT,
    laboratorio TEXT,
    criticidad_analista TEXT,
    tipo_equipo TEXT,
    pareto_20 BOOLEAN DEFAULT FALSE,
    estado_operativo TEXT DEFAULT 'Operativo',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE activos 
  ADD COLUMN IF NOT EXISTS filial TEXT DEFAULT 'PDVSA INTEVEP S.A.',
  ADD COLUMN IF NOT EXISTS sede TEXT DEFAULT 'Centro de Investigación y Apoyo Tecnológico (Los Teques)',
  ADD COLUMN IF NOT EXISTS gerencia TEXT DEFAULT 'Gerencia de Ambiente',
  ADD COLUMN IF NOT EXISTS sistema TEXT,
  ADD COLUMN IF NOT EXISTS custodio TEXT,
  ADD COLUMN IF NOT EXISTS etapa_ciclo_vida TEXT DEFAULT 'Operación y Mantenimiento',
  ADD COLUMN IF NOT EXISTS fecha_puesta_servicio DATE,
  ADD COLUMN IF NOT EXISTS numero_etiqueta_qr TEXT,
  ADD COLUMN IF NOT EXISTS condicion_fisica TEXT DEFAULT 'Buena',
  ADD COLUMN IF NOT EXISTS costo_adquisicion_usd NUMERIC DEFAULT 0,
  ADD COLUMN IF NOT EXISTS clasificacion_sudebip TEXT DEFAULT 'Equipos Científicos y de Laboratorio (Cat. 2.04.02)',
  ADD COLUMN IF NOT EXISTS unidad_administradora TEXT DEFAULT 'Gerencia de Ambiente - INTEVEP',
  ADD COLUMN IF NOT EXISTS responsable_patrimonial TEXT,
  ADD COLUMN IF NOT EXISTS rango_medicion TEXT,
  ADD COLUMN IF NOT EXISTS limite_deteccion TEXT,
  ADD COLUMN IF NOT EXISTS mep TEXT,
  ADD COLUMN IF NOT EXISTS condiciones_ambientales TEXT DEFAULT 'Temp: 20 ± 2 °C / HR: 45 - 60%',
  ADD COLUMN IF NOT EXISTS suministro_electrico TEXT DEFAULT '110/220 VAC - 60 Hz Regulada',
  ADD COLUMN IF NOT EXISTS frecuencia_calibracion TEXT DEFAULT 'Anual',
  ADD COLUMN IF NOT EXISTS estrategia_mantenimiento TEXT DEFAULT 'Preventivo Planificado Sistemático y Predictivo',
  ADD COLUMN IF NOT EXISTS frecuencia_mantenimiento TEXT DEFAULT 'Trimestral',
  ADD COLUMN IF NOT EXISTS proveedor_tecnico TEXT DEFAULT 'Taller Mantenimiento Instrumental INTEVEP',
  ADD COLUMN IF NOT EXISTS categoria_criticidad TEXT,
  ADD COLUMN IF NOT EXISTS ic NUMERIC,
  ADD COLUMN IF NOT EXISTS iobs NUMERIC,
  ADD COLUMN IF NOT EXISTS estatus_obsolescencia TEXT,
  ADD COLUMN IF NOT EXISTS nivel_riesgo NUMERIC,
  ADD COLUMN IF NOT EXISTS clasificacion_riesgo TEXT,
  ADD COLUMN IF NOT EXISTS nivel_oportunidad NUMERIC,
  ADD COLUMN IF NOT EXISTS prioridad_oportunidad TEXT,
  ADD COLUMN IF NOT EXISTS resultado_cruce TEXT,
  ADD COLUMN IF NOT EXISTS decision_estrategica TEXT,
  ADD COLUMN IF NOT EXISTS responsable_de TEXT,
  ADD COLUMN IF NOT EXISTS fecha_de DATE,
  ADD COLUMN IF NOT EXISTS decision_operativa TEXT,
  ADD COLUMN IF NOT EXISTS responsable_do TEXT,
  ADD COLUMN IF NOT EXISTS fecha_do DATE,
  ADD COLUMN IF NOT EXISTS jerarquizacion JSONB,
  ADD COLUMN IF NOT EXISTS obsolescencia JSONB,
  ADD COLUMN IF NOT EXISTS decision JSONB;

-- 3. TABLAS DE RELACIONES
CREATE TABLE IF NOT EXISTS catalogo_sudebip (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    codigo TEXT UNIQUE NOT NULL,
    tipo_equipo TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS jerarquizacion_criticidad (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    activo_id UUID REFERENCES activos(id) ON DELETE CASCADE,
    tag_pdvsa TEXT NOT NULL,
    ff NUMERIC,
    io NUMERIC,
    fo NUMERIC,
    cm NUMERIC,
    sha NUMERIC,
    consecuencia NUMERIC,
    ic NUMERIC,
    categoria_criticidad TEXT,
    estatus_seleccion TEXT,
    criterio_accion TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS evaluacion_obsolescencia (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    activo_id UUID REFERENCES activos(id) ON DELETE CASCADE,
    tag_pdvsa TEXT NOT NULL,
    eol NUMERIC,
    rep NUMERIC,
    met NUMERIC,
    ant NUMERIC,
    suma_puntos NUMERIC,
    iobs NUMERIC,
    estatus_obsolescencia TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS decisiones_estrategicas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    activo_id UUID REFERENCES activos(id) ON DELETE CASCADE,
    tag_pdvsa TEXT NOT NULL,
    nivel_riesgo NUMERIC,
    clasificacion_riesgo TEXT,
    nivel_oportunidad NUMERIC,
    prioridad_oportunidad TEXT,
    resultado_cruce TEXT,
    decision_sugerida_riesgo TEXT,
    decision_sugerida_oportunidad TEXT,
    decision_estrategica_final TEXT,
    responsable_de TEXT,
    fecha_estimada_de DATE,
    decision_operativa TEXT,
    responsable_do TEXT,
    fecha_estimada_do DATE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS calibraciones_metrologicas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_calibracion TEXT NOT NULL,
    tag_pdvsa TEXT NOT NULL,
    nro_certificado TEXT NOT NULL,
    fecha_calibracion DATE NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    dias_restantes INT,
    estatus_metrologico TEXT NOT NULL,
    entidad_acreditada TEXT NOT NULL,
    patron_utilizado TEXT,
    desviacion_observada TEXT,
    incertidumbre_u TEXT,
    mep_tolerancia TEXT,
    dictamen TEXT,
    precinto_colocado TEXT,
    metrologo_responsable TEXT,
    observaciones TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS mantenimientos_pdvsa (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nro_ot TEXT NOT NULL,
    tag_pdvsa TEXT NOT NULL,
    tipo_mantenimiento TEXT NOT NULL,
    codigo_plan_pdvsa TEXT,
    fecha_inicio DATE NOT NULL,
    fecha_cierre DATE,
    descripcion TEXT NOT NULL,
    repuestos_reemplazados TEXT,
    horas_hombre NUMERIC DEFAULT 0,
    costo_total_usd NUMERIC DEFAULT 0,
    responsable_ejecucion TEXT,
    impacto_ensayos_iso17025 TEXT,
    requiere_recalibracion BOOLEAN DEFAULT FALSE,
    estatus_ot TEXT NOT NULL,
    aprobado_por TEXT,
    proximo_mantenimiento DATE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS comprobaciones_intermedias (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nro_registro TEXT NOT NULL,
    tag_pdvsa TEXT NOT NULL,
    fecha_comprobacion DATE NOT NULL,
    patron_verificacion TEXT NOT NULL,
    valor_nominal_patron NUMERIC,
    lectura_instrumento NUMERIC,
    desviacion_calculada NUMERIC,
    criterio_aceptacion_mep NUMERIC,
    dictamen_auto TEXT,
    analista_ejecutor TEXT,
    supervisor_validador TEXT,
    rotulado_operativo TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS deriva_metrologica_fo018 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tag_pdvsa TEXT NOT NULL,
    magnitud TEXT NOT NULL,
    ltm_ppm NUMERIC NOT NULL,
    fecha_cal_base DATE,
    error_base NUMERIC,
    fecha_comprobacion_q3 DATE,
    error_q3 NUMERIC,
    deriva_calculada_ppm NUMERIC,
    consumo_ltm_pct NUMERIC,
    estatus_alerta TEXT,
    accion_requerida TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS depreciacion_patrimonial (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tag_pdvsa TEXT NOT NULL,
    nro_bien_publico TEXT,
    costo_adquisicion_usd NUMERIC,
    fecha_incorporacion DATE,
    tasa_salvamento NUMERIC,
    valor_residual_salvamento NUMERIC,
    base_depreciable_usd NUMERIC,
    vida_util_anos INT,
    meses_uso INT,
    depreciacion_mensual_usd NUMERIC,
    depreciacion_acumulada_usd NUMERIC,
    valor_neto_libros_usd NUMERIC,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS kpis_sga_fo017 (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    numero INT NOT NULL,
    indicador TEXT NOT NULL,
    dimension TEXT NOT NULL,
    formula TEXT,
    meta TEXT,
    frecuencia TEXT,
    responsable TEXT,
    valor_real_q3 NUMERIC,
    valor_real_texto TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS usuarios_sistema (
    id TEXT PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    nombre_completo TEXT NOT NULL,
    rol TEXT NOT NULL,
    cargo TEXT,
    laboratorio TEXT,
    clave_demo TEXT,
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS catalogos_parametros (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    categoria TEXT NOT NULL,
    codigo TEXT NOT NULL,
    nombre TEXT NOT NULL,
    orden INT DEFAULT 0,
    activo BOOLEAN DEFAULT TRUE
);

-- ==============================================================================
-- 4. LIMPIEZA PREVIA DE TABLAS (VACÍA REGISTROS OBSOLETOS/PRUEBA)
-- ==============================================================================
TRUNCATE TABLE comprobaciones_intermedias, mantenimientos_pdvsa, calibraciones_metrologicas, deriva_metrologica_fo018, depreciacion_patrimonial, kpis_sga_fo017, jerarquizacion_criticidad, evaluacion_obsolescencia, decisiones_estrategicas CASCADE;
TRUNCATE TABLE activos CASCADE;
TRUNCATE TABLE catalogo_sudebip CASCADE;
TRUNCATE TABLE catalogos_parametros CASCADE;
TRUNCATE TABLE usuarios_sistema CASCADE;

-- ==============================================================================
-- 5. INSERTAR CATÁLOGO SUDEBIP (228 CÓDIGOS OFICIALES)
-- ==============================================================================
""")

# Catalogo SUDEBIP
for s in data['catalogo_sudebip']:
    sql_lines.append(f"INSERT INTO catalogo_sudebip (codigo, tipo_equipo) VALUES ({sql_escape(s['codigo'])}, {sql_escape(s['tipo_equipo'])}) ON CONFLICT (codigo) DO NOTHING;")

# Usuarios
sql_lines.append("\n-- 6. INSERTAR USUARIOS Y ROLES\n")
for u in data['usuarios']:
    sql_lines.append(f"""INSERT INTO usuarios_sistema (id, email, nombre_completo, rol, cargo, laboratorio, clave_demo)
VALUES ({sql_escape(u['id'])}, {sql_escape(u['email'])}, {sql_escape(u['nombre_completo'])}, {sql_escape(u['rol'])}, {sql_escape(u.get('cargo'))}, {sql_escape(u.get('laboratorio'))}, {sql_escape(u.get('clave_demo'))})
ON CONFLICT (id) DO UPDATE SET clave_demo = EXCLUDED.clave_demo;""")

# Catálogos dinámicos
sql_lines.append("\n-- 7. INSERTAR CATÁLOGOS DINÁMICOS\n")
for cat, items in data['catalogos'].items():
    for idx, item in enumerate(items):
        cod = f"{cat[:4]}-{idx+1:02d}"
        sql_lines.append(f"INSERT INTO catalogos_parametros (categoria, codigo, nombre, orden) VALUES ({sql_escape(cat)}, {sql_escape(cod)}, {sql_escape(item)}, {idx+1});")

# Activos Maestros (335 activos reales de herramienta_sga.xlsx)
sql_lines.append("\n-- 8. INSERTAR 334 ACTIVOS REALES DE HERRAMIENTA SGA\n")
sql_lines.append("DO $$")
sql_lines.append("DECLARE")
sql_lines.append("    v_act_id UUID;")
sql_lines.append("BEGIN\n")

for a in data['activos']:
    dec = a.get('decision') or {}
    j = a.get('jerarquizacion') or {}
    o = a.get('obsolescencia') or {}
    
    sql_lines.append(f"""    INSERT INTO activos (
        num, tag_pdvsa, codigo_sudebip, codigo_sap, nombre, marca, modelo, serial, laboratorio, 
        criticidad_analista, tipo_equipo, pareto_20, estado_operativo, filial, sede, gerencia, 
        categoria_criticidad, ic, iobs, estatus_obsolescencia, nivel_riesgo, clasificacion_riesgo,
        nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_estrategica, responsable_de,
        fecha_de, decision_operativa, responsable_do, fecha_do, jerarquizacion, obsolescencia, decision
    ) VALUES (
        {sql_escape(a['num'])}, {sql_escape(a['tag_pdvsa'])}, {sql_escape(a['codigo_sudebip'])}, {sql_escape(a['codigo_sap'])},
        {sql_escape(a['nombre'])}, {sql_escape(a['marca'])}, {sql_escape(a['modelo'])}, {sql_escape(a['serial'])},
        {sql_escape(a['laboratorio'])}, {sql_escape(a['criticidad_analista'])}, {sql_escape(a['tipo_equipo'])},
        {sql_escape(a['pareto_20'])}, {sql_escape(a['estado_operativo'])}, {sql_escape(a['filial'])}, {sql_escape(a['sede'])},
        {sql_escape(a['gerencia'])}, {sql_escape(a['categoria_criticidad'])}, {sql_escape(a['ic'])}, {sql_escape(a['iobs'])},
        {sql_escape(a['estatus_obsolescencia'])}, {sql_escape(a['nivel_riesgo'])}, {sql_escape(a['clasificacion_riesgo'])},
        {sql_escape(a['nivel_oportunidad'])}, {sql_escape(a['prioridad_oportunidad'])}, {sql_escape(a['resultado_cruce'])},
        {sql_escape(dec.get('decision_estrategica_final'))}, {sql_escape(dec.get('responsable_de'))}, {sql_escape(dec.get('fecha_de'))},
        {sql_escape(dec.get('decision_operativa'))}, {sql_escape(dec.get('responsable_do'))}, {sql_escape(dec.get('fecha_do'))},
        {sql_escape(j)}, {sql_escape(o)}, {sql_escape(dec if dec else None)}
    ) RETURNING id INTO v_act_id;""")

    # Relaciones para los que tienen Jerarquización
    if j and j.get('ic') is not None:
        sql_lines.append(f"""    INSERT INTO jerarquizacion_criticidad (activo_id, tag_pdvsa, ff, io, fo, cm, sha, consecuencia, ic, categoria_criticidad, estatus_seleccion, criterio_accion)
    VALUES (v_act_id, {sql_escape(a['tag_pdvsa'])}, {sql_escape(j.get('ff'))}, {sql_escape(j.get('io'))}, {sql_escape(j.get('fo'))}, {sql_escape(j.get('cm'))}, {sql_escape(j.get('sha'))}, {sql_escape(j.get('consecuencia'))}, {sql_escape(j.get('ic'))}, {sql_escape(j.get('categoria_criticidad'))}, {sql_escape(j.get('estatus_seleccion'))}, {sql_escape(j.get('criterio_accion'))});""")

    # Relaciones para los que tienen Obsolescencia
    if o and o.get('iobs') is not None:
        sql_lines.append(f"""    INSERT INTO evaluacion_obsolescencia (activo_id, tag_pdvsa, eol, rep, met, ant, suma_puntos, iobs, estatus_obsolescencia)
    VALUES (v_act_id, {sql_escape(a['tag_pdvsa'])}, {sql_escape(o.get('eol'))}, {sql_escape(o.get('rep'))}, {sql_escape(o.get('met'))}, {sql_escape(o.get('ant'))}, {sql_escape(o.get('suma_puntos'))}, {sql_escape(o.get('iobs'))}, {sql_escape(o.get('estatus_obsolescencia'))});""")

    # Relaciones para los que tienen Decisiones
    if dec and dec.get('decision_estrategica_final'):
        sql_lines.append(f"""    INSERT INTO decisiones_estrategicas (activo_id, tag_pdvsa, nivel_riesgo, clasificacion_riesgo, nivel_oportunidad, prioridad_oportunidad, resultado_cruce, decision_sugerida_riesgo, decision_sugerida_oportunidad, decision_estrategica_final, responsable_de, fecha_estimada_de, decision_operativa, responsable_do, fecha_estimada_do)
    VALUES (v_act_id, {sql_escape(a['tag_pdvsa'])}, {sql_escape(a.get('nivel_riesgo'))}, {sql_escape(a.get('clasificacion_riesgo'))}, {sql_escape(a.get('nivel_oportunidad'))}, {sql_escape(a.get('prioridad_oportunidad'))}, {sql_escape(dec.get('cruce_resultado'))}, {sql_escape(dec.get('decision_sugerida_riesgo'))}, {sql_escape(dec.get('decision_sugerida_oportunidad'))}, {sql_escape(dec.get('decision_estrategica_final'))}, {sql_escape(dec.get('responsable_de'))}, {sql_escape(dec.get('fecha_de'))}, {sql_escape(dec.get('decision_operativa'))}, {sql_escape(dec.get('responsable_do'))}, {sql_escape(dec.get('fecha_do'))});""")

sql_lines.append("END $$;\n")

# Calibraciones
sql_lines.append("-- 9. INSERTAR REGISTROS DE CALIBRACIÓN METROLÓGICA (ISO 10012)\n")
for c in data['calibraciones']:
    sql_lines.append(f"""INSERT INTO calibraciones_metrologicas (
    id_calibracion, tag_pdvsa, nro_certificado, fecha_calibracion, fecha_vencimiento, dias_restantes,
    estatus_metrologico, entidad_acreditada, patron_utilizado, desviacion_observada, incertidumbre_u,
    mep_tolerancia, dictamen, precinto_colocado, metrologo_responsable, observaciones
) VALUES (
    {sql_escape(c['id_calibracion'])}, {sql_escape(c['tag_pdvsa'])}, {sql_escape(c['nro_certificado'])},
    {sql_escape(c['fecha_calibracion'])}, {sql_escape(c['fecha_vencimiento'])}, {sql_escape(c['dias_restantes'])},
    {sql_escape(c['estatus_metrologico'])}, {sql_escape(c['entidad_acreditada'])}, {sql_escape(c.get('patron_utilizado'))},
    {sql_escape(c.get('desviacion_observada'))}, {sql_escape(c.get('incertidumbre_u'))}, {sql_escape(c.get('mep_tolerancia'))},
    {sql_escape(c['dictamen'])}, {sql_escape(c.get('precinto_colocado'))}, {sql_escape(c.get('metrologo_responsable'))},
    {sql_escape(c.get('observaciones'))}
);""")

# Mantenimientos
sql_lines.append("\n-- 10. INSERTAR MANTENIMIENTOS PDVSA (FO-008)\n")
for m in data['mantenimientos']:
    sql_lines.append(f"""INSERT INTO mantenimientos_pdvsa (
    nro_ot, tag_pdvsa, tipo_mantenimiento, codigo_plan_pdvsa, fecha_inicio, fecha_cierre, descripcion,
    repuestos_reemplazados, horas_hombre, costo_total_usd, responsable_ejecucion, impacto_ensayos_iso17025,
    requiere_recalibracion, estatus_ot, aprobado_por, proximo_mantenimiento
) VALUES (
    {sql_escape(m['nro_ot'])}, {sql_escape(m['tag_pdvsa'])}, {sql_escape(m['tipo_mantenimiento'])},
    {sql_escape(m.get('codigo_plan_pdvsa'))}, {sql_escape(m['fecha_inicio'])}, {sql_escape(m.get('fecha_cierre'))},
    {sql_escape(m['descripcion'])}, {sql_escape(m.get('repuestos_reemplazados'))}, {sql_escape(m['horas_hombre'])},
    {sql_escape(m['costo_total_usd'])}, {sql_escape(m['responsable_ejecucion'])}, {sql_escape(m.get('impacto_ensayos_iso17025'))},
    {sql_escape(m.get('requiere_recalibracion', False))}, {sql_escape(m['estatus_ot'])}, {sql_escape(m.get('aprobado_por'))},
    {sql_escape(m.get('proximo_mantenimiento'))}
);""")

# Comprobaciones intermedias
sql_lines.append("\n-- 11. INSERTAR COMPROBACIONES INTERMEDIAS (ISO 17025)\n")
for ci in data['comprobaciones']:
    sql_lines.append(f"""INSERT INTO comprobaciones_intermedias (
    nro_registro, tag_pdvsa, fecha_comprobacion, patron_verificacion, valor_nominal_patron, lectura_instrumento,
    desviacion_calculada, criterio_aceptacion_mep, dictamen_auto, analista_ejecutor, supervisor_validador, rotulado_operativo
) VALUES (
    {sql_escape(ci['nro_registro'])}, {sql_escape(ci['tag_pdvsa'])}, {sql_escape(ci['fecha_comprobacion'])},
    {sql_escape(ci['patron_verificacion'])}, {sql_escape(ci['valor_nominal_patron'])}, {sql_escape(ci['lectura_instrumento'])},
    {sql_escape(ci['desviacion_calculada'])}, {sql_escape(ci['criterio_aceptacion_mep'])}, {sql_escape(ci['dictamen_auto'])},
    {sql_escape(ci['analista_ejecutor'])}, {sql_escape(ci['supervisor_validador'])}, {sql_escape(ci['rotulado_operativo'])}
);""")

# Deriva FO-018
sql_lines.append("\n-- 12. INSERTAR DERIVA METROLÓGICA (FO-018)\n")
for d in data['deriva_fo018']:
    sql_lines.append(f"""INSERT INTO deriva_metrologica_fo018 (
    tag_pdvsa, magnitud, ltm_ppm, fecha_cal_base, error_base, fecha_comprobacion_q3, error_q3,
    deriva_calculada_ppm, consumo_ltm_pct, estatus_alerta, accion_requerida
) VALUES (
    {sql_escape(d['tag_pdvsa'])}, {sql_escape(d['magnitud'])}, {sql_escape(d['ltm_ppm'])},
    {sql_escape(d.get('fecha_cal_base'))}, {sql_escape(d.get('error_base'))}, {sql_escape(d.get('fecha_comprobacion_q3'))},
    {sql_escape(d.get('error_q3'))}, {sql_escape(d['deriva_calculada_ppm'])}, {sql_escape(d['consumo_ltm_pct'])},
    {sql_escape(d['estatus_alerta'])}, {sql_escape(d.get('accion_requerida'))}
);""")

# Depreciaciones
sql_lines.append("\n-- 13. INSERTAR CONTROL PATRIMONIAL SUDEBIP Y DEPRECIACIÓN\n")
for dep in data['depreciaciones']:
    sql_lines.append(f"""INSERT INTO depreciacion_patrimonial (
    tag_pdvsa, nro_bien_publico, costo_adquisicion_usd, fecha_incorporacion, tasa_salvamento,
    valor_residual_salvamento, base_depreciable_usd, vida_util_anos, meses_uso,
    depreciacion_mensual_usd, depreciacion_acumulada_usd, valor_neto_libros_usd
) VALUES (
    {sql_escape(dep['tag_pdvsa'])}, {sql_escape(dep.get('nro_bien_publico'))}, {sql_escape(dep['costo_adquisicion_usd'])},
    {sql_escape(dep.get('fecha_incorporacion'))}, {sql_escape(dep['tasa_salvamento'])}, {sql_escape(dep['valor_residual_salvamento'])},
    {sql_escape(dep['base_depreciable_usd'])}, {sql_escape(dep['vida_util_anos'])}, {sql_escape(dep['meses_uso'])},
    {sql_escape(dep['depreciacion_mensual_usd'])}, {sql_escape(dep['depreciacion_acumulada_usd'])}, {sql_escape(dep['valor_neto_libros_usd'])}
);""")

# KPIs SGA FO-017
sql_lines.append("\n-- 14. INSERTAR KPIS SGA (FO-017)\n")
for k in data['kpis_sga_fo017']:
    sql_lines.append(f"""INSERT INTO kpis_sga_fo017 (
    numero, indicador, dimension, formula, meta, frecuencia, responsable, valor_real_q3, valor_real_texto
) VALUES (
    {sql_escape(k['numero'])}, {sql_escape(k['indicador'])}, {sql_escape(k['dimension'])},
    {sql_escape(k.get('formula'))}, {sql_escape(k.get('meta'))}, {sql_escape(k.get('frecuencia'))},
    {sql_escape(k.get('responsable'))}, {sql_escape(k.get('valor_real_q3'))}, {sql_escape(k.get('valor_real_texto'))}
);""")

sql_lines.append("""
-- ==============================================================================
-- 15. VERIFICACIÓN FINAL DE CONTEOS
-- ==============================================================================
SELECT 
    (SELECT COUNT(*) FROM activos) AS total_activos,
    (SELECT COUNT(*) FROM activos WHERE pareto_20 = TRUE) AS total_pareto_20,
    (SELECT COUNT(*) FROM catalogo_sudebip) AS total_catalogo_sudebip,
    (SELECT COUNT(*) FROM jerarquizacion_criticidad) AS total_jerarquizacion,
    (SELECT COUNT(*) FROM evaluacion_obsolescencia) AS total_obsolescencia,
    (SELECT COUNT(*) FROM decisiones_estrategicas) AS total_decisiones;
""")

with open('supabase_real_data_import.sql', 'w', encoding='utf-8') as f:
    f.write('\n'.join(sql_lines))

print("supabase_real_data_import.sql generado exitosamente.")

